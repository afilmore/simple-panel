/***********************************************************************************************************************
 *      
 *      MenuApplet.vala
 * 
 *      This software is a simple experimental (and shitty) Panel.
 *      The "S" of SPanel can be either simple or shitty.
 *      That thing is my very first Gtk+ program.
 *      
 *      Copyright 2012 Axel FILMORE <axel.filmore@gmail.com>
 * 
 *      This program is free software; you can redistribute it and/or modify
 *      it under the terms of the GNU General Public License Version 2.
 *      http://www.gnu.org/licenses/gpl-2.0.txt
 * 
 * 
 *      Purpose: 
 * 
 * 
 * 
 **********************************************************************************************************************/
public class MenuApplet : Gtk.EventBox, PanelApplet {
    
    
    private Mc.Cache        _cache;
    
    private Gdk.Pixbuf?     _pixbuf;
    private Gdk.Pixbuf?     _pixbufhigh;
    
    private Gtk.Image       _image;
    
    private Gtk.Menu        _main_menu;
    
    
    public MenuApplet () {
    }
    
    
    public static GLib.Type register_type () {return typeof (MenuApplet);}
    
    public string get_config_text () {return "\n";}
    
    
    public bool create (string config_file, int panel_id, int applet_id) {
    
        
        /*********************************************************************************
         * Initialize the menu cache.
         * 
         ********************************************************************************/
        _cache = Mc.Cache.lookup_sync ("/etc/xdg/lubuntu/menus/lxde-applications.menu");
        
        _cache.add_reload_notify ((GLib.Func) this.on_reload_menu);
        
        // TODO_axl: should be removed in the destructor....
        // Mc.remove_reload_notify ((GLib.Func) this.on_reload_menu);
        
        unowned Mc.CacheDir cache_dir = _cache.get_root_dir ();
        if (cache_dir == null)
            return false;
        
        _main_menu = new Gtk.Menu ();
        
        // Create the menu button...
        string image_path = Panel.CONFIG_DATA_DIR + "/menu.png";
        
        try {
            _pixbuf = new Gdk.Pixbuf.from_file(image_path);
            _pixbufhigh = new Gdk.Pixbuf.from_file(image_path);
        } catch (Error e) {
        }
        
        _pixbufhigh.saturate_and_pixelate (_pixbufhigh, (float) 4, false);
        
        
        _image = new Gtk.Image.from_pixbuf (_pixbuf);
        this.add (_image);

        
        this.button_release_event.connect ( (event) => {
            
            if (event.button == 1) {
                _main_menu.popup (null, null, _position_menu, 1, 0);
            }
            return true;
        });

        
        this.enter_notify_event.connect ( (event) => {
            _image.set_from_pixbuf (_pixbufhigh);
            return false;
        });
        
        this.leave_notify_event.connect ( (event) => {
            _image.set_from_pixbuf (_pixbuf);
            return false;
        });

        
        // Create the application menu...
        this._insert_items_recursive (cache_dir, _main_menu);
        
        _main_menu.append (new Gtk.SeparatorMenuItem ());
        
        
        /*********************************************************************************
         * Create default menu items.
         * 
         * 
         ********************************************************************************/
        Gtk.MenuItem mi = new Gtk.MenuItem.with_label ("Execute");
        _main_menu.append (mi);
        mi.activate.connect (() => {
            try {
                GLib.Process.spawn_command_line_async ("gtkrun");
            } catch (Error e) {
            }
        });
        
        _main_menu.append (new Gtk.SeparatorMenuItem ());
        
        mi = new Gtk.MenuItem.with_label ("Logout");
        _main_menu.append (mi);
        mi.activate.connect (() => {
            try {
                GLib.Process.spawn_command_line_async ("lxsession-logout");
            } catch (Error e) {
            }
        });
        
        _main_menu.show_all ();
        
        return true;
    }

    
    /*************************************************************************************
     * Menu position callback.
     * 
     * 
     ************************************************************************************/
    private void _position_menu (Gtk.Menu menu, out int x, out int y, out bool push_in) {
    
        int widget_x;
        int widget_y;
        int widget_width;
        int widget_height;
        int menu_width;
        int menu_height;
        
        // Get widget geometry...
        this.get_window ().get_origin (out widget_x, out widget_y);
        Gtk.Allocation rect;
        this.get_allocation (out rect);
        widget_width = rect.width;
        widget_height = rect.height;
        
        // Get menu geometry...
        Gtk.Requisition req = menu.get_requisition ();
        menu_width = req.width;
        menu_height = req.height;
        
        Gdk.Screen screen = Gdk.Screen.get_default ();
        
        int orientation = 1;

        if (orientation == 1) {
            
            // Left/Right align...
            x = widget_x;
            if (x + menu_width > screen.get_width ())
                x = widget_x + widget_width - menu_width;
            
            // Up/Below align...
            y = widget_y - menu_height;
            if (y < 0)
                y = widget_y + widget_height;
                
        } else {
            
            // Left/Right align...
            x = widget_x + widget_width;
            if (x > screen.get_width ())
                x = widget_x - menu_width;
            
            // Up/Below align...
            y = widget_y;
            
            if (y + menu_height >  screen.get_height ())
                y = widget_y + widget_height - menu_height;
        }
        
        push_in = true;
    
    }
    
    
    /*************************************************************************************
     * Insert application items from the menu cache.
     * 
     * 
     ************************************************************************************/
    private void _insert_items_recursive (Mc.CacheDir cache_dir, Gtk.Menu parent_menu) {
    

        unowned SList<Mc.CacheItem?> item_list = cache_dir.get_children ();

        while (item_list != null) {
            
            Mc.CacheItem cache_item = item_list.data;
            Mc.Type item_type = cache_item.get_type();
            
            if ((item_type == Mc.Type.APP) && !((Mc.CacheApp) cache_item).get_is_visible (Mc.Show.IN_LXDE)) {
                
                /*
                string show_flags = "";
                if (((CacheApp) cache_item).get_is_visible (Mc.Show.IN_GNOME) == true) {
                    show_flags += " Gnome";
                }
                if (((CacheApp) cache_item).get_is_visible (Mc.Show.IN_KDE) == true) {
                    show_flags += " KDE";
                }
                if (((CacheApp) cache_item).get_is_visible (Mc.Show.IN_XFCE) == true) {
                    show_flags += " XFCE";
                }
                if (((CacheApp) cache_item).get_is_visible (Mc.Show.IN_ROX) == true) {
                    show_flags += " ROX";
                }
                
                string exec = ((CacheApp) cache_item).get_exec ();
                stdout.printf ("exec: %s menu item: %s show in:%s\n", exec, cache_item.get_name (), show_flags);
                */
                
                item_list = item_list.next;
                continue;
            }
            
            
            /*****************************************************************************
             * Create a menu item, if it's a category, create a sub menu and call
             * this function recursively to populate the new menu category.
             * 
             ****************************************************************************/
            Gtk.MenuItem menu_item = _create_menu_item (cache_item);
            
            parent_menu.append (menu_item);
            
            if (item_type == Mc.Type.DIR) {
                Gtk.Menu sub_menu = new Gtk.Menu ();
                this._insert_items_recursive ((Mc.CacheDir) cache_item, sub_menu);
                menu_item.set_submenu(sub_menu);
            }
            
            item_list = item_list.next;
        }
        return;
    }
    
    
    /*************************************************************************************
     * Create a menu item, connect the activate signal, unless it's a separator.
     * 
     * 
     ************************************************************************************/
     private Gtk.MenuItem _create_menu_item (Mc.CacheItem cache_item) {
        
        Mc.Type item_type = cache_item.get_type ();
        
        Gtk.MenuItem menu_item;
        
        if (item_type == Mc.Type.SEP ) {
            
            menu_item = new Gtk.SeparatorMenuItem ();
        
        } else {
            
            // Get the menu name, icon and command line...
            menu_item = new Gtk.ImageMenuItem.with_label (cache_item.get_name ());
            
            string icon = cache_item.get_icon ();
            Gtk.Image image = new Gtk.Image.from_icon_name (icon, Gtk.IconSize.MENU);            
            ((Gtk.ImageMenuItem) menu_item).set_image (image);
            
            if (item_type == Mc.Type.APP) {
                
                string exec_cmd = ((Mc.CacheApp) cache_item).get_exec ();
                string exec_parts = exec_cmd.split ("%") [0];
                
                menu_item.activate.connect ( () => {
                    
                    try {
                        GLib.Process.spawn_command_line_async(exec_parts);
                    } catch (Error e) {
                    }
                
                });
            }
        }
        
        return menu_item;
    }
    
    void on_reload_menu () {
        stdout.printf ("MenuApplet: on_reload_menu\n");
    }
}




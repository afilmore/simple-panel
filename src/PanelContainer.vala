/**
 * PanelConfig.vala
 * 
 * Copyright 2012 Axel FILMORE <axel.filmore@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2.
 * http://www.gnu.org/licenses/gpl-2.0.txt
 * 
 * Purpose:
 *  
 */


using Gtk;




public class PanelContainer : Gtk.Grid {
//~ public class PanelContainer : Gtk.Fixed {
    
    public enum Column {
        NAME,
        EXPAND,
        DATA,
        N_COLUMNS
    }

    
    private string _config_file;
    
    
    
    
    public SList<PanelApplet?> _applet_list;




/*      Geometry    */
    private int _panel_edge=3;
//~     allign=left
//~     margin=0
//~     widthtype=percent
//~     width=100
//~     heighttype=pixels
    int _height = 26;
//~     iconsize=16

/*      Appearance  */
//~     usesystemtheme=1
//~     tintcolor=#000000
//~     transparent=0
//~     alpha=0
//~     background=1
//~     backgroundfile=/usr/share/lxpanel/images/background.png
//~     usefontcolor=1
//~     fontcolor=#ffffff
//~     usefontsize=0
//~     fontsize=10

/*      Advanced    */
//~     setdocktype=1
//~     setpartialstrut=1
//~     minimizepanel=0
//~     minimizedsize=2

    
    public PanelContainer (int panel_id) {
        
        _applet_list = new SList<PanelApplet> ();
        _panel_edge = panel_id;
        
        //this.set_resize_mode (Gtk.ResizeMode.QUEUE);
        
        this.set_hexpand (false);
        this.set_hexpand_set (true);
        
        //this.set_size_request (1440, _height);
	}
    
    public void load_applets (string config_file) {
        
        _config_file = config_file;
        
        KeyFile kf = new KeyFile();
        try {
            kf.load_from_file(_config_file, KeyFileFlags.NONE);
        } catch (Error e) {
        }
        
        // on a 1440 pixel width screen, it's possible to put 90 icons each 16 pixels width. :-D
        int applet_id;
        int pos = 0;
        int inc = 0;
        for (applet_id=0; applet_id<100; applet_id++) {
            
            string group = "Panel.%d.Applet.%d".printf (_panel_edge, applet_id);
            if (kf.has_group (group) == false)
                break;
            
            /* 
             * Get the applet type and  try to create it, that may fail, it's not possible to create
             * two system tray for example. Then add the applet to the container and the linked list.
             */
            string type = "";
            try {
                type = kf.get_value (group, "type");
            } catch (Error e) {
            }
            
            PanelApplet applet = (PanelApplet) Object.new (Type.from_name (type));
            if (applet.create (_config_file, _panel_edge, applet_id) == false)
                continue;
            
            
            
            inc = _height;
            int mini, natural;
            //stdout.printf ("%s %d %d\n", applet.get_type ().name (), pos, inc);
            
//~             if (applet.get_type ().name () == "PagerApplet") {
//~                 stdout.printf ("pager\n");//
//~             } else {
//~                 applet.set_size_request (_height, _height);
//~                 applet.get_preferred_width_for_height (_height, out mini, out natural);
//~                 stdout.printf ("preferred %s %d %d\n", applet.get_type ().name (), mini, natural);
//~             }
            

            Gtk.Widget _widget = applet.get_widget ();
            this.add (_widget);
            //this.put (applet, pos, 0);
            _widget.set_size_request (_height, _height);
            _widget.size_allocate ({0, 0, 50, _height});
            _widget.get_preferred_width_for_height (_height, out mini, out natural);
            //stdout.printf ("preferred %s %d %d\n", applet.get_type ().name (), mini, natural);
            
            pos += inc;
            
            _applet_list.append (applet);
            
            
        }  
        
    }
    
    private void _on_applets_button_add (Gtk.TreeView applets_list) {
        
        // static void panel_container_on_applets_button_add (PanelContainer* self, GtkWidget* plugin_list);
        
        stdout.printf ("clicked\n");
        
        return;
    }

    public string get_config_text () {
        
        string config = "";
        int count = -1;
        
        config += "[Panel.%d]\n".printf (_panel_edge);
        config += "\n";
        
        foreach (PanelApplet applet in _applet_list) {
            count++;
            config += "[Panel.%d.Applet.%d]\n".printf (_panel_edge, count);
            config += "type=" + applet.get_type ().name () + "\n";
            config += applet.get_config_text ();
            config += "\n";
        }
        
        return config;
    }
    
    public void show_config_dialog () {
        
        try {
            
            /*-------------------------------- from lxpanel --------------------------------------------------------- */
            Gtk.Button button;

//~             if (dialog != null) {
//~                 panel_adjust_geometry_terminology(p);
//~                 stdout.printf ("present\n");
//~                 dialog.present ();
//~                 return;
//~             }
            
            Gtk.Builder builder = new Gtk.Builder ();
            //builder.set_translation_domain (Config.GETTEXT_PACKAGE);
            builder.add_from_file (Path.build_filename (Config.PACKAGE_UI_DIR, "panel-pref.ui"));
            builder.connect_signals (null);
            
            
            
                Gtk.Dialog dialog = builder.get_object ("panel_pref") as Gtk.Dialog;

//~             g_signal_connect(p->pref_dialog, "response", (GCallback) response_event, p);
//~             g_object_add_weak_pointer( G_OBJECT(p->pref_dialog), (gpointer) &p->pref_dialog );
//~             gtk_window_set_position( (GtkWindow*)p->pref_dialog, GTK_WIN_POS_CENTER );
//~             panel_apply_icon(GTK_WINDOW(p->pref_dialog));
//~ 
//~             /* position */
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "edge_bottom" );
//~             gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(w), edge_selector(p, EDGE_BOTTOM));
//~             gtk_widget_set_sensitive(w, panel_edge_available(p, EDGE_BOTTOM));
//~             g_signal_connect(w, "toggled", G_CALLBACK(edge_bottom_toggle), p);
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "edge_top" );
//~             gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(w), edge_selector(p, EDGE_TOP));
//~             gtk_widget_set_sensitive(w, panel_edge_available(p, EDGE_TOP));
//~             g_signal_connect(w, "toggled", G_CALLBACK(edge_top_toggle), p);
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "edge_left" );
//~             gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(w), edge_selector(p, EDGE_LEFT));
//~             gtk_widget_set_sensitive(w, panel_edge_available(p, EDGE_LEFT));
//~             g_signal_connect(w, "toggled", G_CALLBACK(edge_left_toggle), p);
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "edge_right" );
//~             gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(w), edge_selector(p, EDGE_RIGHT));
//~             gtk_widget_set_sensitive(w, panel_edge_available(p, EDGE_RIGHT));
//~             g_signal_connect(w, "toggled", G_CALLBACK(edge_right_toggle), p);
//~ 
//~             /* alignment */
//~             p->alignment_left_label = w = (GtkWidget*)gtk_builder_get_object( builder, "alignment_left" );
//~             gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(w), (p->allign == ALLIGN_LEFT));
//~             g_signal_connect(w, "toggled", G_CALLBACK(align_left_toggle), p);
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "alignment_center" );
//~             gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(w), (p->allign == ALLIGN_CENTER));
//~             g_signal_connect(w, "toggled", G_CALLBACK(align_center_toggle), p);
//~             p->alignment_right_label = w = (GtkWidget*)gtk_builder_get_object( builder, "alignment_right" );
//~             gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(w), (p->allign == ALLIGN_RIGHT));
//~             g_signal_connect(w, "toggled", G_CALLBACK(align_right_toggle), p);
//~ 
//~             /* margin */
//~             p->margin_control = w = (GtkWidget*)gtk_builder_get_object( builder, "margin" );
//~             gtk_spin_button_set_value( (GtkSpinButton*)w, p->margin );
//~             gtk_widget_set_sensitive(p->margin_control, (p->allign != ALLIGN_CENTER));
//~             g_signal_connect( w, "value-changed",
//~                               G_CALLBACK(set_margin), p);
//~ 
//~             /* size */
//~             p->width_label = (GtkWidget*)gtk_builder_get_object( builder, "width_label");
//~             p->width_control = w = (GtkWidget*)gtk_builder_get_object( builder, "width" );
//~             gtk_widget_set_sensitive( w, p->widthtype != WIDTH_REQUEST );
//~             gint upper = 0;
//~             if( p->widthtype == WIDTH_PERCENT)
//~                 upper = 100;
//~             else if( p->widthtype == WIDTH_PIXEL)
//~                 upper = (((p->edge == EDGE_TOP) || (p->edge == EDGE_BOTTOM)) ? gdk_screen_width() : gdk_screen_height());
//~             gtk_spin_button_set_range( (GtkSpinButton*)w, 0, upper );
//~             gtk_spin_button_set_value( (GtkSpinButton*)w, p->width );
//~             g_signal_connect( w, "value-changed", G_CALLBACK(set_width), p );
//~ 
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "width_unit" );
//~             update_opt_menu( w, p->widthtype - 1 );
//~             g_object_set_data(G_OBJECT(w), "width_spin", p->width_control );
//~             g_signal_connect( w, "changed",
//~                              G_CALLBACK(set_width_type), p);
//~ 
//~             p->height_label = (GtkWidget*)gtk_builder_get_object( builder, "height_label");
//~             p->height_control = w = (GtkWidget*)gtk_builder_get_object( builder, "height" );
//~             gtk_spin_button_set_range( (GtkSpinButton*)w, PANEL_HEIGHT_MIN, PANEL_HEIGHT_MAX );
//~             gtk_spin_button_set_value( (GtkSpinButton*)w, p->height );
//~             g_signal_connect( w, "value-changed", G_CALLBACK(set_height), p );
//~ 
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "height_unit" );
//~             update_opt_menu( w, HEIGHT_PIXEL - 1);
//~ 
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "icon_size" );
//~             gtk_spin_button_set_range( (GtkSpinButton*)w, PANEL_HEIGHT_MIN, PANEL_HEIGHT_MAX );
//~             gtk_spin_button_set_value( (GtkSpinButton*)w, p->icon_size );
//~             g_signal_connect( w, "value_changed", G_CALLBACK(set_icon_size), p );
//~ 
//~             /* properties */
//~ 
//~             /* Explaination from Ruediger Arp <ruediger@gmx.net>:
//~                 "Set Dock Type", it is referring to the behaviour of
//~                 dockable applications such as those found in WindowMaker (e.g.
//~                 http://www.cs.mun.ca/~gstarkes/wmaker/dockapps ) and other
//~                 lightweight window managers. These dockapps are probably being
//~                 treated in some special way.
//~             */
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "as_dock" );
//~             update_toggle_button( w, p->setdocktype );
//~             g_signal_connect( w, "toggled",
//~                               G_CALLBACK(set_dock_type), p );
//~ 
//~             /* Explaination from Ruediger Arp <ruediger@gmx.net>:
//~                 "Set Strut": Reserve panel's space so that it will not be
//~                 covered by maximazied windows.
//~                 This is clearly an option to avoid the panel being
//~                 covered/hidden by other applications so that it always is
//~                 accessible. The panel "steals" some screen estate which cannot
//~                 be accessed by other applications.
//~                 GNOME Panel acts this way, too.
//~             */
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "reserve_space" );
//~             update_toggle_button( w, p->setstrut );
//~             g_signal_connect( w, "toggled",
//~                               G_CALLBACK(set_strut), p );
//~ 
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "autohide" );
//~             update_toggle_button( w, p->autohide );
//~             g_signal_connect( w, "toggled",
//~                               G_CALLBACK(set_autohide), p );
//~ 
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "height_when_minimized" );
//~             gtk_spin_button_set_value(GTK_SPIN_BUTTON(w), p->height_when_hidden);
//~             g_signal_connect( w, "value-changed",
//~                               G_CALLBACK(set_height_when_minimized), p);
//~ 
//~             /* transparancy */
//~             tint_clr = w = (GtkWidget*)gtk_builder_get_object( builder, "tint_clr" );
//~             gtk_color_button_set_color((GtkColorButton*)w, &p->gtintcolor);
//~             gtk_color_button_set_alpha((GtkColorButton*)w, 256 * p->alpha);
//~             if ( ! p->transparent )
//~                 gtk_widget_set_sensitive( w, FALSE );
//~             g_signal_connect( w, "color-set", G_CALLBACK( on_tint_color_set ), p );
//~ 
//~             /* background */
//~             {
//~                 GtkWidget* none, *trans, *img;
//~                 none = (GtkWidget*)gtk_builder_get_object( builder, "bg_none" );
//~                 trans = (GtkWidget*)gtk_builder_get_object( builder, "bg_transparency" );
//~                 img = (GtkWidget*)gtk_builder_get_object( builder, "bg_image" );
//~ 
//~                 g_object_set_data(G_OBJECT(trans), "tint_clr", tint_clr);
//~ 
//~                 if (p->background)
//~                     gtk_toggle_button_set_active( (GtkToggleButton*)img, TRUE);
//~                 else if (p->transparent)
//~                     gtk_toggle_button_set_active( (GtkToggleButton*)trans, TRUE);
//~                 else
//~                     gtk_toggle_button_set_active( (GtkToggleButton*)none, TRUE);
//~ 
//~                 g_signal_connect(none, "toggled", G_CALLBACK(background_disable_toggle), p);
//~                 g_signal_connect(trans, "toggled", G_CALLBACK(transparency_toggle), p);
//~                 g_signal_connect(img, "toggled", G_CALLBACK(background_toggle), p);
//~ 
//~                 w = (GtkWidget*)gtk_builder_get_object( builder, "img_file" );
//~                 g_object_set_data(G_OBJECT(img), "img_file", w);
//~                 gtk_file_chooser_set_filename(GTK_FILE_CHOOSER(w),
//~                     ((p->background_file != NULL) ? p->background_file : PACKAGE_DATA_DIR "/lxpanel/images/background.png"));
//~ 
//~                 if (!p->background)
//~                     gtk_widget_set_sensitive( w, FALSE);
//~                 g_object_set_data( G_OBJECT(w), "bg_image", img );
//~                 g_signal_connect( w, "file-set", G_CALLBACK (background_changed), p);
//~             }
//~ 
//~             /* font color */
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "font_clr" );
//~             gtk_color_button_set_color( (GtkColorButton*)w, &p->gfontcolor );
//~             g_signal_connect( w, "color-set", G_CALLBACK( on_font_color_set ), p );
//~ 
//~             w2 = (GtkWidget*)gtk_builder_get_object( builder, "use_font_clr" );
//~             gtk_toggle_button_set_active( (GtkToggleButton*)w2, p->usefontcolor );
//~             g_object_set_data( G_OBJECT(w2), "clr", w );
//~             g_signal_connect(w2, "toggled", G_CALLBACK(on_use_font_color_toggled), p);
//~             if( ! p->usefontcolor )
//~                 gtk_widget_set_sensitive( w, FALSE );
//~ 
//~             /* font size */
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "font_size" );
//~             gtk_spin_button_set_value( (GtkSpinButton*)w, p->fontsize );
//~             g_signal_connect( w, "value-changed",
//~                               G_CALLBACK(on_font_size_set), p);
//~ 
//~             w2 = (GtkWidget*)gtk_builder_get_object( builder, "use_font_size" );
//~             gtk_toggle_button_set_active( (GtkToggleButton*)w2, p->usefontsize );
//~             g_object_set_data( G_OBJECT(w2), "clr", w );
//~             g_signal_connect(w2, "toggled", G_CALLBACK(on_use_font_size_toggled), p);
//~             if( ! p->usefontsize )
//~                 gtk_widget_set_sensitive( w, FALSE );
//~ 
            
            /* ------------------------------------ plugin list ----------------------------------------------------- */
            Gtk.TreeView applets_list = builder.get_object ("plugin_list") as Gtk.TreeView;

            button = builder.get_object ("add_btn") as Gtk.Button;
            button.clicked.connect ( () => {
                this._on_applets_button_add (applets_list);
            });

            button = builder.get_object ("remove_btn") as Gtk.Button;
            button.clicked.connect ( () => {
                this._on_applets_button_add (applets_list);
            });

            button = builder.get_object ("edit_btn") as Gtk.Button;
            button.clicked.connect ( () => {
                this._on_applets_button_add (applets_list);
            });
//~             g_signal_connect_swapped( w, "clicked", G_CALLBACK(modify_plugin), plugin_list );
//~             g_object_set_data( G_OBJECT(plugin_list), "edit_btn", w );

            button = builder.get_object ("moveup_btn") as Gtk.Button;
            button.clicked.connect ( () => {
                this._on_applets_button_add (applets_list);
            });

            button = builder.get_object ("movedown_btn") as Gtk.Button;
            button.clicked.connect ( () => {
                this._on_applets_button_add (applets_list);
            });

//~             w = builder.get_object ("plugin_desc");
//~             
             this._init_applets_listview (applets_list);

            /* -------------------------------------------------------------------------------------------------------*/
            
//~             /* advanced, applications */
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "file_manager" );
//~             if (file_manager_cmd)
//~                 gtk_entry_set_text( (GtkEntry*)w, file_manager_cmd );
//~             g_signal_connect( w, "focus-out-event",
//~                               G_CALLBACK(on_entry_focus_out),
//~                               &file_manager_cmd);
//~ 
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "term" );
//~             if (terminal_cmd)
//~                 gtk_entry_set_text( (GtkEntry*)w, terminal_cmd );
//~             g_signal_connect( w, "focus-out-event",
//~                               G_CALLBACK(on_entry_focus_out),
//~                               &terminal_cmd);
//~ 
//~             /* If we are under LXSession, setting logout command is not necessary. */
//~             w = (GtkWidget*)gtk_builder_get_object( builder, "logout" );
//~             if( getenv("_LXSESSION_PID") ) {
//~                 gtk_widget_hide( w );
//~                 w = (GtkWidget*)gtk_builder_get_object( builder, "logout_label" );
//~                 gtk_widget_hide( w );
//~             }
//~             else {
//~                 if(logout_cmd)
//~                     gtk_entry_set_text( (GtkEntry*)w, logout_cmd );
//~                 g_signal_connect( w, "focus-out-event",
//~                                 G_CALLBACK(on_entry_focus_out),
//~                                 &logout_cmd);
//~             }
//~ 
//~             panel_adjust_geometry_terminology(p);
            
            dialog.show_all ();

//~             w = (GtkWidget*)gtk_builder_get_object( builder, "notebook" );
//~             gtk_notebook_set_current_page( (GtkNotebook*)w, sel_page );
            
        } catch (Error e) {
            stderr.printf ("%s\n", e.message);
        }
        
    }
    
    
    
    private void _init_applets_listview (Gtk.TreeView listview) {
        
        Gtk.ListStore list;
        Gtk.TreeViewColumn col;
        Gtk.CellRenderer render;
        Gtk.TreeSelection tree_sel;
        List l;
        //Gtk.TreeIter it;

        //g_object_set_data( G_OBJECT(listview), "panel", p );

        listview.insert_column_with_attributes (
            -1,
            "Currently loaded plugins",
            new Gtk.CellRendererText (),
            "text",
            Column.NAME,
            null);
        
        //g_object_set( render, "activatable", true, null );
//~         render.toggled.connect ( () => {
//~                 this._on_plugin_expand_toggled (listview);
//~             });
            
        /*listview.insert_column_with_attributes (
            -1,
            "Stretch",
            new Gtk.CellRendererToggle (),
            "active",
            Column.EXPAND,
            "radio",
            true);*/
            

        list = new Gtk.ListStore (Column.N_COLUMNS, typeof (string), typeof (bool), typeof (PanelApplet));
        
        Gtk.TreeIter it;
        foreach (PanelApplet applet in _applet_list) {
            
            
            string applet_name = applet.get_name ();
//~             stdout.printf ("fill listview: %s\n", applet_name);
            list.append (out it);
            list.set (
                it,
                Column.NAME,
                applet_name,
                Column.EXPAND,
                true,
                Column.DATA,
                applet);
                
        }
        
        listview.set_model (list);
        listview.row_activated.connect ( () => {
            //this.modify_plugin (listview);
        });

//~         tree_sel = listview.get_selection ();
//~         tree_sel.set_mode (Gtk.SELECTION_BROWSE);
//~         tree_sel.changed.connect ( () => {
//~             //this.on_sel_plugin_changed (label);
//~         });
//~         
//~         if (list.get_iter_first (it) == true)
//~             tree_sel.select_iter (it);
    }
}



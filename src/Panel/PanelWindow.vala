/***********************************************************************************************************************
 *      
 *      PanelWindow.vala
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
 *      Purpose: The Main Application Class and program's entry point.
 * 
 *      The Application class handles one or more Panel Windows. Each panel window have a grid container,
 *      Panel Applets are loaded from a configuration file and added to the grid.
 *      Each panel applet derives of a base applet interface.
 * 
 * 
 * 
 **********************************************************************************************************************/
namespace Panel {

    public enum Struts {
        LEFT,
        RIGHT,
        TOP,
        BOTTOM,
        LEFT_START,
        LEFT_END,
        RIGHT_START,
        RIGHT_END,
        TOP_START,
        TOP_END,
        BOTTOM_START,
        BOTTOM_END,
        N_VALUES
    }


    class Window : Gtk.Window {

        // Panel mode.
        bool _debug;
        
        // Geometry, placement.
        private Gdk.Screen _screen;
        private int _panel_edge = 3; // bottom panel...
        
        int _height;
        int _width;
        
        // Child container.
        public Panel.Container _container;
        
        // Main Popup menu.
        private Gtk.Menu _popup_menu;
        
        
        /*********************************************************************************
         * Create a panel window, the application class gives the panel mode the config
         * file and the edge.
         * 
         ********************************************************************************/
         public Window (bool mode, string config_file, int panel_id) {
            
            _debug = mode;
            _panel_edge = panel_id;
            
            // Get screen geometry.
            _screen = Gdk.Screen.get_default ();

            int screen_width = _screen.get_width ();
            
            _height = 26;
            
            // Create a toplevel window in normal or debug mode.
            this.add_events (Gdk.EventMask.BUTTON_RELEASE_MASK);
            this.set_name ("PanelToplevel");
            
            
            if (_debug) {
                this.set_position (Gtk.WindowPosition.CENTER);
            } else {
                
                this.stick ();
                this.skip_pager_hint = true;
                _width = screen.get_width ();
                this.skip_taskbar_hint = true;
                this.type_hint = Gdk.WindowTypeHint.DOCK;
                this.decorated = false;
                this.resizable = false;
                
                //this.set_default_size (_height, screen_width * 80 /100);
            }
            
            
            // Create the container window, applets will be loaded from the configuration file.
            _container = new Panel.Container (panel_id);
            this.add (_container);
            _container.load_applets (config_file);
            
            this.realize ();
            this.show_all ();
            
            
            /*****************************************************************************
             * Create the panel popup menu.
             * 
             * 
             ****************************************************************************/
            this._create_popup ();
            
            //  Connect signals.
            this.destroy.connect (() => {Gtk.main_quit ();});
            this.button_release_event.connect ( (event) => {
                if (event.button == 3)
                    _popup_menu.popup (null, null, null, 1, 0);
                return true;
            });
            
            
            /*** Get the allocated height. ***/
            _height = this.get_allocated_height ();
            
            if (_debug == false) {
                this.set_size_request (screen_width, _height);
                this.get_window ().move (0, _screen.get_height () - _height);
                this._set_struts ();
            }
        }
        
        
        protected override void get_preferred_height(out int min, out int natural) {
            
            min = natural = _height;
        }
        
        protected override void get_preferred_width(out int min, out int natural) {
                
            if (_debug)
                min = natural = (get_screen ().get_width () / 4) * 2;
            else
                min = natural = get_screen ().get_width ();
        }
        
        protected override void size_allocate (Gtk.Allocation allocation) {
            
            base.size_allocate (allocation);
            
            //update_geometry();
            
        }

        private void _create_popup () {
        
            _popup_menu = new Gtk.Menu ();
            Gtk.MenuItem mi;
            
            if (_debug == true) {
                mi = new Gtk.MenuItem.with_label ("Test.....");
                mi.show ();
                _popup_menu.append (mi);
                mi.activate.connect ( () => {
                    //this._test ();
                });
            }
            
            mi = new Gtk.MenuItem.with_label ("Task Manager");
            mi.show ();
            _popup_menu.append (mi);
            mi.activate.connect ( () => {
                try {
                    Process.spawn_command_line_async("lxtask");
                } catch (Error e) {
                }
            });
            
            mi = new Gtk.MenuItem.with_label ("Properties");
            mi.show ();
            _popup_menu.append (mi);
            mi.activate.connect ( () => {
                _container.show_config_dialog ();
            });
        }    
        
        
        /*********************************************************************************
         * Stolen from Wingpanel - Copyright (C) 2011 Wingpanel Developers -
         *
         * 
         ********************************************************************************/
        private void _set_struts () {

            if (!this.get_realized())
                return;


            /*******************************************************************
             * Since uchar is 8 bits in vala but the struts are 32 bits
             * We have to allocate 4 times as much and do bit-masking...
             * 
             * 
             ******************************************************************/
            var struts = new ulong [Struts.N_VALUES];

            struts [Struts.BOTTOM]         = _height;
            struts [Struts.BOTTOM_START]   = 0;
            struts [Struts.BOTTOM_END]     = 0 + 1440;

            var first_struts = new ulong [Struts.BOTTOM + 1];
            for (var i = 0; i < first_struts.length; i++) {
                first_struts [i] = struts [i];
            }

            unowned X.Display display = Gdk.x11_get_default_xdisplay ();
            var xid = Gdk.X11Window.get_xid(this.get_window());

            display.change_property (xid,
                                     display.intern_atom ("_NET_WM_STRUT_PARTIAL", false),
                                     X.XA_CARDINAL,
                                     32,
                                     X.PropMode.Replace,
                                     (uchar[]) struts,
                                     struts.length);
            
            display.change_property (xid,
                                     display.intern_atom ("_NET_WM_STRUT", false),
                                     X.XA_CARDINAL,
                                     32,
                                     X.PropMode.Replace,
                                     (uchar[]) first_struts,
                                     first_struts.length);
        }
    }
}




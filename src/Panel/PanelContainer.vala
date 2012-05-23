/***********************************************************************************************************************
 *      
 *      PanelContainer.vala
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
    
    public class Container : Gtk.Grid {
        
        public enum Column {
            NAME,
            EXPAND,
            DATA,
            N_COLUMNS
        }

        public List<PanelApplet?> _applet_list;
        
        private int _height = 26;
        
        private string _config_file;

        private int _panel_edge=3;
        
        public Container (int panel_id) {
            
            _applet_list = new List<PanelApplet> ();
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
                
//~             if (applet.get_type ().name () == "PagerApplet") {
//~                 stdout.printf ("pager\n");//
//~             } else {
//~                 applet.set_size_request (_height, _height);
//~                 applet.get_preferred_width_for_height (_height, out mini, out natural);
//~                 stdout.printf ("preferred %s %d %d\n", applet.get_type ().name (), mini, natural);
//~             }
            
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
                

                //Gtk.Widget _widget = applet.get_widget ();
                
                this.add (applet);
                //this.put (applet, pos, 0);
                applet.set_size_request (_height, _height);
                applet.size_allocate ({0, 0, 50, _height});
                applet.get_preferred_width_for_height (_height, out mini, out natural);
                //stdout.printf ("preferred %s %d %d\n", applet.get_type ().name (), mini, natural);
                
                pos += inc;
                
                _applet_list.append (applet);
                
                
            }  
            
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
        }
    }
}


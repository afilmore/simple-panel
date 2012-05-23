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
    
    public class Container : Gtk.Box {
        

        public List<PanelApplet?> _applet_list;
        
        private string _config_file;

        private int _panel_edge=3;
        
        public Container (int panel_id) {
            
            _applet_list = new List<PanelApplet> ();
            _panel_edge = panel_id;
            
            this.expand = false;

            
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

            for (applet_id=0; applet_id<100; applet_id++) {
                
                string group = "Panel.%d.Applet.%d".printf (_panel_edge, applet_id);
                if (kf.has_group (group) == false)
                    break;
                
                
                /*************************************************************************
                 * Get the applet type and  try to create it, that may fail,
                 * it's not possible to create two system tray for example.
                 * Then add the applet to the container and the linked list.
                 * 
                 ************************************************************************/
                string type = "";
                try {
                    type = kf.get_value (group, "type");
                    stdout.printf ("applet type: %s\n", type);
                } catch (Error e) {
                }
                
                if (type == "SystemTrayApplet" && SystemTrayApplet.check_running ()) {
                    stdout.printf ("A SystemTray is already running !!!\n");
                    continue;
                }
                
                PanelApplet applet = (PanelApplet) Object.new (Type.from_name (type));
                if (!applet.create (_config_file, _panel_edge, applet_id))
                    continue;
                
                this.pack_start(applet, false);
                
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




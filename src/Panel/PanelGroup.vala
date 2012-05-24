/***********************************************************************************************************************
 * 
 *      PanelGroup.vala
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
namespace Panel {

    
    public const string PACKAGE_DATA_DIR = "/usr/share";
    public const string CONFIG_DATA_DIR = "/usr/share/simple-panel";
    public const string CONFIG_FILE = "simple-panel.conf";

    // TODO_axl: Try to derivate a window group instead...
    public class Group {
        
        bool                        _debug_mode = false;
        
        // An array containing maximum four panel windows...
        private string      _user_config_file;
        private Panel.Window _panelwnd[4];
        
        //private Gtk.WindowGroup?    _wingroup = null;
        
        public Group (bool debug = false) {
            
            _debug_mode = debug;
        
            //_wingroup = new Gtk.WindowGroup ();
            
            MenuApplet.register_type ();
            LaunchBarApplet.register_type ();
            PagerApplet.register_type ();
            TaskListApplet.register_type ();
            TaskListApplet2.register_type ();
            SystemTrayApplet.register_type ();
            SystemClockApplet.register_type ();
            

            // Set the user config file to use...
            
            string user_config_dir = Environment.get_user_config_dir() + "/simple-panel/";
            
            if (_debug_mode)
                _user_config_file = user_config_dir + "debug.conf";
            else
                _user_config_file = user_config_dir + CONFIG_FILE;
            
            
            // Try to read the user configuration file or try the wide system one...
            if (!this.load_config (_user_config_file)) {
                
                string system_config_file = PACKAGE_DATA_DIR + "/simple-panel/" + CONFIG_FILE;
                
                if (this.load_config (system_config_file) == false) {
                    
                    // There's no configuration file, create a default bottom panel...
                    _panelwnd[Panel.Edge.BOTTOM] = new Panel.Window (_debug_mode, _user_config_file, Panel.Edge.BOTTOM);
                    return;
                }
                
                // Ensures that the user directory exists and save the configutation file...
                DirUtils.create_with_parents (user_config_dir, 0700);
                this.save_config (_user_config_file);
            }
            
            /*** this.save_config (_user_config_file); ***/
            
            try {
                
                Process.spawn_command_line_async("gnome-sound-applet");
            
            } catch (Error e) {
            }
        }
        
        public bool load_config (string config_file) {
            
            // Check if the specified configuration file exists...
            if (FileUtils.test (config_file, FileTest.EXISTS) == false)
                return false;
            
            
            // load the configuration file...
            KeyFile kf = new KeyFile();
            try {
                kf.load_from_file (config_file, KeyFileFlags.NONE);
            } catch (Error e) {
            }
            
            
            /***************************************************************************************
             * Parse the configuration file, create a top level panel windows and store these
             * in the panel windows array.
             * 
             * [Panel.3] is a bottom panel.
             * 
             * 
             **************************************************************************************/
            int count = 0;
            int panel_id = Panel.Edge.BOTTOM;
            for (panel_id = 0; panel_id < Panel.Edge.MAX_PANEL; panel_id++) {
                string group = "Panel.%d".printf (panel_id);
                if (kf.has_group (group) == false)
                    continue;
                
                _panelwnd[panel_id] = new Panel.Window (_debug_mode, config_file, panel_id);
                count++;
            }
            
            if (count == 0) {
                // No panel window to create ???? should create a default one...
            }
            
            return true;
        }

        public void save_config (string config_file) {
            
            /***************************************************************************************
             * In debug mode the config file may be loaded from the source tree,
             * so it's not saved in the user config.
             */
             
             return;
            
            File file = File.new_for_path (config_file);

            // delete if file already exists (is it needed ???)
            if (file.query_exists ()) {
                try {
                    file.delete ();
                } catch (Error e) {
                }
            }
            
            /* Parse the window array and save the configuration. */
            string config = "";
            
            try {
                DataOutputStream dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
                
                for (int i = 0; i < Panel.Edge.MAX_PANEL; i++) {
                    if (_panelwnd[i] != null) {
                        config += _panelwnd[i]._container.get_config_text ();
                        dos.put_string (config);
                    }
                }
            } catch (Error e) {
            }
            
        }
    }
}



/***********************************************************************************************************************
 *      
 *      Application.vala
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
 *      The panel application can run in debug or normal mode, in debug mode it runs in a normal window,
 *      in normal mode, it's limited to a single instance.
 *      Two different configuration files are used, a normal and debug one.
 * 
 * 
 * 
 **********************************************************************************************************************/
namespace Panel {
    
    
    /*************************************************************************************
     * Globals.
     * 
     * 
     ************************************************************************************/
    public const string PACKAGE_DATA_DIR = "/usr/share";
    public const string CONFIG_FILE = "simple-panel.conf";

    public enum Edge {
        LEFT,
        RIGHT,
        TOP,
        BOTTOM,
        MAX_PANEL
    }


    /*************************************************************************************
     * Command line options.
     * 
     * 
     ****************************************************************************************/
    bool        _args_debug = false;
    bool        _args_show_version = false;
    string[]    _args_remaining;

    const OptionEntry[] _args_options = {
        { "debug", 'd', 0, OptionArg.NONE, ref _args_debug, "Debug mode", null },
        { "version", 'v', 0, OptionArg.NONE, ref _args_show_version, "Show the application's version", null },
        { "", '\0', 0, OptionArg.FILENAME_ARRAY, ref _args_remaining, null, "[FILE...]" },
        {null}
    };


    /*************************************************************************************
     * 
     * 
     * 
     ****************************************************************************************/
    public class Application : GLib.Application {
        
        
        private bool        _debug_mode;
        private string      _user_config_file;
        
        private unowned string[]                _args;
        // An array containing maximum four panel windows...
        private Panel.Window _panelwnd[4];
        
        
        public Application (string[] args) {
            
            string app_id = "org.noname.spanel-debug";
            
            Object (application_id:app_id, flags:(ApplicationFlags.HANDLES_COMMAND_LINE));
            
            // NOTE: Members can only be set after calling Object () otherwise it would segfault.
            _args = args;
            
        }
        
        public void run_local () {
            
            OptionContext context = new OptionContext ("");
            try {
                context.add_main_entries (_args_options, null);
                context.parse (ref _args);

            } catch (OptionError e) {
            }
        

            _debug_mode = _args_debug;
            
            Gtk.init (ref _args);
            
            MenuApplet.register_type ();
            LaunchBarApplet.register_type ();
            PagerApplet.register_type ();
            TaskListApplet.register_type ();
            SystemTrayApplet.register_type ();
            SystemClockApplet.register_type ();
            

            // Set the user config file to use...
            string user_config_dir = "%s/%s/%s".printf (Environment.get_user_config_dir(), "simple-panel", "default");
            
            string config_file;
            if (_debug_mode)
                config_file = "debug.conf";
            else
                config_file = CONFIG_FILE;
            
            _user_config_file = "%s/%s".printf (user_config_dir, config_file);
            
            
            // Try to read the user configuration file or try the wide system one...
            if (this.load_config (_user_config_file) == false) {
                
                string system_config_dir = "%s/%s/%s".printf (PACKAGE_DATA_DIR, "simple-panel", "default");
                string system_config_file = "%s/%s".printf (system_config_dir, config_file);
                
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
            
            Gtk.main ();

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
            if (_debug_mode)
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
        
        
        /*********************************************************************************
         * Program's entry point, read the command line arguments, run the application
         * in a single instance, except in debug mode.
         * 
         * 
         ********************************************************************************/
         private static int main (string[] args) {
            
            Panel.Application app = new Panel.Application (args);
            app.run_local ();
                
            return 0;
        }
    }
}





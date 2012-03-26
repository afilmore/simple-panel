/***********************************************************************************************************************
 * PanelApplication.vala
 * 
 * Copyright 2012 Axel FILMORE <axel.filmore@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2.
 * http://www.gnu.org/licenses/gpl-2.0.txt
 * 
 * Purpose: The Application class handles one or more Panel Windows. Each panel window have a grid container,
 * Panel Applets are loaded from a configuration file and added to the grid.
 * Each panel applet derives of a base applet interface.
 * 
 **********************************************************************************************************************/


/***********************************************************************************************************************
 * Globals.
 */
public const string PACKAGE_DATA_DIR = "/usr/share";
public const string CONFIG_FILE = "simple-panel.conf";

public enum PanelEdge {
    LEFT,
    RIGHT,
    TOP,
    BOTTOM,
    MAX_PANEL
}


/***********************************************************************************************************************
 * Command line options.
 */
bool _args_debug = false;
bool _args_show_version = false;
string[] _args_remaining;

const OptionEntry[] _args_options = {
    { "debug", 'd', 0, OptionArg.NONE, ref _args_debug, "Debug mode", null },
    { "version", 'v', 0, OptionArg.NONE, ref _args_show_version, "Show the application's version", null },
    { "", '\0', 0, OptionArg.FILENAME_ARRAY, ref _args_remaining, null, "[FILE...]" },
    {null}
};


/***********************************************************************************************************************
 * The panel application can run in debug or normal mode, in debug mode it runs in a normal window, in normal mode, it's
 * limited to a single instance. Two different configuration files are used, a normal and debug one.
 */
//----------------------------------------------------------------------------------------------------------------------
//~ FIXME: Core dump, should work but doesn't....
//~ public class PanelApplication : GLib.Application {
//~     
//~     public PanelApplication (bool mode) {
//~         Object (application_id: "test", flags: 0);
//~     }
//----------------------------------------------------------------------------------------------------------------------
public class PanelApplication {
    
    private bool _debug;
    private string _user_config_file;
    
    private PanelWindow _panelwnd[4];   /* an array containing maximum four panel windows */
    
    public PanelApplication (bool mode) {
        _debug = mode;
    }
		
    public void run () {
        
        /*
         * Register applet types.
         * FIXME: I don't know why it's needed...
         */
        MenuApplet.register_type ();
        LaunchBarApplet.register_type ();
        PagerApplet.register_type ();
        TaskListApplet.register_type ();
        SystemTrayApplet.register_type ();
        SystemClockApplet.register_type ();
        
        /* Set the user config file to use */
        string user_config_dir = "%s/%s/%s".printf (Environment.get_user_config_dir(), "simple-panel", "default");
        
        string config_file;
        if (_debug) {
            config_file = "debug.conf";
        } else {
            config_file = CONFIG_FILE;
        }
        
        _user_config_file = "%s/%s".printf (user_config_dir, config_file);
        
        /* Try to read the user configuration file or try the wide system one. */
        if (this.load_config (_user_config_file) == false) {
            
            string system_config_dir = "%s/%s/%s".printf (PACKAGE_DATA_DIR, "simple-panel", "default");
            string system_config_file = "%s/%s".printf (system_config_dir, config_file);
            
            if (this.load_config (system_config_file) == false) {
                /* There's no configuration file, create a default bottom panel. */
                _panelwnd[PanelEdge.BOTTOM] = new PanelWindow (_debug, _user_config_file, PanelEdge.BOTTOM);
                return;
            }
            
            /* Ensures that the user directory exists and save the configutation file. */
            DirUtils.create_with_parents (user_config_dir, 0700);
            this.save_config (_user_config_file);
        }
        
        /* TODO: need to save the launchbar items.......
         * this.save_config (_user_config_file);
        */
        
        try {
            // FIXME: find a way to register prefered applications...
            Process.spawn_command_line_async("gnome-sound-applet");
        } catch (Error e) {
        }
        
    }
    
    
    public bool load_config (string config_file) {
        
        /* Check if the specified configuration file exists. */
        if (FileUtils.test (config_file, FileTest.EXISTS) == false)
            return false;
        
        
        /* load the configuration file. */
        KeyFile kf = new KeyFile();
        try {
            kf.load_from_file (config_file, KeyFileFlags.NONE);
        } catch (Error e) {
        }
        
        /* 
         * Parse the configuration file, create top level panel windows and store these in the panel windows array.
         * [Panel.3] is a bottom panel.
         */
        int count = 0;
        int panel_id = PanelEdge.BOTTOM;
        for (panel_id = 0; panel_id < PanelEdge.MAX_PANEL; panel_id++) {
            string group = "Panel.%d".printf (panel_id);
            if (kf.has_group (group) == false)
                continue;
            
            _panelwnd[panel_id] = new PanelWindow (_debug, config_file, panel_id);
            count++;
        }
        
        if (count == 0) {
            /* No panel window to create ???? should create a default one....... */
        }
        
        return true;
    }

    public void save_config (string config_file) {
        
        /* 
         * In debug mode the config file may be loaded from the source tree,
         * so it's not saved in the user config.
         */
        if (_debug)
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
            
            for (int i = 0; i < PanelEdge.MAX_PANEL; i++) {
                if (_panelwnd[i] != null) {
                    config += _panelwnd[i]._container.get_config_text ();
                    dos.put_string (config);
                }
            }
        } catch (Error e) {
        }
        
    }
    
    
    /*******************************************************************************************************************
     * Program's entry point, read the command line arguments, run the application in a single instance,
     * except in debug mode.
     */
     private static int main (string[] args) {
        
        Gtk.init (ref args);
        
        OptionContext context = new OptionContext ("");
        context.add_main_entries (_args_options, null);

        try {
            context.parse (ref args);
            
            PanelApplication app = new PanelApplication (_args_debug);
            GLib.Application unique = new GLib.Application ("org.foo.bar", 0);
            unique.register ();
            if ( unique.get_is_remote () == false || _args_debug == true) {
                app.run ();
                Gtk.main ();
            }
            
        } catch (OptionError e) {
        }
    
        return 0;
    }
}


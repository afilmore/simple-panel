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
        
        
        private unowned string[]                _args;
        
        
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
        

            Gtk.init (ref _args);
            
            Panel.Group panel_group = new Panel.Group (_args_debug);
            
            
            Gtk.main ();

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





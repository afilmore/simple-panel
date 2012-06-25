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
    
    Fm.Config global_config;
    
    /*************************************************************************************
     * Globals.
     * 
     * 
     ************************************************************************************/
    public enum Edge {
        LEFT,
        RIGHT,
        TOP,
        BOTTOM,
        MAX_PANEL
    }


    /*************************************************************************************
     * 
     * 
     * 
     ************************************************************************************/
    public class Application : GLib.Application {
        
        
        private unowned string[]    _args;
        private Panel.OptionParser  _options;
        private Panel.Group         _panel_group;        
        
        public Application (string[] args) {
            
            Panel.OptionParser options = new Panel.OptionParser (args);
            string app_id;
            
            if (options.debug)
                app_id = "org.noname.spanel-debug";
            else
                app_id = "org.noname.spanel";
            
            Object (application_id:app_id, flags:(ApplicationFlags.HANDLES_COMMAND_LINE));
            
            // NOTE: Members can only be set after calling Object () otherwise it would segfault.
            _args = args;
            _options = options;
        }
        
        public bool run_local () {
            
            try {
            
                this.register (null);
            
            } catch (Error e) {
            
                print ("GApplication Register Error: %s\n", e.message);
                return true;
            }
            
            
            if (this.get_is_remote ())
                return false;
                
            this.command_line.connect (this._on_command_line);
            
            
            /*****************************************************************************
             * Primary Instance...
             * 
             * 
             ****************************************************************************/

            Gtk.init (ref _args);
            
            global_config = new Fm.Config ();
            
            global_config.show_thumbnail = false;
            
            Fm.init (global_config);
            
            //stdout.printf ("panel = %s\n", fm_config.panel);
            //stdout.printf ("show_thumbnail = %s\n", fm_config.show_thumbnail ? "true" : "false");
            
            
            _panel_group = new Panel.Group (_options.debug);
            
            Gtk.main ();
            Fm.finalize ();
            
            return true;
        }
        
        
        private int _on_command_line (ApplicationCommandLine command_line) {
            
            //stdout.printf ("Application: _on_command_line\n");
            
            /*** We handle only remote command lines here... ***/
            if (!command_line.get_is_remote ())
                return 0;
            
            string[] args = command_line.get_arguments ();
            Panel.OptionParser options = new Panel.OptionParser (args);
            
            if (options.toggledesk)
                this._toggle_desktop ();
            
            return 0;
        }
        
        private void _toggle_desktop () {
            stdout.printf ("toggle desktop\n");
            _panel_group.toggle_desktop ();
        }


        /*********************************************************************************
         * Program's entry point, read the command line arguments, run the application
         * in a single instance, except in debug mode.
         * 
         * 
         ********************************************************************************/
         private static int main (string[] args) {
            
            Panel.Application app = new Panel.Application (args);
            if (!app.run_local ()) {
                //stdout.printf ("Application: global_app.run ()\n");
                return app.run (args);
            }
                
            return 0;
        }
    }
}





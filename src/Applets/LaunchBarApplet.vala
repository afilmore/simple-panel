/***********************************************************************************************************************
 *      
 *      LaunchBarApplet.vala
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
 **********************************************************************************************************************/
public class LaunchBarApplet : Gtk.Grid, PanelApplet {
    
    // Configuration file.
    string              _config_file;
    
    string              location;
    
    // A Global Model to handle Files/Folder on the desktop...
    Fm.FolderModel?     global_model = null;    
    
//~     int                 _panel_id;
//~     int                 _applet_id;
    
    // Wnck Screen.
    private Wnck.Screen _wnckscreen;
    
    int                 _height = 24;

    
    public static GLib.Type register_type () {return typeof (LaunchBarApplet);}
    
    public bool create (string config_file, int panel_id, int applet_id) {
        
        _config_file = config_file;
//~         _panel_id = panel_id;
//~         _applet_id = applet_id;
        
        _wnckscreen = Wnck.Screen.get_default ();
        
        this.set_orientation (Gtk.Orientation.HORIZONTAL);
        
        
        /*************************************************************
         * Load the configuration file...
         * 
         * 
         ************************************************************/
        
        KeyFile kf = new KeyFile ();
        try {
            kf.load_from_file (config_file, KeyFileFlags.NONE);
        } catch (Error e) {
        }
        
        //string group = "Panel.%d.Applet.%d".printf (panel_id, applet_id);
        

        string applet_group = "panel%d-applet%d".printf (panel_id, applet_id);
        
        if (!kf.has_group (applet_group))
            return false;
        
        string key = "location";
        
//~         try {
//~             if (!kf.has_key (applet_id, key))
//~                 break;
//~         } catch (Error e) {
//~         }
            
        string val = "";
        try {
            val = kf.get_value (applet_group, key);
        } catch (Error e) {
        }
        
        location = Environment.get_user_config_dir() + "/spanel/" + val;
        
        stdout.printf ("%s\n", location);

        Fm.Path? path = new Fm.Path.for_str (location);
        if (path == null)
            return false;
        
        Fm.Folder? folder = Fm.Folder.get (path);
        if (folder == null)
            return false;
            
        global_model = new Fm.FolderModel (folder, false);
        if (global_model == null)
            return false;
            
        global_model.loaded.connect (_on_model_loaded);
        

        return true;
    }
    
    private void _on_model_loaded () {
        
        Gtk.TreeIter    it;
        Fm.FileInfo? fi;
        
        Gdk.Pixbuf      icon;
        
        if (!global_model.get_iter_first (out it))
            return;
            
        do {
            global_model.get (it, Fm.FileColumn.ICON, out icon, Fm.FileColumn.INFO, out fi, -1);
            
            stdout.printf ("%s\n", fi.get_target ());
            
            
            //Gtk.Widget? btn = _create_widget (fi.get_target (), "google-chrome", 22);
            Gtk.Button? btn = new Gtk.Button ();
        
//~             if (btn == null)
//~                 return false;
            
            this.add (btn);
        

        } while (global_model.iter_next (ref it) == true);
            
    }
    
    /*************************************************************************************
     * Parse the specified .desktop file.
     * Create a button widget and add it to the Gtk.Grid...
     * 
     ************************************************************************************/
     private bool _create_from_desktop (string val) {
        
        
        /*************************************************************
         * Get the "Desktop Entry" group...
         * 
         * 
         ************************************************************/
        KeyFile kf = new KeyFile ();
        try {
            kf.load_from_file (val, KeyFileFlags.NONE);
        } catch (Error e) {
        }
        
        string group = "Desktop Entry";
        if (kf.has_group (group) == false)
            return false;
            
        
        /*************************************************************
         * Parse .desktop keys.
         * 
         * 
         ************************************************************/
        string key;
        
        string type = "";
        key = "Type";
        try {
            if (kf.has_key (group, key) == true)
                type = kf.get_value (group, key);
        } catch (Error e) {
        }   
        
        string name = "";
        key = "Name";
        try {
            if (kf.has_key (group, key) == true)
                name = kf.get_value (group, key);
        } catch (Error e) {
        }
        
        string exec = "";
        string exec_parts = "";
        key = "Exec";
        try {
            if (kf.has_key (group, key) == true) {
                // FIXME_axl: get "TryExec"...
                exec = kf.get_value (group, key);
                exec_parts = exec.split ("%") [0];
            }
        } catch (Error e) {
        }
        
        string icon = "";
        key = "Icon";
        try {
            if (kf.has_key (group, key) == true)
                icon = kf.get_value (group, key);
        } catch (Error e) {
        }
        
        string terminal = "";
        key = "Terminal";
        try {
            if (kf.has_key (group, key) == true)
                terminal = kf.get_value (group, key);
        } catch (Error e) {
        }
        
        string startup_notify = "";
        key = "StartupNotify";
        try {
            if (kf.has_key (group, key) == true)
                startup_notify = kf.get_value (group, key);
        } catch (Error e) {
        }
        
        
        // Create the widget...
        //Gtk.Widget? btn = _create_widget (exec_parts, icon, _height);
        Gtk.Button? btn = new Gtk.Button ();
        
        if (btn == null)
            return false;
        
        this.add (btn);
        
        return true;
    }
    
    
    /*************************************************************************************
     * Create the laucher button and connect event signals.
     * 
     * 
     ************************************************************************************/
    private Gtk.Widget? _create_widget (string cmdline, string icon, int size) {
    
        Panel.CustomButton evbox = new Panel.CustomButton ();
        evbox.create (icon, size);
        
        evbox.button_release_event.connect ( (event) => {
            if (event.button == 1) {
                try {
                    if (cmdline == "TOGGLE_DESKTOP") {
                        stdout.printf ("toggle\n");
                        _wnckscreen.toggle_showing_desktop (!_wnckscreen.get_showing_desktop ());
                    } else {
                        Process.spawn_command_line_async(cmdline);
                    }
                } catch (Error e) {
                }
            }
            return true;
        });
        
        return evbox;
    }
    
    public string get_config_text () {
        
        return "\n";
    }
}



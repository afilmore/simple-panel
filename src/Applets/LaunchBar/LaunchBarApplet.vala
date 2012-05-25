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
    private string          _config_file;
    
    private string          _location;
    
    private Fm.FolderModel  _folder_model;    
    
    // Wnck Screen.
    private Wnck.Screen     _wnckscreen;
    
    
    public static GLib.Type register_type () {return typeof (LaunchBarApplet);}
    
    
    public bool create (string config_file, int panel_id, int applet_id) {
        
        
        _config_file = config_file;
        
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
        
        string applet_group = "panel%d-applet%d".printf (panel_id, applet_id);
        
        if (!kf.has_group (applet_group))
            return false;
        
        string key = "location";
        
        string val = "";
        try {
            val = kf.get_value (applet_group, key);
        } catch (Error e) {
        }
        
        _location = Environment.get_user_config_dir() + "/spanel/" + val;
        
        //stdout.printf ("%s\n", _location);
        
        // TODO_axl: test if the path exists....
        
        _folder_model = new Fm.FolderModel (Fm.Folder.get (new Fm.Path.for_str (_location)), false);
            
        _folder_model.set_icon_size (22);
        _folder_model.loaded.connect (_on_model_loaded);
        

        return true;
    }
    
    private void _on_model_loaded () {
        
        Gtk.TreeIter    it;
        
        Fm.FileInfo?    file_info;
        Gdk.Pixbuf?     pixbuf;
        
        if (!_folder_model.get_iter_first (out it))
            return;
            
        do {
            
            _folder_model.get (it, Fm.FileColumn.ICON, out pixbuf, Fm.FileColumn.INFO, out file_info, -1);
            
            if (pixbuf == null) {
                stdout.printf ("Can't get the icon for %s !!!!\n", file_info.get_target ());
                continue;
            }
            
            if (!file_info.is_desktop_entry () || !file_info.is_symlink ())
                continue;
                
            stdout.printf ("desktop entry: %s\n", file_info.get_target ());
            
            this.add (new LaunchBarItem (file_info, pixbuf));
        
        } while (_folder_model.iter_next (ref it) == true);
    }
    

    public string get_config_text () {
        return "\n";
    }
}



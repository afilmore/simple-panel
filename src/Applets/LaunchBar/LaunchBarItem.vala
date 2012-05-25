/***********************************************************************************************************************
 *      
 *      LaunchBarItem.vala
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
public class LaunchBarItem : Gtk.EventBox {
    
    private Fm.FileInfo     _file_info;
    
    private Gdk.Pixbuf      _pixbuf;
    private Gtk.Image       _image;
    
    private string          _command_line;
    
    
    public LaunchBarItem (Fm.FileInfo file_info, Gdk.Pixbuf pixbuf) {
    
        _file_info = file_info;
        _pixbuf = pixbuf;
        
        this._get_command_line (file_info.get_target ());
        
        _image = new Gtk.Image.from_pixbuf (pixbuf);
        this.add (_image);
        this.show_all ();
        
        this.button_release_event.connect ((event) => {
            
            if (event.button == 1) {
                try {
                    Process.spawn_command_line_async (_command_line);
                } catch (Error e) {
                }
            }
            return true;
        });
        
        /*** this.enter_notify_event.connect ((event) => {
            _image.set_from_pixbuf (_pixbuf);
            return false;
        }); ***/
        
        /*** this.leave_notify_event.connect ( (event) => {
            //_image.set_from_pixbuf (_pixbufhigh);
            return false;
        }); ***/
        
    }
    
    
    /*************************************************************************************
     * Parse the specified .desktop file and get the program's command line...
     * 
     * 
     ************************************************************************************/
     private bool _get_command_line (string desktop_entry) {
        

        KeyFile kf = new KeyFile ();
        try {
            kf.load_from_file (desktop_entry, KeyFileFlags.NONE);
        } catch (Error e) {
        }
        
        string group = "Desktop Entry";
        if (!kf.has_group (group))
            return false;
        
        
        /*************************************************************
         * Parse .desktop keys.
         * 
         ************************************************************/
        string key = "Type";
        string type = "";

        try {
            if (kf.has_key (group, key) == true)
                type = kf.get_value (group, key);
        } catch (Error e) {
        }   
        
        key = "Name";
        string name = "";
        
        try {
            if (kf.has_key (group, key) == true)
                name = kf.get_value (group, key);
        } catch (Error e) {
        }
        
        /**key = "TryExec";
        string try_exec = "";
        try {
            if (kf.has_key (group, key)) {
                try_exec = kf.get_value (group, key);
                _command_line = try_exec;
            }
        } catch (Error e) {
        }*/
        
        key = "Exec";
        string exec = "";
        string exec_parts = "";
        try {
            if (kf.has_key (group, key) == true) {
                exec = kf.get_value (group, key);
                exec_parts = exec.split ("%") [0];
                _command_line = exec_parts;
            }
        } catch (Error e) {
        }
        
        key = "Icon";
        string icon = "";
        try {
            if (kf.has_key (group, key))
                icon = kf.get_value (group, key);
        } catch (Error e) {
        }
        
        key = "Terminal";
        string terminal = "";
        try {
            if (kf.has_key (group, key))
                terminal = kf.get_value (group, key);
        } catch (Error e) {
        }
        
        string startup_notify = "";
        key = "StartupNotify";
        try {
            if (kf.has_key (group, key))
                startup_notify = kf.get_value (group, key);
        } catch (Error e) {
        }
        
        return true;
    }
}




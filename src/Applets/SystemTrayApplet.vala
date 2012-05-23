/***********************************************************************************************************************
 *      
 *      SystemTrayApplet.vala
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
public class SystemTrayApplet : Gtk.Grid, PanelApplet {
    
    private Na.Tray _na_tray;
    
    
    public static bool check_running () {
        return Na.Manager.check_running (Gdk.Screen.get_default ());
    }
    
    public bool create (string config_file, int panel_id, int applet_id) {
        
        this.set_orientation (Gtk.Orientation.HORIZONTAL);

            if (!check_running ()) {
        
            this._na_tray = new Na.Tray (Gdk.Screen.get_default (), Gtk.Orientation.HORIZONTAL, null, null);
            this.add (_na_tray);
        
            }
        
        return true;
    }
    
    public string get_config_text () {return "\n";}
    public static GLib.Type register_type () {return typeof (SystemTrayApplet);}
    
}




/*
 * SystemTrayApplet.vala
 * 
 * Copyright 2012 Axel FILMORE <axel.filmore@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2.
 * http://www.gnu.org/licenses/gpl-2.0.txt
 * 
 * Purpose: 
 * 
 */

using Gtk;
using Na;

class SystemTrayApplet : Object, PanelApplet {
    
    private Na.Tray _tray;
    private Gdk.Screen _screen;
    
    public bool create (string config_file, int panel_id, int applet_id) {
        
        this._screen = Gdk.Screen.get_default ();
        
        if (Na.Manager.check_running (_screen) == true)
            return false;

        this._tray = new Tray (_screen, Gtk.Orientation.HORIZONTAL, null, null);
        
        return true;
    }
    
    public Gtk.Widget get_widget () {return _tray;}
    public string get_config_text () {return "\n";}
    public static GLib.Type register_type () {return typeof (SystemTrayApplet);}
    
    public string get_name () {return "SystemTrayApplet";}

}


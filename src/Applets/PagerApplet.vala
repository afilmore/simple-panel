/**
 * PagerApplet.vala
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

class PagerApplet : Object , PanelApplet {
    
    private Wnck.Pager _pager;
    public bool create (string config_file, int panel_id, int applet_id) {
	    
        _pager = new Wnck.Pager ();
        _pager.set_orientation (Gtk.Orientation.HORIZONTAL);
        
        return true;
    }
    public Gtk.Widget get_widget () {return _pager;}
    public string get_config_text () {return "\n";}
    public string get_name () {return "PagerApplet";}
    public static GLib.Type register_type () {return typeof (PagerApplet);}
    
}		

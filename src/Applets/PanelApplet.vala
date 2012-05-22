/***********************************************************************************************************************
 * PanelApplet.vala
 * 
 * Copyright 2012 Axel FILMORE <axel.filmore@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2.
 * http://www.gnu.org/licenses/gpl-2.0.txt
 * 
 * Purpose:
 *  
 **********************************************************************************************************************/


public interface PanelApplet : Gtk.Widget {

    public abstract bool create (string config_file, int panel_id, int applet_id);
    
    //public abstract Gtk.Widget get_widget ();
    public abstract string get_config_text ();
    public static Type register_type () {return typeof (PanelApplet);}
    
    // usefull ???? .get_type ().name () does the same.....
    public abstract string get_name ();
}


/**
 * SystemClockApplet.vala
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

public class SystemClockApplet : Gtk.Label, PanelApplet {
    
    //Gtk.Label _label;
    string _timestr;
    
    construct
    {
        
        DateTime time = new DateTime.now_local ();
        _timestr = time.format ("%H:%M");
        
        int seconds = 60 - time.get_second ();
        
        Timeout.add_seconds (seconds, update);
        
        //_label = new Gtk.Label (_timestr);
        
        //this.label = _timestr;
    }
    
    public bool create (string config_file, int panel_id, int applet_id) {
        
        
        return true;
    }
    
    public bool update () {
        
        DateTime time = new DateTime.now_local ();
        _timestr = time.format ("%H:%M");
        
        int seconds = 60 - time.get_second ();
        
        Timeout.add_seconds (seconds, this.update);
        
        this.label = _timestr;
        
        return false;
    }

//~     public Gtk.Widget get_widget () {return this;}
    public string get_config_text () {return "\n";}
    public string get_name () {return "SystemClockApplet";}
    
    public static GLib.Type register_type () {return typeof (SystemClockApplet);}

}


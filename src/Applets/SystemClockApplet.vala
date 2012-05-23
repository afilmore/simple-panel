/***********************************************************************************************************************
 *      
 *      .vala
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
public class SystemClockApplet : Gtk.Label, PanelApplet {
    
    string _timestr;
    
    construct
    {
        
        
    }
    
    public bool create (string config_file, int panel_id, int applet_id) {
        
        DateTime time = new DateTime.now_local ();
        _timestr = time.format ("%H:%M");
        
        int seconds = 60 - time.get_second ();
        
        Timeout.add_seconds (seconds, update);
        
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

    public string get_config_text () {return "\n";}
    
    public static GLib.Type register_type () {return typeof (SystemClockApplet);}

}




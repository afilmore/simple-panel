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
class TaskListApplet : Wnck.Tasklist, PanelApplet {
    
    public bool create (string config_file, int panel_id, int applet_id) {
        this.set_grouping (Wnck.TasklistGroupingType.ALWAYS_GROUP);
        return true;
    }
    
    
    public string get_config_text () {return "\n";}
    public static GLib.Type register_type () {return typeof (TaskListApplet);}

}



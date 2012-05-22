/**
 * TaskListApplet.vala
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

    
//----------------------------------------------------------------------------------------------------------------------
//~ class TaskListApplet : Object, PanelApplet {
//~     
//~     private Wnck.Tasklist _tasklist;
//~     
//~     public bool create (string config_file, int panel_id, int applet_id) {
//~         _tasklist = new Wnck.Tasklist ();
//~         _tasklist.set_grouping (Wnck.TasklistGroupingType.ALWAYS_GROUP);
//~         return true;
//~     }
//~     public Gtk.Widget get_widget () {return _tasklist;}
//----------------------------------------------------------------------------------------------------------------------
    
//----------------------------------------------------------------------------------------------------------------------
class TaskListApplet : Wnck.Tasklist, PanelApplet {
    public bool create (string config_file, int panel_id, int applet_id) {
        this.set_grouping (Wnck.TasklistGroupingType.ALWAYS_GROUP);
        return true;
    }
//----------------------------------------------------------------------------------------------------------------------
    
    
    public string get_config_text () {return "\n";}
    public string get_name () {return "TaskListApplet";}
    public static GLib.Type register_type () {return typeof (TaskListApplet);}

}


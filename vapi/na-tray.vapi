/***********************************************************************************************************************
 * 
 *      na-tray.vapi
 * 
 *      Copyright 2012 Axel FILMORE <axel.filmore@gmail.com>
 * 
 *      This program is free software; you can redistribute it and/or modify
 *      it under the terms of the GNU General Public License Version 2.
 *      http://www.gnu.org/licenses/gpl-2.0.txt
 * 
 *      Purpose: Binding file for Gnome Panel's System Tray.
 * 
 *      Version: 1.0
 * 
 * 
 **********************************************************************************************************************/
namespace Na {
	
    [CCode (cname="NaTray", cprefix="na_tray_", cheader_filename = "na-tray.h", type_id = "na_tray_get_type ()")]
	public class Tray : Gtk.Bin {
		
		public Gdk.Screen screen {get;set;}
		public Gtk.Orientation orientation {get;set;}
        
        [CCode (cname="na_tray_new_for_screen", has_construct_function = false, type = "GtkBin*")]
        public Tray (Gdk.Screen screen, Gtk.Orientation orientation, void *cb, void *data);
		
//~         [CCode (cname="na_tray_new_for_screen", has_construct_function = false, type = "GtkBin*")]
//~         public Tray.for_screen(Gdk.Screen screen, Gtk.Orientation orientation);
        
        public void set_orientation	(Gtk.Orientation orientation);
        public Gtk.Orientation get_orientation ();
        public void set_padding (int padding);
        public void set_icon_size (int icon_size);
        public void set_colors (Gdk.Color fg, Gdk.Color error, Gdk.Color warning, Gdk.Color success);
        public void force_redraw ();
        public unowned Manager get_manager ();
        //public Type get_type (void);
	}
	
    [CCode (cname="NaTrayManager", cprefix="na_tray_manager_" , cheader_filename = "na-tray-manager.h")]
	[Compact]
	public class Manager {
		public static bool check_running(Gdk.Screen screen);
	}
}







//typedef gboolean (*NaTrayFilterCallback) (NaTray *tray, GtkWidget *icon, gpointer data);

namespace Na {
	
    [CCode (cname="NaTray", cprefix="na_tray_", cheader_filename = "na-tray.h", type_id = "na_tray_get_type ()")]
	public class Tray : Gtk.Bin {
		
		public Gdk.Screen screen {get;set;}
		public Gtk.Orientation orientation {get;set;}
        
        [CCode (cname="na_tray_new_for_screen", has_construct_function = true, type = "GtkBin*")]
        public Tray (Gdk.Screen screen, Gtk.Orientation orientation, void* cb, void* data);
        
        //public Type get_type (void);
        public void set_orientation	(Gtk.Orientation orientation);
        public Gtk.Orientation get_orientation ();
        public void set_padding (int padding);
        public void set_icon_size (int icon_size);
        public void set_colors (Gdk.Color fg, Gdk.Color error, Gdk.Color warning, Gdk.Color success);
        public void force_redraw ();
        public unowned Manager get_manager ();
	}
	
    [CCode (cname="NaTrayManager", cprefix="na_tray_manager_" , cheader_filename = "na-tray-manager.h")]
	[Compact]
	public class Manager {
		public static bool check_running(Gdk.Screen screen);
	}
    
}


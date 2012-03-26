/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- */

// valac --pkg gtk+-3.0 --pkg libmenu-cache --vapidir=. menu_cache_test.vala && ./menu_cache_test

using Gtk;
using Mc;

public class CacheTest
{
	private Mc.Cache _cache;
	
	public CacheTest ()
	{
		// create a menu cache lookup
	}

	private Gtk.Menu create_menu(CacheDir dir, Gtk.Widget? parent)
	{
 		Gtk.Menu menu = new Gtk.Menu();
		Gtk.MenuItem mi;
		
		unowned SList<CacheItem?> item_list = dir.get_children ();
		
		if (parent != null)
		{
//~ 			mi = create_item( dir );
//~ 			gtk_menu_item_set_submenu( mi, menu );
//~ 			gtk_menu_append( parent, mi );
//~ 			gtk_widget_show( mi );
//~ 	//		printf( "comment:%s\n", menu_cache_item_get_comment(dir) );
		}

        while (item_list != null)
        {
            CacheItem item = item_list.data;
            
			if (item.get_type() == Mc.Type.DIR )
			{
				stdout.printf ("-------------------------------------------------------------------\n");
				stdout.printf ("dir\n");
				stdout.printf ("comment:%s\n", item.get_comment() );
				stdout.printf ("icon:%s\n", item.get_icon() );
				create_menu ((CacheDir) item, menu);
			}
			else
			{
				stdout.printf ("-------------------------------------------------------------------\n");
				stdout.printf ("comment:%s\n", item.get_comment() );
				stdout.printf ("icon:%s\n", item.get_icon() );
				//stdout.printf ("exec:%s\n", menu_cache_app_get_exec(item) );
				
				
				//mi = create_item(item);
				//mi.show ();
				//menu.append (mi);
 			}
            item_list = item_list.next;
        }
		return menu;
	}

	public void run ()
	{
		Gtk.Button btn = new Gtk.Button ();

		_cache = Cache.lookup_sync ("/etc/xdg/lubuntu/menus/lxde-applications.menu");
		
		//unowned SList list = _cache.list_all_apps ();
		
		unowned CacheDir menu = _cache.get_root_dir ();
		if (menu == null) {
			stdout.printf ("dir error\n");
		}
		
		Gtk.Menu pop = this.create_menu (menu, null);

//~ 	//	g_debug( "update: %d", menu_cache_is_updated( menu_cache ) );
//~ 		g_debug( "update: %d", menu_cache_file_is_updated( argv[1] ) );

//~ 		win = gtk_window_new( GTK_WINDOW_TOPLEVEL );
//~ 		gtk_window_set_title( win, "MenuCache Test" );
//~ 		btn = gtk_button_new_with_label( menu_cache_item_get_name(menu) );
//~ 		gtk_widget_set_tooltip_text( btn, menu_cache_item_get_comment(menu) );
//~ 		gtk_container_add( win, btn );
		btn.clicked.connect ( (pop) => {
			stdout.printf ("toto");
		});
//~ 		g_signal_connect( btn, "clicked", G_CALLBACK(on_clicked), pop );
//~ 		g_signal_connect( win, "delete-event", G_CALLBACK(gtk_main_quit), NULL );
//~ 
//~ 		gtk_widget_show_all( win );

	}
	
	static int main (string[] args) 
	{
		Gtk.init (ref args);
		var app = new CacheTest ();
		app.run ();
		Gtk.main ();
		return 0;
	}
}

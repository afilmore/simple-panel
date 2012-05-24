






public class TaskAppButton : Panel.Button {

	public TaskAppButton (Wnck.Application application) {
		
        //this.panel = panel;
		this.application = application;
		application.icon_changed.connect(on_icon_changed);
		application.name_changed.connect(on_name_changed);

		// create our own label widget
		add(new Gtk.Label(""));
		on_name_changed(application);
		on_icon_changed(application);
	}

	protected override void dispose() {
		application.icon_changed.disconnect(on_icon_changed);
		application.name_changed.disconnect(on_name_changed);
	}

	protected void on_icon_changed(Wnck.Application application) {
		var pix = application.get_icon();
//~ 		int icon_size = panel.get_icon_size();
		int icon_size = 22;
		pix = pix.scale_simple(icon_size, icon_size, Gdk.InterpType.BILINEAR);
		set_icon_pixbuf(pix);
	}

	protected void on_name_changed(Wnck.Application application) {
		set_tooltip_text(application.get_name());
		// set_label(win.get_name());
		weak Gtk.Label label = (Gtk.Label)get_child();
		label.set_text("[%s]".printf(application.get_name()));
	}

	protected override void clicked() {
		unowned List<weak Wnck.Window> windows = application.get_windows();
		if(windows != null) {
		}
	}

	private weak Wnck.Application application;
//~ 	private weak Panel panel;
}



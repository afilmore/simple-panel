



public class TaskButton : Panel.Button {

	public TaskButton(Wnck.Window win) {
		this.win = win;
		expand = true;
		win.name_changed.connect(on_name_changed);
		win.icon_changed.connect(on_icon_changed);
		win.state_changed.connect(on_state_changed);
		win.workspace_changed.connect(on_workspace_changed);
		update_icon();

		// create our own label widget
		Gtk.Label label = new Gtk.Label("");
		label.set_single_line_mode(true);
		label.set_alignment(0.0f, 0.5f);
		add(label);
		on_name_changed(win);
	}

	public override void dispose() {
		win.name_changed.disconnect(on_name_changed);
		win.icon_changed.disconnect(on_icon_changed);
		win.state_changed.disconnect(on_state_changed);
		win.workspace_changed.disconnect(on_workspace_changed);
		base.dispose();
	}

	public override void clicked() {
		if(win.is_active()) {
			win.minimize();
		}
		else {
			win.activate(Gtk.get_current_event_time());
		}
	}

	private void update_icon() {
		var pix = win.get_icon();
		//int icon_size = panel.get_icon_size();
		int icon_size = 22;
		pix = pix.scale_simple(icon_size, icon_size, Gdk.InterpType.BILINEAR);
		set_icon_pixbuf(pix);
	}

	private void on_name_changed(Wnck.Window window) {
		set_tooltip_text(win.get_name());
		// set_label(win.get_name());
		weak Gtk.Label label = (Gtk.Label)get_child();
		if((win.get_state() & Wnck.WindowState.MINIMIZED) != 0) {
			label.set_text("[%s]".printf(win.get_name()));
		}
		else {
			label.set_text(win.get_name());
		}
	}

	private void on_icon_changed(Wnck.Window window) {
		update_icon();
	}

	private void on_state_changed(Wnck.Window window, Wnck.WindowState changed_mask, Wnck.WindowState new_state) {
		// update title
		if((changed_mask & Wnck.WindowState.MINIMIZED) != 0) {
			weak Gtk.Label label = (Gtk.Label)get_child();
			if((new_state & Wnck.WindowState.MINIMIZED) != 0) {
				label.set_text("[%s]".printf(win.get_name()));
			}
			else {
				label.set_text(win.get_name());
			}
		}
	}

	private void on_workspace_changed(Wnck.Window window) {
		var ws = window.get_screen().get_active_workspace();
		set_visible(win.is_on_workspace(ws));
	}

	protected override bool button_press_event(Gdk.EventButton event) {
		var ret = base.button_press_event(event);
		if(event.button == 3) { // right click
			var menu = new Wnck.ActionMenu(win);
			menu.selection_done.connect(() => {
				menu.destroy();
			});
			menu.popup(null, null, get_menu_position, 3, event.time);
		}
		return ret;
	}

	protected override void size_allocate(Gtk.Allocation allocation) {
		base.size_allocate(allocation);
		if(get_realized()) {
			int x, y;
			get_window().get_origin(out x, out y);
			win.set_icon_geometry(x + allocation.x, y + allocation.y, allocation.width, allocation.height);
		}
	}

	weak Wnck.Window win;
//~ 	weak Panel panel;
}



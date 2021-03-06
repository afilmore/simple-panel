







public class TaskListApplet2 : Gtk.Container, PanelApplet, Gtk.Orientable {

//~ 	public TaskListApplet2 () {
//~ 		set_has_window(false);
//~ 		set_orientation(Gtk.Orientation.HORIZONTAL);
//~ 		set_size_request(1, 1);
//~ 		expand = true;
//~ 
//~ 		min_btn_size = 64;
//~ 		max_btn_size = 150;
//~ 
//~ 		// FIXME: we determine button height by icon size regardless of
//~ 		// font size for ease of implementation. Is this acceptable?
		//btn_height = panel.get_icon_size() + 2;
//~ 		btn_height = 22 + 2;
//~ 		show_label = true;
//~ 
//~ 		hash = new HashTable<weak Wnck.Window, weak TaskButton>(direct_hash, direct_equal);
//~ 	}
//~ 
	construct {
        stdout.printf ("create\n");
		set_has_window(false);
		set_orientation(Gtk.Orientation.HORIZONTAL);
		set_size_request(1, 1);
		expand = true;

		min_btn_size = 64;
		max_btn_size = 150;

		// FIXME: we determine button height by icon size regardless of
		// font size for ease of implementation. Is this acceptable?
//~ 		btn_height = panel.get_icon_size() + 2;
		btn_height = 22 + 2;
		show_label = true;

		hash = new HashTable<weak Wnck.Window, weak TaskButton>(direct_hash, direct_equal);
	}

    public static GLib.Type register_type () {return typeof (TaskListApplet2);}
    
    public bool create (string config_file, int panel_id, int applet_id) {
        
        this.set_orientation (Gtk.Orientation.HORIZONTAL);
		
        stdout.printf ("create\n");
        set_has_window(false);
		set_orientation(Gtk.Orientation.HORIZONTAL);
		set_size_request(1, 1);
		expand = true;

		min_btn_size = 64;
		max_btn_size = 150;

		// FIXME: we determine button height by icon size regardless of
		// font size for ease of implementation. Is this acceptable?
//~ 		btn_height = panel.get_icon_size() + 2;
		btn_height = 22 + 2;
		show_label = true;

		hash = new HashTable<weak Wnck.Window, weak TaskButton>(direct_hash, direct_equal);
        
        return true;
    }
    
    public string get_config_text () {return "\n";}
	public override void dispose() {
		if(screen != null) {
			// screen.application_opened.disconnect(on_application_opened);
			// screen.application_closed.disconnect(on_application_closed);
			screen.class_group_opened.disconnect(on_class_group_opened);
			screen.class_group_closed.disconnect(on_class_group_closed);
			screen.window_opened.disconnect(on_window_opened);
			screen.window_closed.disconnect(on_window_closed);
			screen.active_window_changed.disconnect(on_active_window_changed);
			screen.active_workspace_changed.disconnect(on_active_workspace_changed);
			screen = null;
		}
		base.dispose();
	}

	public override void realize() {
		base.realize();
		screen = Wnck.Screen.get(get_screen().get_number());

		if(screen != null) {
			// screen.application_opened.connect(on_application_opened);
			// screen.application_closed.connect(on_application_closed);
			screen.class_group_opened.connect(on_class_group_opened);
			screen.class_group_closed.connect(on_class_group_closed);
			screen.window_opened.connect(on_window_opened);
			screen.window_closed.connect(on_window_closed);
			screen.active_window_changed.connect(on_active_window_changed);
			screen.active_workspace_changed.connect(on_active_workspace_changed);
			unowned List<Wnck.Window> windows = screen.get_windows();
			foreach(unowned Wnck.Window window in windows) {
				on_window_opened(screen, window);
			}
		}
	}

	/*
	private void on_application_opened(Wnck.Screen screen, Wnck.Application application) {
		debug("app open: %s, %d", application.get_name(), application.get_n_windows());
	}

	private void on_application_closed(Wnck.Screen screen, Wnck.Application application) {
		debug("app close: %s, %d", application.get_name(), application.get_n_windows());
	}
	*/

	private void on_class_group_opened(Wnck.Screen screen, Wnck.ClassGroup group) {
		debug("class group open: %s, %d", group.get_name(), (int)group.get_windows().length());
	}

	private void on_class_group_closed(Wnck.Screen screen, Wnck.ClassGroup group) {
		debug("class group close: %s, %d", group.get_name(), (int)group.get_windows().length());
	}


	private void on_window_opened(Wnck.Screen screen, Wnck.Window window) {
		debug("win open: %s", window.get_name());
		if(!window.is_skip_tasklist()) {
			var btn = new TaskButton(window);

			var label = (Gtk.Label)btn.get_child();
			label.set_ellipsize(Pango.EllipsizeMode.END);
			
//~             var attrs = panel.get_text_attrs();
//~ 			if(attrs != null)
//~ 				label.set_attributes(attrs);


			btn.set_show_label(show_label);
			btn.set_image_position(Gtk.PositionType.LEFT);
			if(show_label == true)
				btn.set_size_request(max_btn_size, -1);

			add(btn);

			var ws = screen.get_active_workspace();
			hash.insert(window, btn);
			btn.set_visible(ws == null || window.is_on_workspace(ws));
		}
	}

	private void on_window_closed(Wnck.Screen screen, Wnck.Window window) {
		debug("win close: %s", window.get_name());
		unowned TaskButton? btn = hash.lookup(window);
		if(btn != null) {
			btn.destroy();
			hash.remove(window);
		}
	}

	public void on_active_window_changed(Wnck.Screen screen, Wnck.Window? prev_active) {
		unowned TaskButton? btn = hash.lookup(prev_active);

		// unset selected state of the previously active window
		if(btn != null) {
			btn.unset_state_flags(Gtk.StateFlags.SELECTED);
		}

		// set selected state of the currently active window
		btn = hash.lookup(screen.get_active_window());
		if(btn != null) {
			btn.set_state_flags(Gtk.StateFlags.SELECTED, false);
		}
	}

	public void on_active_workspace_changed(Wnck.Screen screen, Wnck.Workspace? prev) {
		// show windows in current workspace and hide others
		Wnck.Workspace ws = screen.get_active_workspace();
		var it = HashTableIter<weak Wnck.Window, weak TaskButton>(hash);
		unowned Wnck.Window win;
		unowned TaskButton btn;
		while(it.next(out win, out btn)) {
			btn.set_visible(win.is_on_workspace(ws));
		}
	}

	protected override void get_preferred_width(out int min_w, out int natral_w) {
		if(show_label) {
			min_w = natral_w = 32;
		}
		else {
			base.get_preferred_width(out min_w, out natral_w);
		}
	}
	
	protected override void size_allocate(Gtk.Allocation allocation) {
		set_allocation(allocation);
		if(show_label) { // if we show labels, the applet needs to be expandable
			// if the task list is expanded to fill all available spaces
			if(children != null) {
				// FIXME: handle vertical orientation
				Gtk.Allocation child_allocation = {0};
				int n_rows = int.max(1, allocation.height / btn_height);
				int n_children = (int)children.length();
				int n_cols = n_children / n_rows;
				if(n_children % n_rows != 0)
					++n_cols;
				int btn_size = allocation.width / n_cols;
				// btn_size.clamp(min_btn_size, max_btn_size);
				btn_size = int.min(max_btn_size, btn_size);
				child_allocation.x = allocation.x;
				child_allocation.y = allocation.y;
				child_allocation.width = btn_size;
				child_allocation.height = btn_height;
				int row = 1;
				foreach(weak Gtk.Widget child in children) {
					if(!child.get_visible())
						continue;
					child.size_allocate(child_allocation);
					if(row < n_rows) {
						child_allocation.y += btn_height;
						++row;
					}
					else {
						child_allocation.y = allocation.y;
						row = 1;
						child_allocation.x += btn_size;
					}
				}
			}
		}
		else { // icon only
			if(children != null) {
				Gtk.Allocation child_allocation = allocation;
				if(get_orientation() == Gtk.Orientation.HORIZONTAL) {
				}
				else { // vertical
					// FIXME: implement this
				}
			}
		}
	}

	public bool get_expand() {
		return show_label;
	}

//~ 	public bool load_config(GMarkupDom.Node config_node) {
//~ 		foreach(unowned GMarkupDom.Node child in config_node.children) {
//~ 			if(child.name == "max_btn_size") {
//~ 				max_btn_size = int.parse(child.val);
//~ 			}
//~ 			else if(child.name == "min_btn_size") {
//~ 				min_btn_size = int.parse(child.val);
//~ 			}
//~ 			else if(child.name == "show_label") {
//~ 				show_label =  bool.parse(child.val);
//~ 			}
//~ 			else if(child.name == "group_windows") {
//~ 				group_windows =  bool.parse(child.val);
//~ 			}
//~ 			// later buttons will be created in on_window_opened()
//~ 			// and we don't have to apply these values to them here.
//~ 		}
//~ 		return true;
//~ 	}
//~ 
//~ 	public void save_config(GMarkupDom.Node config_node) {
//~ 		config_node.new_child("max_btn_size", max_btn_size.to_string());
//~ 		config_node.new_child("min_btn_size", min_btn_size.to_string());
//~ 		config_node.new_child("show_label", show_label.to_string());
//~ 		config_node.new_child("group_windows", group_windows.to_string());
//~ 	}
	
	// for Gtk.Orientable iface
	public Gtk.Orientation orientation {
		get {	return _orientation;	}
		set {
			if(_orientation != value) {
				_orientation = value;
				set_orientation(value);
			}
		}
	}

	public void insert_child(Gtk.Widget child, int index) {
		children.insert(child, index);
		child.set_parent(this);
	}

	// Gtk.Container
	public override void add(Gtk.Widget child) {
		insert_child(child, -1);
	}
	
	public override void remove(Gtk.Widget child) {
		unowned List<Gtk.Widget> link = children.find(child);
		if(link != null) {
			if(child.get_visible() && get_visible())
				queue_resize();
			children.delete_link(link);
			child.unparent();
		}
	}

//~ 	public override void forall(Gtk.Callback callback) {
//~ 		foreach(weak Gtk.Widget child in children) {
//~ 			callback(child);
//~ 		}
//~ 	}

	public override void forall_internal(bool include_internal, Gtk.Callback callback) {
		foreach(weak Gtk.Widget child in children) {
			callback(child);
		}
	}

	private int max_btn_size;
	private int min_btn_size;
	private int btn_height;
	private bool show_label;
	private bool group_windows;
	
	private Gtk.Orientation _orientation;

	private weak Wnck.Screen screen;
	private HashTable<weak Wnck.Window, weak TaskButton> hash;
//~ 	private weak Panel panel;

	// for Gtk.Container child widgets
	private List<Gtk.Widget> children;
}


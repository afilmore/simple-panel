/***********************************************************************************************************************
 * PanelWindow.vala
 * 
 * Copyright 2012 Axel FILMORE <axel.filmore@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2.
 * http://www.gnu.org/licenses/gpl-2.0.txt
 * 
 * Purpose:
 *  
 **********************************************************************************************************************/


using Gtk;
using Gdk;
using X;
using Na;

public enum Struts {
    LEFT,
    RIGHT,
    TOP,
    BOTTOM,
    LEFT_START,
    LEFT_END,
    RIGHT_START,
    RIGHT_END,
    TOP_START,
    TOP_END,
    BOTTOM_START,
    BOTTOM_END,
    N_VALUES
}


class PanelWindow : Gtk.Window {

    /*  Panel mode. */
    bool _debug;
    
    /*  Geometry, placement.    */
    private Gdk.Screen _screen;
    private int _panel_edge = 3; // bottom panel...
    int _height;
    
    /*  Child container.    */
    public PanelContainer _container;
    
    /*  Main Popup menu.    */
    private Gtk.Menu _popup_menu;
    
    
    /*******************************************************************************************************************
     * Create a panel window, the application class gives the panel mode the config file and the edge.
     */
     public PanelWindow (bool mode, string config_file, int panel_id) {
		
        _debug = mode;
        _panel_edge = panel_id;
        
        
        /* Get screen geometry. */
        _screen = Gdk.Screen.get_default ();
        int screen_height = _screen.get_height ();
        int screen_width = _screen.get_width ();
        
        
        
        /*  Testing...  */
//~         Gdk.Rectangle rect;
//~         Misc.get_work_area_size (out rect);
        
        
        _height = 24;
        
        
        /* Create a toplevel window in normal or debug mode. */
        this.add_events (Gdk.EventMask.BUTTON_RELEASE_MASK);
        this.set_name ("PanelToplevel");
        
        this.skip_pager_hint = true;
        this.stick ();
        if (_debug == false) {
            this.skip_taskbar_hint = true;
            this.type_hint = Gdk.WindowTypeHint.DOCK;
            this.decorated = false;
            this.resizable = false;
            this.set_default_size (_height, screen_width * 80 /100);
        }
        
        
        
        /* Create the container window, applets will be loaded from the configuration file. */
        _container = new PanelContainer (panel_id);
        this.add (_container);
        _container.load_applets (config_file);
        
        this.realize ();
        this.show_all ();
        _test ();
        
        
        
        /***************************************************************************************************************
         * Create the panel popup menu.
         */
        _popup_menu = new Gtk.Menu ();
        Gtk.MenuItem mi;
        
        if (_debug == true) {
            mi = new Gtk.MenuItem.with_label ("Test.....");
            mi.show ();
            _popup_menu.append (mi);
            mi.activate.connect ( () => {
                this._test ();
            });
        }
        
        mi = new Gtk.MenuItem.with_label ("Task Manager");
        mi.show ();
        _popup_menu.append (mi);
        mi.activate.connect ( () => {
            try {
                Process.spawn_command_line_async("lxtask");
            } catch (Error e) {
            }
        });
        
        mi = new Gtk.MenuItem.with_label ("Properties");
        mi.show ();
        _popup_menu.append (mi);
        mi.activate.connect ( () => {
            _container.show_config_dialog ();
        });
        
        
        
        
        /*  Connect signals.    */
        this.destroy.connect (() => {Gtk.main_quit ();});
        this.button_release_event.connect ( (event) => {
            if (event.button == 3)
                _popup_menu.popup (null, null, null, 1, 0);
            return true;
        });
        
        
        
        /*
         * What can a do with this ????
         */
//~         this.configure_event.connect ( (event) => {
//~             stdout.printf ("configure: %d %d %d %d\n", event.x, event.y, event.width, event.height);
//~             return false;
//~         });
        
        
        
        
        /* 
         * Get the allocated height.
         */
        _height = this.get_allocated_height ();
        
        
        if (_debug == false) {
            this.set_size_request (screen_width, _height);
            this.get_window ().move (0, _screen.get_height () - _height);
            this._set_struts ();
        }
	}
    
    private void _test () {
        
        
        int pos = 0;
        int inc = 0;
        foreach (PanelApplet applet in _container._applet_list) {
            
            Gtk.Allocation a;
            Gtk.Widget widget = applet.get_widget ();
            widget.get_allocation (out a);
            Gtk.Requisition req = widget.get_requisition ();
            
            stdout.printf ("allocation %s %d %d %d %d\n", applet.get_type ().name (), a.x, a.y, a.width, a.height);
            stdout.printf ("requisition %s %d %d %d %d\n", applet.get_type ().name (), 0, 0, req.width, req.height);
            
            inc = a.width;
            stdout.printf ("%s %d %d\n", applet.get_type ().name (), pos, inc);
            //_container.move (applet, pos, 0);
            pos += a.width;
            
            
        }

        
        
        //stdout.printf ("test\n");
    }
    
    
    /*******************************************************************************************************************
     * Stolen from Wingpanel - Copyright (C) 2011 Wingpanel Developers -
     * TODO: I need to rewrite this...
     */
    private void _set_struts () {

        if (!this.get_realized())
            return;

        // since uchar is 8 bits in vala but the struts are 32 bits
        // we have to allocate 4 times as much and do bit-masking
        var struts = new ulong [Struts.N_VALUES];

        struts [Struts.BOTTOM]         = _height;
        struts [Struts.BOTTOM_START]   = 0;
        struts [Struts.BOTTOM_END]     = 0 + 1440;

        var first_struts = new ulong [Struts.BOTTOM + 1];
        for (var i = 0; i < first_struts.length; i++) {
            first_struts [i] = struts [i];
        }

        unowned X.Display display = Gdk.x11_get_default_xdisplay ();
        var xid = Gdk.X11Window.get_xid(this.get_window());

        display.change_property (xid, display.intern_atom ("_NET_WM_STRUT_PARTIAL", false), X.XA_CARDINAL,
                              32, X.PropMode.Replace, (uchar[]) struts, struts.length);
        display.change_property (xid, display.intern_atom ("_NET_WM_STRUT", false), X.XA_CARDINAL,
                              32, X.PropMode.Replace, (uchar[]) first_struts, first_struts.length);
    }
}


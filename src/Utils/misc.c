/*
 * misc.c
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

#include <gdk/gdkx.h>
#include <X11/Xlib.h>
#include <gdk/gdk.h>
#include <X11/Xatom.h>



/*
 * Stolen from PCManFM - Copyright 2010 Hong Jen Yee (PCMan) <pcman.tw@gmail.com>
 * 
 */
void get_work_area_size (GdkRectangle *desktop_working_area)
{
    //GdkScreen* screen = gtk_widget_get_screen((GtkWidget*)desktop);
    GdkScreen* screen = gdk_screen_get_default ();
    GdkWindow* root = gdk_screen_get_root_window(screen);
    Atom ret_type;
    gulong len, after;
    int format;
    guchar* prop;
    guint32 n_desktops, cur_desktop;
    gulong* working_area;
    
    //GdkRectangle desktop_working_area;
    
    /* default to screen size */
    desktop_working_area->x = 0;
    desktop_working_area->y = 0;
    desktop_working_area->width = gdk_screen_get_width(screen);
    desktop_working_area->height = gdk_screen_get_height(screen);

    if( XGetWindowProperty(GDK_WINDOW_XDISPLAY(root), GDK_WINDOW_XID(root),
                       XInternAtom(GDK_WINDOW_XDISPLAY(root), "_NET_NUMBER_OF_DESKTOPS", False), 0, 1, False, XA_CARDINAL, &ret_type,
                       &format, &len, &after, &prop) != Success)
        goto _out;
    if(!prop)
        goto _out;
    n_desktops = *(guint32*)prop;
    XFree(prop);

    if( XGetWindowProperty(GDK_WINDOW_XDISPLAY(root), GDK_WINDOW_XID(root),
                       XInternAtom(GDK_WINDOW_XDISPLAY(root), "_NET_CURRENT_DESKTOP", False), 0, 1, False, XA_CARDINAL, &ret_type,
                       &format, &len, &after, &prop) != Success)
        goto _out;
    if(!prop)
        goto _out;
    cur_desktop = *(guint32*)prop;
    XFree(prop);

    if( XGetWindowProperty(GDK_WINDOW_XDISPLAY(root), GDK_WINDOW_XID(root),
                       XInternAtom(GDK_WINDOW_XDISPLAY(root), "_NET_WORKAREA", False), 0, 4 * 32, False, AnyPropertyType, &ret_type,
                       &format, &len, &after, &prop) != Success)
        goto _out;
    if(ret_type == None || format == 0 || len != n_desktops*4 )
    {
        if(prop)
            XFree(prop);
        goto _out;
    }
    working_area = ((gulong*)prop) + cur_desktop * 4;

    desktop_working_area->x = (gint)working_area[0];
    desktop_working_area->y = (gint)working_area[1];
    desktop_working_area->width = (gint)working_area[2];
    desktop_working_area->height = (gint)working_area[3];

    XFree(prop);
_out:
    //queue_layout_items(desktop);
    return;
}

//----------------------------------------------------------------------------------------------------------------------

//~ static int xGetWorkAreaSize(Display* display, int screen, int *width, int *height)
//~ {
  //~ /* _NET_WORKAREA, x, y, width, height CARDINAL[][4]/32 */
  //~ static Atom workarea = 0;
  //~ Atom type;
  //~ long *data;
  //~ int format;
  //~ unsigned long after, ndata;
//~ 
  //~ if (!workarea)
    //~ workarea = XInternAtom(display, "_NET_WORKAREA", False);
//~ 
  //~ XGetWindowProperty(display, RootWindow(display, screen),
                     //~ workarea, 0, LONG_MAX, False, XA_CARDINAL, &type, &format, &ndata,
                     //~ &after, (unsigned char **)&data);
  //~ if (type != XA_CARDINAL || data == NULL)
  //~ {
    //~ if (data) XFree(data);
    //~ return 0;
  //~ }
//~ 
  //~ *width = data[2];    /* get only for the first desktop */
  //~ *height = data[3];
//~ 
  //~ XFree(data);
  //~ return 1;
//~ }
//~ 




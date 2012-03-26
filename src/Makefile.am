## Process this file with automake to produce Makefile.in

bin_PROGRAMS = simple-panel

AM_CPPFLAGS = \
	-I$(srcdir)/systray \
	-DPACKAGE_LOCALE_DIR=\""$(prefix)/$(DATADIRNAME)/locale"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_UI_DIR=\""$(datadir)/simple-panel/ui"\" \
	$(SIMPLE_PANEL_CFLAGS) \
	$(WNCK_CFLAGS) \
	$(MENUCACHE_CFLAGS) \
	$(X11_CFLAGS) \
	-DWNCK_I_KNOW_THIS_IS_UNSTABLE

AM_CFLAGS =\
	 -Wall\
	 -g

simple_panel_SOURCES = \
	PanelApplication.vala \
	PanelWindow.vala \
	PanelContainer.vala \
	CustomButton.vala \
	$(srcdir)/Applets/PanelApplet.vala \
	$(srcdir)/Applets/MenuApplet.vala \
	$(srcdir)/Applets/LaunchBarApplet.vala \
	$(srcdir)/Applets/PagerApplet.vala \
	$(srcdir)/Applets/TaskListApplet.vala \
	$(srcdir)/Applets/SystemTrayApplet.vala \
	$(srcdir)/Applets/SystemClockApplet.vala \
	$(srcdir)/systray/fixedtip.c \
	$(srcdir)/systray/na-marshal.c \
	$(srcdir)/systray/na-tray.c \
	$(srcdir)/systray/na-tray-child.c \
	$(srcdir)/systray/na-tray-manager.c \
	$(srcdir)/Utils/misc.c

simple_panel_VALAFLAGS = \
	--vapidir=$(top_srcdir)/vapi \
	--pkg config \
	--pkg gtk+-3.0 \
	--pkg gmodule-2.0 \
	--pkg libmenu-cache \
	--pkg libwnck-3.0 \
	--pkg misc \
	--pkg na-tray \
	--pkg x11 \
	--pkg gdk-x11-3.0

simple_panel_LDFLAGS = \
	-Wl

simple_panel_LDADD = \
	$(X11_LIBS) \
	$(SIMPLE_PANEL_LIBS) \
	$(WNCK_LIBS) \
	$(MENUCACHE_LIBS) \
	-lgmodule-2.0

CLEANFILES = $(patsubst %.vala,%.c,$(filter %.vala, $(SOURCES))) simple_panel_vala.stamp


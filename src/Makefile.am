NULL=

bin_PROGRAMS = spanel

AM_CPPFLAGS = \
	-include config.h \
	-I$(srcdir)/Applets/systray \
	-DWNCK_I_KNOW_THIS_IS_UNSTABLE \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	$(NULL)

spanel_CFLAGS = \
	$(FM_CFLAGS) \
	$(MENU_CACHE_CFLAGS) \
	$(WNCK_CFLAGS) \
	-Wall \
	-g \
	$(NULL)

spanel_SOURCES = \
	Application.vala \
	Panel/PanelGroup.vala \
	Panel/PanelWindow.vala \
	Panel/PanelContainer.vala \
	Widgets/CustomButton.vala \
	Widgets/CustomButton2.vala \
	Applets/PanelApplet.vala \
	Applets/MenuApplet.vala \
	Applets/LaunchBarApplet.vala \
	Applets/PagerApplet.vala \
	Applets/TaskListApplet.vala \
	Applets/TaskList/TaskButton.vala \
	Applets/TaskList/TaskAppButton.vala \
	Applets/TaskList/TaskListApplet2.vala \
	Applets/SystemTrayApplet.vala \
	Applets/SystemClockApplet.vala \
	Applets/systray/fixedtip.c \
	Applets/systray/na-marshal.c \
	Applets/systray/na-tray.c \
	Applets/systray/na-tray-child.c \
	Applets/systray/na-tray-manager.c \
	$(NULL)

spanel_VALAFLAGS = \
	--vapidir=$(top_srcdir)/vapi \
	--pkg config \
	--pkg $(GTK_PKG) \
	--pkg libfmcore \
	--pkg gmodule-2.0 \
	--pkg libmenu-cache \
	--pkg libwnck-3.0 \
	--pkg na-tray \
	--pkg x11 \
	--pkg gdk-x11-3.0 \
	$(NULL)

spanel_LDFLAGS = \
	-Wl \
	$(NULL)

spanel_LDADD = \
	$(GTK_LIBS) \
	$(FM_LIBS) \
	$(GMODULE_LIBS) \
	$(MENU_CACHE_LIBS) \
	$(WNCK_LIBS) \
	$(NULL)

CLEANFILES = $(patsubst %.vala,%.c,$(filter %.vala, $(SOURCES))) spanel_vala.stamp


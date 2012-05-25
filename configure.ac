#***************************************************************************************************
#   
#   make clean;make distclean;./autogen.sh && ./configure --enable-debug=yes --prefix=/usr && make
#
#
#
#***************************************************************************************************
AC_INIT(spanel, 0.2)

AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([1.11])
#AM_SILENT_RULES([yes])

AC_PROG_CC

#LT_INIT


#*****************************************************************************************
#   Vala...
#
#
#*****************************************************************************************
AM_PROG_VALAC([0.16.0])


#*****************************************************************************************
#   Checks For Libraries...
#
#   pkg-config --cflags --libs LIB_NAME
#
#*****************************************************************************************
pkg_modules="gtk+-3.0 >= 3.0.0"
GTK_PKG="gtk+-3.0"
CPPFLAGS="$CPPFLAGS -DENABLE_GTK3"
VALAFLAGS="$VALAFLAGS -D ENABLE_GTK3"
AC_DEFINE(ENABLE_GTK3, 1, [Enable GTK3])
AC_SUBST(VALAFLAGS)
AC_SUBST(ENABLE_GTK3)
AC_SUBST(GTK_PKG)

PKG_CHECK_MODULES(GTK, [$pkg_modules])
AC_SUBST(GTK_CFLAGS)
AC_SUBST(GTK_LIBS)

fm_modules="libfmcore-3.0 >= 0.1.99"
PKG_CHECK_MODULES(FM, [$fm_modules])
AC_SUBST(FM_CFLAGS)
AC_SUBST(FM_LIBS)

gmodule_modules="gmodule-2.0"
PKG_CHECK_MODULES(GMODULE, [$gmodule_modules])
AC_SUBST(GMODULE_CFLAGS)
AC_SUBST(GMODULE_LIBS)

menu_modules="libmenu-cache >= 0.3.2"
PKG_CHECK_MODULES(MENU_CACHE, [$menu_modules])
AC_SUBST(MENU_CACHE_CFLAGS)
AC_SUBST(MENU_CACHE_LIBS)

pkg_modules="libwnck-3.0"
PKG_CHECK_MODULES(WNCK, [$pkg_modules])
AC_SUBST(WNCK_CFLAGS)
AC_SUBST(WNCK_LIBS)

AC_CONFIG_FILES([
    Makefile
    data/Makefile
    src/Makefile
])

AC_OUTPUT




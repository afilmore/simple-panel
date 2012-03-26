dnl Process this file with autoconf to produce a configure script.

AC_INIT(simple-panel, 0.1)

AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([1.11])

dnl AM_SILENT_RULES([yes])

AC_PROG_CC

dnl LT_INIT

dnl Check for vala
AM_PROG_VALAC([0.10.0])

PKG_CHECK_MODULES(SIMPLE_PANEL, [gtk+-3.0 ])

pkg_modules="x11"
PKG_CHECK_MODULES(X11, [$pkg_modules])
AC_SUBST(X11_CFLAGS)
AC_SUBST(X11_LIBS)

pkg_modules="libwnck-3.0"
PKG_CHECK_MODULES(WNCK, [$pkg_modules])
AC_SUBST(WNCK_CFLAGS)
AC_SUBST(WNCK_LIBS)

pkg_modules="libmenu-cache"
PKG_CHECK_MODULES(MENUCACHE, [$pkg_modules])
AC_SUBST(MENUCACHE_CFLAGS)
AC_SUBST(MENUCACHE_LIBS)

AC_OUTPUT([
    Makefile
    data/Makefile
    src/Makefile
])

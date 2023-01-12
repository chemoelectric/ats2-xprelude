#
# Copyright © 2022, 2023 Barry Schwartz
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License, as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received copies of the GNU General Public License
# along with this program. If not, see
# <https://www.gnu.org/licenses/>.
#

#--------------------------------------------------------------------------

AC_PREREQ([2.71])
AC_INIT([ats2-xprelude],[1.0.0],[],[ats2-xprelude],[])

AC_CONFIG_HEADERS([config.h])      dnl This is needed for Gnulib.

AC_CONFIG_SRCDIR([xprelude/SATS])

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([build-aux])
AC_CANONICAL_BUILD                 dnl On what platform are we compiling?
AC_CANONICAL_HOST                  dnl For what platform are we compiling?
AC_USE_SYSTEM_EXTENSIONS           dnl Define such macros as _GNU_SOURCE.

AM_INIT_AUTOMAKE
AM_SILENT_RULES
AM_MAINTAINER_MODE
LT_INIT

AC_ARG_VAR([PATSHOME],[the home of the ATS2 compiler])

AC_ARG_VAR([PKGCONFIG_PATSHOME],
  [The PATSHOME setting to put in the pkg-config file [default="${PATSHOME}"]])
if test -z "${PKGCONFIG_PATSHOME}"; then
  PKGCONFIG_PATSHOME="${PATSHOME}"
fi
if test -z "${PKGCONFIG_PATSHOME}"; then
  AC_MSG_ERROR([Please set PKGCONFIG_PATSHOME on the configure command line.])
fi

AM_CONDITIONAL([DEPENDENCY_TRACKING],
  [test x"${enable_dependency_tracking}" != xno])

#--------------------------------------------------------------------------
#
# Checks for programs.

AC_PROG_CC
gl_EARLY
AC_PROG_CC_C_O
AC_PROG_CXX
AC_PROG_CXX_C_O
AC_CHECK_PROGS([PATSOPT],[patsopt])
AC_CHECK_PROGS([M4],[m4])
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_MKDIR_P
AC_PROG_AWK
AC_PROG_SED
AC_PROG_FGREP
AC_PROG_EGREP

gl_INIT

# Enable optional code coverage analysis.
AX_CODE_COVERAGE

PKG_PROG_PKG_CONFIG
PKG_CONFIG="${PKG_CONFIG} --define-variable=PATSHOME=\"${PATSHOME}\""
PKG_INSTALLDIR

#--------------------------------------------------------------------------
#
# Checks for libraries.

PKG_CHECK_MODULES([GMP],[gmp],,
  [AC_MSG_ERROR([GNU Multiple Precision Arithmetic Library is needed but was not found])])

# Use Boehm GC for tests, if it is present.
have_bdwgc=yes
PKG_CHECK_MODULES([BDWGC],[bdw-gc],,[have_bdwgc=no])
if test "${have_bdwgc}" = yes; then
  ATS_MEMALLOC="ATS_MEMALLOC_GCBDW"
  ATS_MEMALLOC_CFLAGS="\$(BDWGC_CFLAGS)"
  ATS_MEMALLOC_LIBS="\$(BDWGC_LIBS)"
else
  ATS_MEMALLOC="ATS_MEMALLOC_LIBC"
  ATS_MEMALLOC_CFLAGS=""
  ATS_MEMALLOC_LIBS=""
fi
AC_SUBST([ATS_MEMALLOC])
AC_SUBST([ATS_MEMALLOC_CFLAGS])
AC_SUBST([ATS_MEMALLOC_LIBS])
if test "${have_bdwgc}" = yes; then
  AC_MSG_NOTICE([Boehm GC found. It is not needed to build the package, but will be used for the tests.])
else
  AC_MSG_NOTICE([Boehm GC not found. It is not needed to build the package, but having it improves the tests.])
fi

#--------------------------------------------------------------------------
#
# Checks for header files.

#--------------------------------------------------------------------------
#
# Checks for typedefs, structures, and compiler characteristics.

#--------------------------------------------------------------------------
#
# Checks for library functions.

#--------------------------------------------------------------------------

CPPFLAGS="${CPPFLAGS}${CPPFLAGS+ }\$(CODE_COVERAGE_CPPFLAGS)"
CFLAGS="${CFLAGS}${CFLAGS+ }\$(CODE_COVERAGE_CFLAGS)"

# Rename symbols in libgnu.
CPPFLAGS="${CPPFLAGS}${CPPFLAGS+ }-Dcount_leading_zeros=ats2_poly_count_leading_zeros"
CPPFLAGS="${CPPFLAGS}${CPPFLAGS+ }-Dcount_leading_zeros_l=ats2_poly_count_leading_zeros_l"
CPPFLAGS="${CPPFLAGS}${CPPFLAGS+ }-Dcount_leading_zeros_ll=ats2_poly_count_leading_zeros_ll"

# You can use ‘@GNU@’ to make GNU Make constructs unbothersome to
# Automake. (By the way, you often can use ‘$(eval ...)’ as well, but
# @GNU@ here may be better.)
AC_SUBST([GNU],[])

StM_REQUIRE_GNU_MAKE_IN_PATH
StM_CONFIG_MAKEFILES

AC_CONFIG_FILES([list-ats-dependencies.dats])
AC_CONFIG_FILES([common-macros.m4])
AC_CONFIG_FILES([ats2-xprelude-macros.m4])
AC_CONFIG_FILES([lib/Makefile])

AC_OUTPUT

#--------------------------------------------------------------------------
# local variables:
# coding: utf-8
# end:
#

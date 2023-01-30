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

AC_ARG_VAR([M4FLAGS],[m4 macroprocessor flags])

AC_ARG_VAR([PATSHOME],[the home of the ATS2 compiler])

AC_ARG_VAR([PKGCONFIG_PATSHOME],
  [The PATSHOME setting to put in the pkg-config file [default="${PATSHOME}"]])
if test -z "${PKGCONFIG_PATSHOME}"; then
  PKGCONFIG_PATSHOME="${PATSHOME}"
fi
if test -z "${PKGCONFIG_PATSHOME}"; then
  AC_MSG_ERROR([Please set PKGCONFIG_PATSHOME on the configure command line.])
fi

AC_ARG_VAR([PATSOPTFLAGS],[ATS2 compiler (patsopt) flags])

AM_CONDITIONAL([DEPENDENCY_TRACKING],
  [test x"${enable_dependency_tracking}" != xno])

AC_ARG_ENABLE([exrat],
  [AS_HELP_STRING([--enable-exrat],
      [enable garbage-collected exact rational types;
        requires https://gmplib.org
        [default=yes]])],
  [],
  [enable_exrat=yes])
if test x"${enable_exrat}" != xyes && test x"${enable_exrat}" != xno; then
  AC_MSG_ERROR([please specify --enable-exrat=yes or --enable-exrat=no])
fi

# We make MPFR support require exrat support, to simplify the
# code. After all, exrat is GMP, and one needs GMP, anyway, if you are
# using MPFR.
AC_ARG_ENABLE([mpfr],
  [AS_HELP_STRING([--enable-mpfr],
      [enable garbage-collected multiple precision floating point types;
        requires https://www.mpfr.org and --enable-exrat=yes
        [default=yes]])],
  [],
  [enable_mpfr=yes])
if test x"${enable_mpfr}" != xyes && test x"${enable_mpfr}" != xno; then
  AC_MSG_ERROR([please specify --enable-mpfr=yes or --enable-mpfr=no])
fi
if test x"${enable_mpfr}" = xyes && test x"${enable_exrat}" = xno; then
  AC_MSG_ERROR([--enable-mpfr=yes requires --enable-exrat=yes])
fi

AC_ARG_WITH([ats2-timsort],
  [AS_HELP_STRING([--with-ats2-timsort],
      [include support for ats2-timsort [default=yes]])],
  [],
  [with_ats2_timsort=yes])
if test x"${with_ats2_timsort}" != xyes && test x"${with_ats2_timsort}" != xno; then
  AC_MSG_ERROR([please specify --with-ats2-timsort=yes or --with-ats2-timsort=no])
fi

AC_ARG_WITH([ats2-quicksorts],
  [AS_HELP_STRING([--with-ats2-quicksorts],
      [include support for ats2-quicksorts [default=yes]])],
  [],
  [with_ats2_quicksorts=yes])
if test x"${with_ats2_quicksorts}" != xyes && test x"${with_ats2_quicksorts}" != xno; then
  AC_MSG_ERROR([please specify --with-ats2-quicksorts=yes or --with-ats2-quicksorts=no])
fi

AC_ARG_ENABLE([default-sorts],
  [AS_HELP_STRING([--enable-default-sorts=N,N,N,N],
      [enable the given sorts as defaults;
       order is array sort, array stable sort,
       list sort, list stable sort;
       choices are 1=prelude, 2=ats2-timsort, 3=ats2-quicksorts
       [default=1,1,1,1]])],
  [],
  [enable_default_sorts='1,1,1,1'])

AC_ARG_ENABLE([exceptions-demo],
  [AS_HELP_STRING([--enable-exceptions-demo={no|array}],
      [when running the tests, enable a demonstration of a variant of pats_ccomp_exception.h])],
  [],
  [enable_exceptions_demo='no'])

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

if test x"${enable_mpfr}" = xyes; then
  PKG_CHECK_MODULES([MPFR],[mpfr],,
    [AC_MSG_ERROR([GNU Multiple Precision Floating-Point Reliable Library not found; consider --enable-mpfr=no])])
fi

if test x"${enable_exrat}" = xyes; then
  PKG_CHECK_MODULES([GMP],[gmp],,
    [AC_MSG_ERROR([GNU Multiple Precision Arithmetic Library not found; consider --enable-exrat=no])])
fi

if test x"${with_ats2_timsort}" = xyes; then
  PKG_CHECK_MODULES([TIMSORT],[ats2-timsort],
    [AC_MSG_NOTICE([ats2-timsort was requested and was found. It will be supported.])],
    [AC_MSG_ERROR([ats2-timsort not found; consider --with-ats2-timsort=no])])
  PKG_CHECK_VAR([TIMSORT_PATSOPTFLAGS],[ats2-timsort],[PATSOPTFLAGS])
fi

if test x"${with_ats2_quicksorts}" = xyes; then
  PKG_CHECK_MODULES([QUICKSORTS],[ats2-quicksorts],
    [AC_MSG_NOTICE([ats2-quicksorts was requested and was found. It will be supported.])],
    [AC_MSG_ERROR([ats2-quicksorts not found; consider --with-ats2-quicksorts=no])])
  PKG_CHECK_VAR([QUICKSORTS_PATSOPTFLAGS],[ats2-quicksorts],[PATSOPTFLAGS])
fi

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

AC_CHECK_TYPE([_Float128])

AM_CONDITIONAL([HAVE_FLOAT128],[test x"${ac_cv_type__Float128}" = xyes])
if test x"${ac_cv_type__Float128}" = xyes; then
  AC_MSG_NOTICE([_Float128 found. The tests will take this into account.])
fi

#--------------------------------------------------------------------------
#
# Checks for library functions.

AC_CHECK_FUNCS(strtof strtod strtold) # <-- These three are standard C99.
AC_CHECK_FUNCS(strtof16 strtof32 strtof64 strtof128)
AC_CHECK_FUNCS(strtof16x strtof32x strtof64x strtof128x)
AC_CHECK_FUNCS(strtod32 strtod64 strtod128)
AC_CHECK_FUNCS(strtod64x strtod128x)

#--------------------------------------------------------------------------
#
# Extract the default sort numbers, and check that they are sensible.

default_array_sort=`printf "%s" "${enable_default_sorts}" | ${AWK} -F ',' '{print $1}'`
default_array_stable_sort=`printf "%s" "${enable_default_sorts}" | ${AWK} -F ',' '{print $2}'`
default_list_sort=`printf "%s" "${enable_default_sorts}" | ${AWK} -F ',' '{print $3}'`
default_list_stable_sort=`printf "%s" "${enable_default_sorts}" | ${AWK} -F ',' '{print $4}'`

m4_define([check_default_sort],
[case "@S|@{$1}" in
  1 )
    :
    ;;
  2 )
    if test x"${with_ats2_timsort}" = xno; then
      AC_MSG_ERROR([This package is configured without ats2-timsort. \
Therefore you cannot have a default sort of 2.])
    fi
    ;;
  3 )
    if test x"${with_ats2_quicksorts}" = xno; then
      AC_MSG_ERROR([This package is configured without ats2-quicksorts. \
Therefore you cannot have a default sort of 3.])
    fi
    ;;
  * )
    AC_MSG_ERROR([\'"@S|@{$1}"\' is not a valid default sort. \
Valid default sorts are 1, 2, and 3.])
    ;;
esac])

check_default_sort([default_array_sort])
check_default_sort([default_array_stable_sort])
check_default_sort([default_list_sort])
check_default_sort([default_list_stable_sort])

#--------------------------------------------------------------------------

AM_CONDITIONAL([ENABLE_EXRAT],[test x"${enable_exrat}" = xyes])
AM_CONDITIONAL([ENABLE_BISECTION_ITERATOR],[test x"${enable_exrat}" = xyes])
AM_CONDITIONAL([ENABLE_MPFR],[test x"${enable_mpfr}" = xyes])
AM_CONDITIONAL([WITH_GMP],[test x"${enable_exrat}" = xyes || test x"${enable_mpfr}" = xyes])

M4FLAGS="${M4FLAGS}${M4FLAGS+ }-DWITH_TIMSORT=${with_ats2_timsort}"
M4FLAGS="${M4FLAGS}${M4FLAGS+ }-DWITH_QUICKSORTS=${with_ats2_quicksorts}"
M4FLAGS="${M4FLAGS}${M4FLAGS+ }-DDEFAULT_ARRAY_SORT=\"${default_array_sort}\""
M4FLAGS="${M4FLAGS}${M4FLAGS+ }-DDEFAULT_ARRAY_STABLE_SORT=\"${default_array_stable_sort}\""
M4FLAGS="${M4FLAGS}${M4FLAGS+ }-DDEFAULT_LIST_SORT=\"${default_list_sort}\""
M4FLAGS="${M4FLAGS}${M4FLAGS+ }-DDEFAULT_LIST_STABLE_SORT=\"${default_list_stable_sort}\""

CPPFLAGS="${CPPFLAGS}${CPPFLAGS+ }\$(CODE_COVERAGE_CPPFLAGS)"
CFLAGS="${CFLAGS}${CFLAGS+ }\$(CODE_COVERAGE_CFLAGS)"

# Rename symbols in libgnu.
CPPFLAGS="${CPPFLAGS}${CPPFLAGS+ }-Dcount_leading_zeros=ats2_poly_count_leading_zeros"
CPPFLAGS="${CPPFLAGS}${CPPFLAGS+ }-Dcount_leading_zeros_l=ats2_poly_count_leading_zeros_l"
CPPFLAGS="${CPPFLAGS}${CPPFLAGS+ }-Dcount_leading_zeros_ll=ats2_poly_count_leading_zeros_ll"

if test x"${with_ats2_timsort}" = xyes; then
  PATSOPTFLAGS="${PATSOPTFLAGS}${PATSOPTFLAGS+ }\$(TIMSORT_PATSOPTFLAGS)"
  CFLAGS="${CFLAGS}${CFLAGS+ }\$(TIMSORT_CFLAGS)"
  LIBS="${LIBS}${LIBS+ }\$(TIMSORT_LIBS)"
fi

if test x"${with_ats2_quicksorts}" = xyes; then
  PATSOPTFLAGS="${PATSOPTFLAGS}${PATSOPTFLAGS+ }\$(QUICKSORTS_PATSOPTFLAGS)"
  CFLAGS="${CFLAGS}${CFLAGS+ }\$(QUICKSORTS_CFLAGS)"
  LIBS="${LIBS}${LIBS+ }\$(QUICKSORTS_LIBS)"
fi

if test x"${enable_mpfr}" = xyes; then
  CFLAGS="${CFLAGS}${CFLAGS+ }\$(MPFR_CFLAGS)"
  LIBS="${LIBS}${LIBS+ }\$(MPFR_LIBS)"
  M4FLAGS="${M4FLAGS}${M4FLAGS+ }-DENABLE_MPFR=yes"
else
  M4FLAGS="${M4FLAGS}${M4FLAGS+ }-DENABLE_MPFR=no"
fi

if test x"${enable_exrat}" = xyes; then
  CFLAGS="${CFLAGS}${CFLAGS+ }\$(GMP_CFLAGS)"
  LIBS="${LIBS}${LIBS+ }\$(GMP_LIBS)"
  M4FLAGS="${M4FLAGS}${M4FLAGS+ }-DENABLE_EXRAT=yes"
else
  M4FLAGS="${M4FLAGS}${M4FLAGS+ }-DENABLE_EXRAT=no"
fi

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
case x"${enable_exceptions_demo}" in
  x"no" )
    ;;
  x"array" )
    AC_CONFIG_FILES([pats_ccomp_exception.h:pats_ccomp_exception.h.array])
    ;;
  * )
    AC_MSG_ERROR([unrecognized exceptions demo (--enable-exceptions-demo="${enable_exceptions_demo}")])
    ;;
esac

AC_OUTPUT

#--------------------------------------------------------------------------
# local variables:
# coding: utf-8
# end:
#

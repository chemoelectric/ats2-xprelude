/*
  Copyright © 2023 Barry Schwartz

  This program is free software: you can redistribute it and/or
  modify it under the terms of the GNU General Public License, as
  published by the Free Software Foundation, either version 3 of the
  License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  General Public License for more details.

  You should have received copies of the GNU General Public License
  along with this program. If not, see
  <https://www.gnu.org/licenses/>.
*/
include(`common-macros.m4')m4_include(`ats2-xprelude-macros.m4')
/*------------------------------------------------------------------*/

#include <config.h>
#include <xprelude/CATS/float.cats>

/*------------------------------------------------------------------*/

m4_foreachq(`FLT1',`conventional_floattypes',`
FLOAT_SUPPORT_CHECK(FLT1)
#if HAVE_`'m4_toupper(strto`'floatt2sfxld(FLT1))
atsvoid_t0ype
my_extern_prefix`'FLT1`'_strto_replace (REF(FLT1) zp, REF(size) jp,
                                        atstype_string s, uintb2c(size) i)
{
  floatt2c(FLT1) *z = (void *) zp;
  uintb2c(size) *j = (void *) jp;
  char *startptr = (char *) (void *) s + i;
  char *endptr;
  *z = strto`'floatt2sfxld(`FLT1') (startptr, &endptr);
  *j = i + (uintb2c(size)) (endptr - startptr);
}
#endif
END_FLOAT_SUPPORT_CHECK(FLT1)
')dnl

/*------------------------------------------------------------------*/
dnl
dnl local variables:
dnl mode: C
dnl end:

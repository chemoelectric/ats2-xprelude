/*
  Copyright © 2022, 2023 Barry Schwartz

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

#ifndef MY_EXTERN_PREFIX`'CATS__FLOAT_CATS__HEADER_GUARD__
#define MY_EXTERN_PREFIX`'CATS__FLOAT_CATS__HEADER_GUARD__

#ifndef my_extern_prefix`'inline
#define my_extern_prefix`'inline ATSinline ()
#endif

#include <float.h>
#include <math.h>
#include <xprelude/CATS/integer.cats>

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT',`conventional_floattypes',
`
my_extern_prefix`'inline floatt2c(FLT)
my_extern_prefix`'g0int2float_`'INT`_'FLT (intb2c(INT) x)
{
  return (floatt2c(FLT)) x;
}
')
')dnl

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT',`conventional_floattypes',
`
my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g0float2int_`'FLT`_'INT (floatt2c(FLT) x)
{
  return (intb2c(INT)) x;
}
')
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`FLT2',`conventional_floattypes',
`
my_extern_prefix`'inline floatt2c(FLT2)
my_extern_prefix`'g0float2float_`'FLT1`_'FLT2 (floatt2c(FLT1) x)
{
  return (floatt2c(FLT2)) x;
}
')
')dnl

#define my_extern_prefix`'g0float_epsilon_float() (FLT_EPSILON)
#define my_extern_prefix`'g0float_epsilon_double() (DBL_EPSILON)
#define my_extern_prefix`'g0float_epsilon_ldouble() (LDBL_EPSILON)

m4_foreachq(`FLT',`conventional_floattypes',
`
my_extern_prefix`'inline atstype_int
my_extern_prefix`'g0float_sgn_`'FLT (floatt2c(FLT) x)
{
  return (x > 0) - (x < 0);
}
')dnl

m4_foreachq(`UOP',`unary_ops',
`m4_foreachq(`FLT',`conventional_floattypes',
`
my_extern_prefix`'inline floatt2c(FLT)
my_extern_prefix`'g0float_`'UOP`'_`'FLT (floatt2c(FLT) x)
{
  return floatt2op(FLT, UOP) (x);
}
')
')dnl

m4_foreachq(`AOP',`binary_ops',
`m4_foreachq(`FLT',`conventional_floattypes',
`
my_extern_prefix`'inline floatt2c(FLT)
my_extern_prefix`'g0float_`'AOP`'_`'FLT (floatt2c(FLT) x,
                                         floatt2c(FLT) y)
{
  return floatt2op(FLT, AOP) (x, y);
}
')
')dnl

m4_foreachq(`TOP',`trinary_ops',
`m4_foreachq(`FLT',`conventional_floattypes',
`
my_extern_prefix`'inline floatt2c(FLT)
my_extern_prefix`'g0float_`'TOP`'_`'FLT (floatt2c(FLT) x,
                                         floatt2c(FLT) y,
                                         floatt2c(FLT) z)
{
  return floatt2op(FLT, TOP) (x, y, z);
}
')
')dnl

#endif /* MY_EXTERN_PREFIX`'CATS__FLOAT_CATS__HEADER_GUARD__ */
dnl
dnl local variables:
dnl mode: C
dnl end:

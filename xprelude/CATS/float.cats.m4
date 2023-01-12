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

#ifndef ATS2_POLY_CATS__FLOAT_CATS__HEADER_GUARD__
#define ATS2_POLY_CATS__FLOAT_CATS__HEADER_GUARD__

#ifndef ats2_poly_inline
#define ats2_poly_inline ATSinline ()
#endif

#include <float.h>
#include <math.h>
#include <xprelude/CATS/integer.cats>

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT',`float,double,ldouble',
`
ats2_poly_inline floatt2c(FLT)
ats2_poly_g0int2float_`'INT`_'FLT (intb2c(INT) x)
{
  return (floatt2c(FLT)) x;
}
')
')dnl

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT',`float,double,ldouble',
`
ats2_poly_inline intb2c(INT)
ats2_poly_g0float2int_`'FLT`_'INT (floatt2c(FLT) x)
{
  return (intb2c(INT)) x;
}
')
')dnl

m4_foreachq(`FLT1',`float,double,ldouble',
`m4_foreachq(`FLT2',`float,double,ldouble',
`
ats2_poly_inline floatt2c(FLT2)
ats2_poly_g0float2float_`'FLT1`_'FLT2 (floatt2c(FLT1) x)
{
  return (floatt2c(FLT2)) x;
}
')
')dnl

#define ats2_poly_g0float_epsilon_float() (FLT_EPSILON)
#define ats2_poly_g0float_epsilon_double() (DBL_EPSILON)
#define ats2_poly_g0float_epsilon_ldouble() (LDBL_EPSILON)

m4_foreachq(`FLT',`float,double,ldouble',
`
ats2_poly_inline atstype_int
ats2_poly_g0float_sgn_`'FLT (floatt2c(FLT) x)
{
  return ((x < 0) ? (-1) : ((x == 0) ? (0) : (1)));
}
')dnl

m4_foreachq(`UOP',`unary_ops',
`
ats2_poly_inline atstype_float
ats2_poly_g0float_`'UOP`'_float (atstype_float x)
{
  return UOP`'f (x);
}

ats2_poly_inline atstype_double
ats2_poly_g0float_`'UOP`'_double (atstype_double x)
{
  return UOP (x);
}

ats2_poly_inline atstype_ldouble
ats2_poly_g0float_`'UOP`'_ldouble (atstype_ldouble x)
{
  return UOP`'l (x);
}
')

m4_foreachq(`AOP',`binary_ops',
`
ats2_poly_inline atstype_float
ats2_poly_g0float_`'AOP`'_float (atstype_float x,
                                 atstype_float y)
{
  return AOP`'f (x, y);
}

ats2_poly_inline atstype_double
ats2_poly_g0float_`'AOP`'_double (atstype_double x,
                                  atstype_double y)
{
  return AOP (x, y);
}

ats2_poly_inline atstype_ldouble
ats2_poly_g0float_`'AOP`'_ldouble (atstype_ldouble x,
                                   atstype_ldouble y)
{
  return AOP`'l (x, y);
}
')

m4_foreachq(`TOP',`trinary_ops',
`
ats2_poly_inline atstype_float
ats2_poly_g0float_`'TOP`'_float (atstype_float x,
                                 atstype_float y,
                                 atstype_float z)
{
  return TOP`'f (x, y, z);
}

ats2_poly_inline atstype_double
ats2_poly_g0float_`'TOP`'_double (atstype_double x,
                                  atstype_double y,
                                  atstype_double z)
{
  return TOP (x, y, z);
}

ats2_poly_inline atstype_ldouble
ats2_poly_g0float_`'TOP`'_ldouble (atstype_ldouble x,
                                   atstype_ldouble y,
                                   atstype_ldouble z)
{
  return TOP`'l (x, y, z);
}
')

#endif /* ATS2_POLY_CATS__FLOAT_CATS__HEADER_GUARD__ */
dnl
dnl local variables:
dnl mode: C
dnl end:

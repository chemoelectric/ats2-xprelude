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

/*------------------------------------------------------------------*/
/*

  We use #define a lot, instead of typedefs, inline functions,
  etc. This way, features missing from the platform are less likely to
  cause an error when one runs the C compiler.

*/
/*------------------------------------------------------------------*/
/* Floating point types one might get with
   __STDC_WANT_IEC_60559_TYPES_EXT__ */

m4_foreachq(`FLT1',`extended_floattypes',
`#define floatt2c(FLT1) floatt2C(FLT1)
')dnl

/*------------------------------------------------------------------*/
/* Printing. */

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'fprint_float (atstype_ref out, floatt2c(float) x)
{
  (void) fprintf ((FILE *) out, "%.6f", (floatt2c(double)) x);
}

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'fprint_double (atstype_ref out, floatt2c(double) x)
{
  (void) fprintf ((FILE *) out, "%.6f", x);
}

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'fprint_ldouble (atstype_ref out, floatt2c(ldouble) x)
{
  (void) fprintf ((FILE *) out, "%.6Lf", x);
}

/*------------------------------------------------------------------*/

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0int2float_`'INT`'_`'FLT1`'(i) ((floatt2c(FLT1)) (i))
')dnl
')dnl

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float2int_`'FLT1`'_`'INT`'(x) ((intb2c(INT)) (x))
')dnl
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`FLT2',`conventional_floattypes',
`#define my_extern_prefix`'g0float2float_`'FLT1`'_`'FLT2`'(x) ((floatt2c(FLT2)) (x))
')dnl
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_epsilon_`'FLT1`'() (floatt2PFX(FLT1)_EPSILON)
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`
FLOAT_SUPPORT_CHECK(FLT1)
my_extern_prefix`'inline atstype_int
my_extern_prefix`'g0float_sgn_`'FLT1 (floatt2c(FLT1) x)
{
  return (x > 0) - (x < 0);
}
END_FLOAT_SUPPORT_CHECK(FLT1)
')dnl

/*
m4_foreachq(`UOP',`unary_ops',
`m4_foreachq(`FLT1',`conventional_floattypes',
`
FLOAT_SUPPORT_CHECK(FLT1)
my_extern_prefix`'inline floatt2c(FLT1)
my_extern_prefix`'g0float_`'UOP`'_`'FLT1 (floatt2c(FLT1) x)
{
  return floatt2op(FLT1, UOP) (x);
}
END_FLOAT_SUPPORT_CHECK(FLT1)
')
')dnl
*/

m4_foreachq(`OP',`unary_ops,binary_ops,trinary_ops',
`m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_`'OP`'_`'FLT1 floatt2op(FLT1, OP)
')
')dnl

/*
m4_foreachq(`AOP',`binary_ops',
`m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_`'AOP`'_`'FLT1 floatt2op(FLT1, AOP)
')
')dnl
*/

/*
m4_foreachq(`TOP',`trinary_ops',
`m4_foreachq(`FLT1',`conventional_floattypes',
`
FLOAT_SUPPORT_CHECK(FLT1)
my_extern_prefix`'inline floatt2c(FLT1)
my_extern_prefix`'g0float_`'TOP`'_`'FLT1 (floatt2c(FLT1) x,
                                          floatt2c(FLT1) y,
                                          floatt2c(FLT1) z)
{
  return floatt2op(FLT1, TOP) (x, y, z);
}
END_FLOAT_SUPPORT_CHECK(FLT1)
')
')dnl
*/

/*------------------------------------------------------------------*/
/* For absolute value, use the C function instead of our own code. */

m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_abs_`'FLT1 my_extern_prefix`'g0float_fabs_`'FLT1
')dnl

/*------------------------------------------------------------------*/

#endif /* MY_EXTERN_PREFIX`'CATS__FLOAT_CATS__HEADER_GUARD__ */
dnl
dnl local variables:
dnl mode: C
dnl end:

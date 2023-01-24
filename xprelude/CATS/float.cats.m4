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

#ifndef my_extern_prefix`'boolc2ats
#define my_extern_prefix`'boolc2ats(B) \
  ((B) ? (atsbool_true) : (atsbool_false))
#endif

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

m4_foreachq(`FLT1',`regular_floattypes',
`#define my_extern_prefix`'print_`'FLT1`'(x) my_extern_prefix`'fprint_`'FLT1` '(stdout, x)
')dnl

m4_foreachq(`FLT1',`regular_floattypes',
`#define my_extern_prefix`'prerr_`'FLT1`'(x) my_extern_prefix`'fprint_`'FLT1` '(stderr, x)
')dnl

/*------------------------------------------------------------------*/
/* Type conversions. */

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

/*------------------------------------------------------------------*/
/* Epsilon. */

m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_epsilon_`'FLT1`'() (floatt2PFX(FLT1)_EPSILON)
')dnl

/*------------------------------------------------------------------*/
/* Float radix. */

_Static_assert (2 <= FLT_RADIX, "FLT_RADIX is less than 2");

m4_foreachq(`FLT1',`regular_floattypes',
`#define my_extern_prefix`'g0float_radix_`'FLT1`'() (FLT_RADIX)
')dnl
m4_foreachq(`FLT1',`extended_binary_floattypes',
`#define my_extern_prefix`'g0float_radix_`'FLT1`'() (2)
')dnl
m4_foreachq(`FLT1',`extended_decimal_floattypes',
`#define my_extern_prefix`'g0float_radix_`'FLT1`'() (10)
')dnl

/*------------------------------------------------------------------*/
/* Miscellaneous other floating point parameters. */

m4_foreachq(`FLT1',`regular_floattypes',
`#define my_extern_prefix`'g0float_huge_val_`'FLT1`'() HUGE_VAL`'floatt2SFX(FLT1)
')dnl
m4_foreachq(`FLT1',`extended_floattypes',
`#define my_extern_prefix`'g0float_huge_val_`'FLT1`'() HUGE_VAL_`'floatt2SFX(FLT1)
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_mant_dig_`'FLT1`'() floatt2PFX(FLT1)_MANT_DIG
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_min_exp_`'FLT1`'() floatt2PFX(FLT1)_MIN_EXP
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_max_exp_`'FLT1`'() floatt2PFX(FLT1)_MAX_EXP
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_max_value_`'FLT1`'() ((floatt2c(FLT1)) (floatt2PFX(FLT1)_MAX))
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_min_value_`'FLT1`'() ((floatt2c(FLT1)) (floatt2PFX(FLT1)_MIN))
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_true_min_value_`'FLT1`'() ((floatt2c(FLT1)) (floatt2PFX(FLT1)_TRUE_MIN))
')dnl

m4_foreachq(`FLT1',`regular_floattypes, extended_binary_floattypes',
`#define my_extern_prefix`'g0float_`'decimal_dig_`'FLT1`'() floatt2PFX(FLT1)_DECIMAL_DIG
')dnl

m4_foreachq(`FLT1',`regular_floattypes, extended_binary_floattypes',
`#define my_extern_prefix`'g0float_`'dig_`'FLT1`'() floatt2PFX(FLT1)_DIG
')dnl

m4_foreachq(`FLT1',`regular_floattypes, extended_binary_floattypes',
`#define my_extern_prefix`'g0float_`'min_10_exp_`'FLT1`'() floatt2PFX(FLT1)_MIN_10_EXP
')dnl

m4_foreachq(`FLT1',`regular_floattypes, extended_binary_floattypes',
`#define my_extern_prefix`'g0float_`'max_10_exp_`'FLT1`'() floatt2PFX(FLT1)_MAX_10_EXP
')dnl

/*------------------------------------------------------------------*/
/* Infinity and NaN. */

/* Positive infinity. */
m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_infinity_`'FLT1`'() ((floatt2c(FLT1)) INFINITY)
')dnl

/* Quiet NaN. */
m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_nan_`'FLT1`'() ((floatt2c(FLT1)) NAN)
')dnl

/* Signaling NaN. */
m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_snan_`'FLT1`'() SNAN`'floatt2SFX(FLT1)
')dnl

/* Classifications. */

m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_isfinite_`'FLT1 isfinite
#define my_extern_prefix`'g0float_isnormal_`'FLT1 isnormal
#define my_extern_prefix`'g0float_isnan_`'FLT1 isnan
#define my_extern_prefix`'g0float_isinf_`'FLT1 isinf

')dnl
/*------------------------------------------------------------------*/
/* Sign, absolute value, negative. */

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

/* Use our own code instead of fabsXXX for absolute value, because
   libc often does not have support for decimal floating point. */
m4_foreachq(`FLT1',`conventional_floattypes',
`
FLOAT_SUPPORT_CHECK(FLT1)
my_extern_prefix`'inline floatt2c(FLT1)
my_extern_prefix`'g0float_abs_`'FLT1 (floatt2c(FLT1) x)
{
  return (x < 0) ? (-x) : (x);
}
END_FLOAT_SUPPORT_CHECK(FLT1)
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`
FLOAT_SUPPORT_CHECK(FLT1)
my_extern_prefix`'inline floatt2c(FLT1)
my_extern_prefix`'g0float_neg_`'FLT1 (floatt2c(FLT1) x)
{
  return (-x);
}
END_FLOAT_SUPPORT_CHECK(FLT1)
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`
FLOAT_SUPPORT_CHECK(FLT1)
my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'g0float_negate_`'FLT1 (atstype_ref px)
{
  floatt2c(FLT1) *x = px;
  *x = -(*x);
}
END_FLOAT_SUPPORT_CHECK(FLT1)
')dnl

/*------------------------------------------------------------------*/
/* Library functions. */

m4_foreachq(`OP',`unary_ops, binary_ops, trinary_ops,
                  floattype_intmax_ops,
                  scalbn, scalbln, ilogb,
                  frexp, modf',
`m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_`'OP`'_`'FLT1 floatt2op(FLT1, OP)
')dnl

')dnl
m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_unsafe_strfrom_`'FLT1 strfrom`'floatt2sfxd(`FLT1')
')dnl
m4_foreachq(`FLT1',`conventional_floattypes',
`#define my_extern_prefix`'g0float_unsafe_strto_`'FLT1`'(nptr, endptr)dnl
 strto`'floatt2sfxld(`FLT1')` '((const char *) (nptr), (char **) (endptr))
')dnl

/*------------------------------------------------------------------*/
/* Comparisons. */

m4_foreachq(`FLT1',`conventional_floattypes',
`FLOAT_SUPPORT_CHECK(FLT1)
m4_foreachq(`OP',`comparisons',
`my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_`'OP`'_`'FLT1 (floatt2c(FLT1) x, floatt2c(FLT1) y)
{
  return my_extern_prefix`'boolc2ats (x ats_cmp_c(OP) y);
}
my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_is`'OP`'z_`'FLT1 (floatt2c(FLT1) x)
{
  return my_extern_prefix`'boolc2ats (x ats_cmp_c(OP) ((floatt2c(FLT1)) 0));
}
')dnl
my_extern_prefix`'inline atstype_int
my_extern_prefix`'g0float_compare_`'FLT1 (floatt2c(FLT1) x, floatt2c(FLT1) y)
{
  return (x > y) - (x < y);
}
END_FLOAT_SUPPORT_CHECK(FLT1)

')dnl
/*------------------------------------------------------------------*/
/* Miscellaneous arithmetic. */

m4_foreachq(`FLT1',`conventional_floattypes',
`
FLOAT_SUPPORT_CHECK(FLT1)
my_extern_prefix`'inline floatt2c(FLT1)
my_extern_prefix`'g0float_succ_`'FLT1 (floatt2c(FLT1) x)
{
  return (x + 1);
}
my_extern_prefix`'inline floatt2c(FLT1)
my_extern_prefix`'g0float_pred_`'FLT1 (floatt2c(FLT1) x)
{
  return (x - 1);
}
END_FLOAT_SUPPORT_CHECK(FLT1)
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`
FLOAT_SUPPORT_CHECK(FLT1)
my_extern_prefix`'inline floatt2c(FLT1)
my_extern_prefix`'g0float_min_`'FLT1 (floatt2c(FLT1) x, floatt2c(FLT1) y)
{
  return ((x < y) ? x : y);
}
my_extern_prefix`'inline floatt2c(FLT1)
my_extern_prefix`'g0float_max_`'FLT1 (floatt2c(FLT1) x, floatt2c(FLT1) y)
{
  return ((x > y) ? x : y);
}
m4_foreachq(`OP',`add,sub,mul,div',
`my_extern_prefix`'inline floatt2c(FLT1)
my_extern_prefix`'g0float_`'OP`'_`'FLT1 (floatt2c(FLT1) x, floatt2c(FLT1) y)
{
  return (x ats_binop_c(OP) y);
}
')dnl
#define my_extern_prefix`'g0float_mod_`'FLT1 my_extern_prefix`'g0float_fmod_`'FLT1
END_FLOAT_SUPPORT_CHECK(FLT1)
')dnl

/*------------------------------------------------------------------*/

#endif /* MY_EXTERN_PREFIX`'CATS__FLOAT_CATS__HEADER_GUARD__ */
dnl
dnl local variables:
dnl mode: C
dnl end:

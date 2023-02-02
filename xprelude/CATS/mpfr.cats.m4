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

#ifndef MY_EXTERN_PREFIX`'CATS__MPFR_CATS__HEADER_GUARD__
#define MY_EXTERN_PREFIX`'CATS__MPFR_CATS__HEADER_GUARD__

#ifndef my_extern_prefix`'inline
#define my_extern_prefix`'inline ATSinline ()
#endif

FLOAT_SUPPORT_CHECK(`float128')
#define MPFR_WANT_FLOAT128 1
END_FLOAT_SUPPORT_CHECK(`float128')

FLOAT_SUPPORT_CHECK(`decimal64')
FLOAT_SUPPORT_CHECK(`decimal128')
#define MPFR_WANT_DECIMAL_FLOATS 1
END_FLOAT_SUPPORT_CHECK(`decimal128')
END_FLOAT_SUPPORT_CHECK(`decimal64')

#include <stdatomic.h>
#include <stdlib.h>
#include <stdio.h>
#include <mpfr.h>

#ifndef my_extern_prefix`'boolc2ats
#define my_extern_prefix`'boolc2ats(B) \
  ((B) ? (atsbool_true) : (atsbool_false))
#endif

/*------------------------------------------------------------------*/
/* If you change my_extern_prefix`'mpfr_rnd in a multithreaded
   program, it is your responsibility to handle locking. */

extern volatile mpfr_rnd_t my_extern_prefix`'mpfr_rnd;

/*------------------------------------------------------------------*/
/* One-time initialization of mpfr support. */

extern volatile atomic_int my_extern_prefix`'mpfr_support_is_initialized;
atsvoid_t0ype my_extern_prefix`'mpfr_support_initialize (atsvoid_t0ype);

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'mpfr_one_time_initialization (void)
{
  /* Initialize mpfr support. This inline function will be called the
     first time an mpfr is created. */

  if (!atomic_load_explicit (&my_extern_prefix`'mpfr_support_is_initialized,
                             memory_order_acquire))
    my_extern_prefix`'mpfr_support_initialize ();
}

/*------------------------------------------------------------------*/

typedef mpfr_t my_extern_prefix`'mpfr_t;
typedef my_extern_prefix`'mpfr_t *my_extern_prefix`'mpfr;

/*------------------------------------------------------------------*/
/* Classification. */

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_isfinite_mpfr (floatt2c(mpfr) x)
{
  return my_extern_prefix`'boolc2ats (mpfr_number_p (x[0]));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_isnormal_mpfr (floatt2c(mpfr) x)
{
  /* mpfr floating-point does not have subnormal numbers, and thus any
     finite number is normal. */

  return my_extern_prefix`'boolc2ats (mpfr_number_p (x[0]));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_isnan_mpfr (floatt2c(mpfr) x)
{
  return my_extern_prefix`'boolc2ats (mpfr_nan_p (x[0]));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_isinf_mpfr (floatt2c(mpfr) x)
{
  return my_extern_prefix`'boolc2ats (mpfr_inf_p (x[0]));
}

/*------------------------------------------------------------------*/
/* Printing. */

atsvoid_t0ype my_extern_prefix`'fprint_mpfr (atstype_ref fref, floatt2c(mpfr));
atsvoid_t0ype my_extern_prefix`'print_mpfr (floatt2c(mpfr));
atsvoid_t0ype my_extern_prefix`'prerr_mpfr (floatt2c(mpfr));

/*------------------------------------------------------------------*/
/* Precision. */

atsvoid_t0ype my_extern_prefix`'mpfr_set_default_prec_uintmax (uintb2c(uintmax) x);
atsvoid_t0ype my_extern_prefix`'mpfr_set_prec_uintmax (REF(mpfr), uintb2c(uintmax));

my_extern_prefix`'inline intb2c(intmax)
my_extern_prefix`'mpfr_get_default_prec (void)
{
  return (intb2c(intmax)) mpfr_get_default_prec ();
}

my_extern_prefix`'inline intb2c(intmax)
my_extern_prefix`'mpfr_get_prec (floatt2c(mpfr) x)
{
  return (intb2c(intmax)) mpfr_get_prec (x[0]);
}

/*------------------------------------------------------------------*/
/* Creating new mpfr instances of given precision. */

floatt2c(mpfr) my_extern_prefix`'_mpfr_make_nan_prec_uintmax (uintb2c(uintmax));

/*------------------------------------------------------------------*/
/* Comparisons. */

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_lt_mpfr (floatt2c(mpfr) x, floatt2c(mpfr) y)
{
  return my_extern_prefix`'boolc2ats (mpfr_less_p (x[0], y[0]));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_lte_mpfr (floatt2c(mpfr) x, floatt2c(mpfr) y)
{
  return my_extern_prefix`'boolc2ats (mpfr_lessequal_p (x[0], y[0]));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_gt_mpfr (floatt2c(mpfr) x, floatt2c(mpfr) y)
{
  return my_extern_prefix`'boolc2ats (mpfr_greater_p (x[0], y[0]));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_gte_mpfr (floatt2c(mpfr) x, floatt2c(mpfr) y)
{
  return my_extern_prefix`'boolc2ats (mpfr_greaterequal_p (x[0], y[0]));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_eq_mpfr (floatt2c(mpfr) x, floatt2c(mpfr) y)
{
  return my_extern_prefix`'boolc2ats (mpfr_equal_p (x[0], y[0]));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_neq_mpfr (floatt2c(mpfr) x, floatt2c(mpfr) y)
{
  return my_extern_prefix`'boolc2ats (mpfr_lessgreater_p (x[0], y[0]));
}

my_extern_prefix`'inline intb2c(int)
my_extern_prefix`'g0float_compare_mpfr (floatt2c(mpfr) x, floatt2c(mpfr) y)
{
  int cmp = mpfr_cmp (x[0], y[0]);
  return (cmp > 0) - (cmp < 0);
}

m4_foreachq(`OP',`lt,lte,gt,gte',
`my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_is`'OP`'z_mpfr (floatt2c(mpfr) x)
{
  return my_extern_prefix`'boolc2ats (mpfr_cmp_ui (x[0], 0) ats_cmp_c(OP) 0);
}

')dnl
my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_iseqz_mpfr (floatt2c(mpfr) x)
{
  return my_extern_prefix`'boolc2ats (mpfr_zero_p (x[0]));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g0float_isneqz_mpfr (floatt2c(mpfr) x)
{
  return my_extern_prefix`'boolc2ats (!mpfr_zero_p (x[0]));
}

/*------------------------------------------------------------------*/
/* g0float_strto. */

floatt2c(mpfr) my_extern_prefix`'g0float_unsafe_strto_mpfr (atstype_ptr, atstype_ptr);

/*------------------------------------------------------------------*/
/* Assorted operations. */

m4_foreachq(`OP',`infinity, nan, huge_val',
`floatt2c(mpfr) my_extern_prefix`'g0float_`'OP`'_mpfr (void);
')dnl

m4_foreachq(`OP',`neg, abs, reciprocal, unary_ops',
`floatt2c(mpfr) my_extern_prefix`'g0float_`'OP`'_mpfr (floatt2c(mpfr));
')dnl

m4_foreachq(`OP',`add, sub, mul, div, binary_ops',
`floatt2c(mpfr) my_extern_prefix`'g0float_`'OP`'_mpfr (floatt2c(mpfr), floatt2c(mpfr));
')dnl

m4_foreachq(`OP',`trinary_ops',
`floatt2c(mpfr) my_extern_prefix`'g0float_`'OP`'_mpfr (floatt2c(mpfr), floatt2c(mpfr), floatt2c(mpfr));
')dnl

m4_foreachq(`OP',`floattype_intmax_ops',
`floatt2c(mpfr) my_extern_prefix`'g0float_`'OP`'_mpfr (floatt2c(mpfr), intb2c(intmax));
')dnl

floatt2c(mpfr) my_extern_prefix`'_g0float_mul_2exp_intmax_mpfr (floatt2c(mpfr), intb2c(intmax));

/*------------------------------------------------------------------*/
/* Value-replacement */

atsvoid_t0ype my_extern_prefix`'mpfr_mpfr_replace (REF(mpfr) yp, floatt2c(mpfr) x);
atsvoid_t0ype _`'my_extern_prefix`'mpfr_intmax_replace (REF(mpfr) yp, intb2c(intmax) x);
atsvoid_t0ype my_extern_prefix`'fixed32p32_mpfr_replace (REF(mpfr) yp, floatt2c(mpfr) x);
atsvoid_t0ype my_extern_prefix`'exrat_mpfr_replace (REF(mpfr) yp, floatt2c(mpfr) x);

m4_foreachq(`INT',`intbases',
`#define my_extern_prefix`'mpfr_`'INT`'_replace(x, y)dnl
 (_`'my_extern_prefix`'mpfr_intmax_replace ((x), (intb2c(intmax)) (y)))
')dnl
m4_foreachq(`T',`floattypes_without_mpfr',
`FLOAT_SUPPORT_CHECK_FOR_MPFR(T)
atsvoid_t0ype my_extern_prefix`'mpfr_`'T`'_replace (REF(mpfr) yp, floatt2c(T) x);
END_FLOAT_SUPPORT_CHECK_FOR_MPFR(T)
')dnl

atsvoid_t0ype my_extern_prefix`'mpfr_exchange (REF(mpfr) yp, REF(mpfr) xp);

m4_foreachq(`OP',`infinity, nan, huge_val',
`atsvoid_t0ype my_extern_prefix`'mpfr_`'OP`'_replace (REF(mpfr));
')dnl

m4_foreachq(`OP',`neg, abs, reciprocal, unary_ops',
`atsvoid_t0ype my_extern_prefix`'mpfr_`'OP`'_replace (REF(mpfr), floatt2c(mpfr));
')dnl

m4_foreachq(`OP',`add, sub, mul, div, binary_ops',
`atsvoid_t0ype my_extern_prefix`'mpfr_`'OP`'_replace (REF(mpfr), floatt2c(mpfr), floatt2c(mpfr));
')dnl

m4_foreachq(`OP',`trinary_ops',
`atsvoid_t0ype my_extern_prefix`'mpfr_`'OP`'_replace (REF(mpfr), floatt2c(mpfr), floatt2c(mpfr), floatt2c(mpfr));
')dnl

m4_foreachq(`OP',`floattype_intmax_ops',
`atsvoid_t0ype my_extern_prefix`'mpfr_`'OP`'_replace (REF(mpfr), floatt2c(mpfr), intb2c(intmax));
')dnl

atsvoid_t0ype my_extern_prefix`'mpfr_unsafe_strto_replace (REF(mpfr) zp, atstype_ptr, atstype_ptr);
atsvoid_t0ype my_extern_prefix`'mpfr_strto_replace (REF(mpfr) zp, REF(size) jp, atstype_string, uintb2c(size));

atsvoid_t0ype my_extern_prefix`'mpfr_mul_2exp_intmax_replace (REF(mpfr) zp, floatt2c(mpfr) x, intb2c(intmax) n);
m4_foreachq(`INT',`intbases',
`m4_if(INT,`intmax',,
`#define my_extern_prefix`'mpfr_mul_2exp_`'INT`'_replace(zp, x, n)dnl
 my_extern_prefix`'mpfr_mul_2exp_intmax_replace ((zp), (x), (intb2c(intmax)) (n))
#define my_extern_prefix`'mpfr_div_2exp_`'INT`'_replace(zp, x, n)dnl
 my_extern_prefix`'mpfr_mul_2exp_intmax_replace ((zp), (x), -((intb2c(intmax)) (n)))
')dnl
')dnl

m4_foreachq(`CONST',`list_of_m4_constant',
`atsvoid_t0ype my_extern_prefix`'mpfr_mathconst_`'CONST`'_replace (REF(mpfr) zp);
')dnl

/*------------------------------------------------------------------*/

#endif `/*' MY_EXTERN_PREFIX`'CATS__MPFR_CATS__HEADER_GUARD__ */
dnl
dnl local variables:
dnl mode: C
dnl end:
dnl

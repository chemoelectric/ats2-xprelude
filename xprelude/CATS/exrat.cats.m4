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

#ifndef MY_EXTERN_PREFIX`'CATS__EXRAT_CATS__HEADER_GUARD__
#define MY_EXTERN_PREFIX`'CATS__EXRAT_CATS__HEADER_GUARD__

/*------------------------------------------------------------------*/

#include <xprelude/CATS/attributes.cats>
#include <stdatomic.h>
#include <stdlib.h>
#include <stdio.h>
#include <gmp.h>
#include <xprelude/CATS/integer.cats>
#include <xprelude/CATS/float.cats>
#include <xprelude/CATS/fixed32p32.cats>

#ifndef my_extern_prefix`'boolc2ats
#define my_extern_prefix`'boolc2ats(B) \
  ((B) ? (atsbool_true) : (atsbool_false))
#endif

/*------------------------------------------------------------------*/

extern volatile atomic_int my_extern_prefix`'exrat_support_is_initialized;
extern atsvoid_t0ype my_extern_prefix`'mark_gmp_initialized (void);
extern atsvoid_t0ype my_extern_prefix`'exrat_support_initialize (void);

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'exrat_one_time_initialization (void)
{
  /* Initialize exrat support. This inline function will be called the
     first time an exrat is created. */

  if (!atomic_load_explicit (&my_extern_prefix`'exrat_support_is_initialized,
                             memory_order_acquire))
    my_extern_prefix`'exrat_support_initialize ();
}

typedef mpz_t my_extern_prefix`'mpz_t;
typedef mpq_t my_extern_prefix`'mpq_t;
typedef my_extern_prefix`'mpq_t *floatt2c(exrat);

atsvoid_t0ype my_extern_prefix`'fprint_exrat (atstype_ref fref,
                                          floatt2c(exrat) x);
atsvoid_t0ype my_extern_prefix`'print_exrat (floatt2c(exrat) x);
atsvoid_t0ype my_extern_prefix`'prerr_exrat (floatt2c(exrat) x);

floatt2c(exrat) my_extern_prefix`'g0float_exrat_make_ulint_ulint (atstype_ulint,
                                                                  atstype_ulint);
floatt2c(exrat) my_extern_prefix`'g0float_exrat_make_lint_ulint (atstype_lint,
                                                                 atstype_ulint);

atsvoid_t0ype my_extern_prefix`'_g0float_exrat_make_from_string (atstype_string s,
                                                             atstype_int base,
                                                             REF(exrat) p_y,
                                                             atstype_ref p_status);

atstype_string my_extern_prefix`'tostrptr_exrat_given_base (floatt2c(exrat), int);
atstype_string my_extern_prefix`'tostring_exrat_given_base (floatt2c(exrat), int);
atstype_string my_extern_prefix`'tostrptr_exrat_base10 (floatt2c(exrat));
atstype_string my_extern_prefix`'tostring_exrat_base10 (floatt2c(exrat));

floatt2c(exrat) my_extern_prefix`'g0int2float_lint_exrat (atstype_lint);

m4_foreachq(`INT',`int8,int16,int32,sint,int,ssize',
`#define my_extern_prefix`'g0int2float_`'INT`'_exrat(x)dnl
  (my_extern_prefix`'g0int2float_lint_exrat ((intb2c(lint)) (x)))
')dnl

atstype_lint my_extern_prefix`'g0float2int_exrat_lint (floatt2c(exrat));

m4_foreachq(`INT',`int8,int16,int32,sint,int,ssize',
`#define my_extern_prefix`'g0float2int_exrat_`'INT`'(x)dnl
  ((intb2c(INT)) my_extern_prefix`'g0float2int_exrat_lint (x))
')dnl

m4_foreachq(`INT',`int64,llint,intmax',
`
floatt2c(exrat) my_extern_prefix`'g0int2float_`'INT`'_exrat_32bit (intb2c(INT) x);
floatt2c(exrat) my_extern_prefix`'g0int2float_`'INT`'_exrat (intb2c(INT) x);
')dnl

/* FIXME: on x86, etc., int64, llint, and intmax_t are larger than
   lint. Special handling is needed but not yet provided. */
m4_foreachq(`INT',`int64,llint,intmax',
`#define my_extern_prefix`'g0float2int_exrat_`'INT(x) dnl
((intb2c(INT)) my_extern_prefix`'g0float2int_exrat_lint (x))
')dnl

floatt2c(exrat) my_extern_prefix`'g0float2float_double_exrat (atstype_double);
floatt2c(exrat) my_extern_prefix`'g0float2float_ldouble_exrat (atstype_ldouble);
floatt2c(exrat) my_extern_prefix`'g0float2float_fixed32p32_exrat (my_extern_prefix`'fixed32p32);
floatt2c(exrat) my_extern_prefix`'g0float2float_fixed32p32_exrat_32bit (my_extern_prefix`'fixed32p32 x);

#define my_extern_prefix`'g0float2float_float_exrat(x)                  \
  (my_extern_prefix`'g0float2float_double_exrat ((intb2c(double)) (x)))

atstype_double my_extern_prefix`'g0float2float_exrat_double (floatt2c(exrat) x);
atstype_ldouble my_extern_prefix`'g0float2float_exrat_ldouble (floatt2c(exrat) x);
my_extern_prefix`'fixed32p32 my_extern_prefix`'g0float2float_exrat_fixed32p32 (floatt2c(exrat) x);
my_extern_prefix`'fixed32p32 my_extern_prefix`'g0float2float_exrat_fixed32p32_32bit (floatt2c(exrat) x);

#define my_extern_prefix`'g0float2float_exrat_float(x)                  \
  ((atstype_float) my_extern_prefix`'g0float2float_exrat_double (x))

my_extern_prefix`'inline floatt2c(exrat)
my_extern_prefix`'g0float2float_exrat_exrat (floatt2c(exrat) x)
{
  return x;
}

my_extern_prefix`'inline atstype_int
my_extern_prefix`'g0float_sgn_exrat (floatt2c(exrat) x)
{
  return mpq_sgn (x[0]);
}

floatt2c(exrat) my_extern_prefix`'g0float_neg_exrat (floatt2c(exrat) x);
floatt2c(exrat) my_extern_prefix`'g0float_reciprocal_exrat (floatt2c(exrat) x);
floatt2c(exrat) my_extern_prefix`'g0float_abs_exrat (floatt2c(exrat) x);
floatt2c(exrat) my_extern_prefix`'g0float_fabs_exrat (floatt2c(exrat) x);

floatt2c(exrat) my_extern_prefix`'g0float_succ_exrat (floatt2c(exrat) x);
floatt2c(exrat) my_extern_prefix`'g0float_pred_exrat (floatt2c(exrat) x);

floatt2c(exrat) my_extern_prefix`'g0float_add_exrat (floatt2c(exrat) x,
                                                     floatt2c(exrat) y);
floatt2c(exrat) my_extern_prefix`'g0float_sub_exrat (floatt2c(exrat) x,
                                                     floatt2c(exrat) y);

floatt2c(exrat) my_extern_prefix`'g0float_min_exrat (floatt2c(exrat) x,
                                                     floatt2c(exrat) y);
floatt2c(exrat) my_extern_prefix`'g0float_max_exrat (floatt2c(exrat) x,
                                                     floatt2c(exrat) y);

atstype_bool my_extern_prefix`'g0float_eq_exrat (floatt2c(exrat) x,
                                                 floatt2c(exrat) y);
atstype_bool my_extern_prefix`'g0float_neq_exrat (floatt2c(exrat) x,
                                                  floatt2c(exrat) y);
atstype_bool my_extern_prefix`'g0float_lt_exrat (floatt2c(exrat) x,
                                                 floatt2c(exrat) y);
atstype_bool my_extern_prefix`'g0float_lte_exrat (floatt2c(exrat) x,
                                                  floatt2c(exrat) y);
atstype_bool my_extern_prefix`'g0float_gt_exrat (floatt2c(exrat) x,
                                                 floatt2c(exrat) y);
atstype_bool my_extern_prefix`'g0float_gte_exrat (floatt2c(exrat) x,
                                                  floatt2c(exrat) y);

atstype_int my_extern_prefix`'g0float_compare_exrat (floatt2c(exrat) x,
                                                     floatt2c(exrat) y);

floatt2c(exrat) my_extern_prefix`'g0float_mul_exrat (floatt2c(exrat) x,
                                                     floatt2c(exrat) y);
floatt2c(exrat) my_extern_prefix`'g0float_div_exrat (floatt2c(exrat) x,
                                                     floatt2c(exrat) y);

floatt2c(exrat) my_extern_prefix`'g0float_fma_exrat (floatt2c(exrat) x,
                                                     floatt2c(exrat) y,
                                                     floatt2c(exrat) z);

floatt2c(exrat) my_extern_prefix`'g0float_round_exrat (floatt2c(exrat) x);
floatt2c(exrat) my_extern_prefix`'g0float_nearbyint_exrat (floatt2c(exrat) x);
floatt2c(exrat) my_extern_prefix`'g0float_floor_exrat (floatt2c(exrat) x);
floatt2c(exrat) my_extern_prefix`'g0float_ceil_exrat (floatt2c(exrat) x);
floatt2c(exrat) my_extern_prefix`'g0float_trunc_exrat (floatt2c(exrat) x);

my_extern_prefix`'inline floatt2c(exrat)
my_extern_prefix`'g0float_rint_exrat (floatt2c(exrat) x)
{
  return my_extern_prefix`'g0float_nearbyint_exrat (x);
}

floatt2c(exrat) my_extern_prefix`'g0float_npow_exrat (floatt2c(exrat) x,
                                                      atstype_int n);

floatt2c(exrat) my_extern_prefix`'_g0float_intmax_pow_exrat (floatt2c(exrat) x,
                                                             intb2c(intmax) n);

floatt2c(exrat) my_extern_prefix`'_g0float_mul_2exp_intmax_exrat (floatt2c(exrat),
                                                                  intb2c(intmax));

/*------------------------------------------------------------------*/
/* Support for integers. */

floatt2c(exrat) my_extern_prefix`'exrat_numerator (floatt2c(exrat) x);
floatt2c(exrat) my_extern_prefix`'exrat_denominator (floatt2c(exrat) x);

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'exrat_is_integer (floatt2c(exrat) x)
{
  return (mpz_cmp_si (mpq_denref (x[0]), 1) == 0);
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'exrat_numerator_is_even (floatt2c(exrat) x)
{
  return my_extern_prefix`'boolc2ats (mpz_even_p (mpq_numref (x[0])));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'exrat_numerator_is_odd (floatt2c(exrat) x)
{
  return my_extern_prefix`'boolc2ats (mpz_odd_p (mpq_numref (x[0])));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'exrat_numerator_is_perfect_power (floatt2c(exrat) x)
{
  return my_extern_prefix`'boolc2ats (mpz_perfect_power_p (mpq_numref (x[0])));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'exrat_numerator_is_perfect_square (floatt2c(exrat) x)
{
  return my_extern_prefix`'boolc2ats (mpz_perfect_square_p (mpq_numref (x[0])));
}

my_extern_prefix`'inline uintb2c(uintmax)
my_extern_prefix`'exrat_numerator_ffs (floatt2c(exrat) x)
{
  return ((mpz_sgn (mpq_numref (x[0])) == 0) ?
          (0) :
          (mpz_scan1 (mpq_numref (x[0]), 0) + 1));
}

floatt2c(exrat) my_extern_prefix`'exrat_numerator_land (floatt2c(exrat), floatt2c(exrat));
floatt2c(exrat) my_extern_prefix`'exrat_numerator_lor (floatt2c(exrat), floatt2c(exrat));
floatt2c(exrat) my_extern_prefix`'exrat_numerator_lxor (floatt2c(exrat), floatt2c(exrat));
floatt2c(exrat) my_extern_prefix`'exrat_numerator_lnot (floatt2c(exrat));

my_extern_prefix`'inline intb2c(int)
my_extern_prefix`'exrat_numerator_bit_ltest (floatt2c(exrat) x, uintb2c(uintmax) i)
{
  return mpz_tstbit (mpq_numref (x[0]), i);
}

floatt2c(exrat) my_extern_prefix`'exrat_numerator_bit_lset (floatt2c(exrat) x, uintb2c(uintmax) i,
                                                            intb2c(int) b);
floatt2c(exrat) my_extern_prefix`'exrat_numerator_bit_lnot (floatt2c(exrat) x, uintb2c(uintmax) i);

my_extern_prefix`'inline uintb2c(uintmax)
my_extern_prefix`'exrat_numerator_popcount (floatt2c(exrat) x)
{
  return mpz_popcount (mpq_numref (x[0]));
}

my_extern_prefix`'inline uintb2c(uintmax)
my_extern_prefix`'exrat_numerator_hamming_distance (floatt2c(exrat) x, floatt2c(exrat) y)
{
  return mpz_hamdist (mpq_numref (x[0]), mpq_numref (y[0]));
}

my_extern_prefix`'inline intb2c(int)
my_extern_prefix`'exrat_numerator_legendre_symbol (floatt2c(exrat) a, floatt2c(exrat) b)
{
  return mpz_legendre (mpq_numref (a[0]), mpq_numref (b[0]));
}

my_extern_prefix`'inline intb2c(int)
my_extern_prefix`'exrat_numerator_jacobi_symbol (floatt2c(exrat) a, floatt2c(exrat) b)
{
  return mpz_jacobi (mpq_numref (a[0]), mpq_numref (b[0]));
}

my_extern_prefix`'inline intb2c(int)
my_extern_prefix`'exrat_numerator_kronecker_symbol (floatt2c(exrat) a, floatt2c(exrat) b)
{
  return mpz_kronecker (mpq_numref (a[0]), mpq_numref (b[0]));
}

floatt2c(exrat) my_extern_prefix`'exrat_numerator_root (floatt2c(exrat), intb2c(ulint));
floatt2c(exrat) my_extern_prefix`'exrat_numerator_sqrt (floatt2c(exrat));

atsvoid_t0ype my_extern_prefix`'_exrat_numerator_rootrem (REF(exrat) q, REF(exrat) r,
                                                          floatt2c(exrat) x, intb2c(ulint) n);
atsvoid_t0ype my_extern_prefix`'_exrat_numerator_sqrtrem (REF(exrat) q, REF(exrat) r,
                                                          floatt2c(exrat) x);

floatt2c(exrat) my_extern_prefix`'exrat_numerator_gcd (floatt2c(exrat), floatt2c(exrat));
floatt2c(exrat) my_extern_prefix`'exrat_numerator_lcm (floatt2c(exrat), floatt2c(exrat));

floatt2c(exrat) my_extern_prefix`'_exrat_numerator_gcd_bezout (REF(exrat), REF(exrat), REF(exrat),
                                                               floatt2c(exrat), floatt2c(exrat));

atsvoid_t0ype my_extern_prefix`'_exrat_numerator_remove_factor (REF(exrat), REF(uintmax),
                                                                floatt2c(exrat), floatt2c(exrat));

floatt2c(exrat) my_extern_prefix`'exrat_factorial (uintb2c(ulint));
floatt2c(exrat) my_extern_prefix`'exrat_double_factorial (uintb2c(ulint));
floatt2c(exrat) my_extern_prefix`'exrat_multifactorial (uintb2c(ulint), uintb2c(ulint));
floatt2c(exrat) my_extern_prefix`'exrat_primorial (uintb2c(ulint));

floatt2c(exrat) my_extern_prefix`'exrat_numerator_bincoef (floatt2c(exrat), uintb2c(ulint));
floatt2c(exrat) my_extern_prefix`'exrat_bincoef (uintb2c(ulint), uintb2c(ulint));

floatt2c(exrat) my_extern_prefix`'exrat_fibonacci_number (uintb2c(ulint));
floatt2c(exrat) my_extern_prefix`'exrat_lucas_number (uintb2c(ulint));

atsvoid_t0ype my_extern_prefix`'_exrat_two_fibonacci_numbers (REF(exrat), REF(exrat), uintb2c(ulint));
atsvoid_t0ype my_extern_prefix`'_exrat_two_lucas_numbers (REF(exrat), REF(exrat), uintb2c(ulint));

m4_foreachq(`ROUND',`euclid, floor, ceil, trunc',
`floatt2c(exrat) my_extern_prefix`'exrat_numerator_`'ROUND`'_quotient (floatt2c(exrat), floatt2c(exrat));
floatt2c(exrat) my_extern_prefix`'exrat_numerator_`'ROUND`'_remainder (floatt2c(exrat), floatt2c(exrat));
atsvoid_t0ype my_extern_prefix`'_exrat_numerator_`'ROUND`'_division (REF(exrat), REF(exrat),
                                                                     floatt2c(exrat), floatt2c(exrat));
floatt2c(exrat) my_extern_prefix`'exrat_numerator_`'ROUND`'_quotient_2exp (floatt2c(exrat), uintb2c(uintmax));
floatt2c(exrat) my_extern_prefix`'exrat_numerator_`'ROUND`'_remainder_2exp (floatt2c(exrat), uintb2c(uintmax));
')dnl

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'exrat_numerator_congruent (floatt2c(exrat) x, floatt2c(exrat) y, floatt2c(exrat) d)
{
  return my_extern_prefix`'boolc2ats (mpz_congruent_p (mpq_numref (x[0]), mpq_numref (y[0]),
                                                       mpq_numref (d[0])));
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'exrat_numerator_congruent_2exp (floatt2c(exrat) x, floatt2c(exrat) y, uintb2c(uintmax) i)
{
  return my_extern_prefix`'boolc2ats (mpz_congruent_2exp_p (mpq_numref (x[0]), mpq_numref (y[0]), i));
}

atsvoid_t0ype my_extern_prefix`'_exrat_numerator_modular_inverse (REF(bool), REF(exrat),
                                                                  floatt2c(exrat), floatt2c(exrat));
floatt2c(exrat) my_extern_prefix`'exrat_numerator_modular_pow (floatt2c(exrat), floatt2c(exrat),
                                                               floatt2c(exrat));

intb2c(int) my_extern_prefix`'_exrat_numerator_prime_test (floatt2c(exrat), intb2c(int));
floatt2c(exrat) my_extern_prefix`'exrat_numerator_probable_next_prime (floatt2c(exrat));

/*------------------------------------------------------------------*/
/* Value-replacement. */

atsvoid_t0ype my_extern_prefix`'exrat_exchange (REF(exrat) yp, REF(exrat) xp);

atsvoid_t0ype my_extern_prefix`'exrat_exrat_replace (REF(exrat) yp, floatt2c(exrat) x);

m4_foreachq(`INT',`int8,int16,int32,sint,int,ssize',
`#define my_extern_prefix`'exrat_`'INT`'_replace(yp, x)dnl
 my_extern_prefix`'exrat_lint_replace (yp, (intb2c(lint)) x)
')dnl

atsvoid_t0ype my_extern_prefix`'exrat_lint_replace (REF(exrat) yp, floatt2c(lint) x);

m4_foreachq(`FLT1',`float',
`#define my_extern_prefix`'exrat_`'FLT1`'_replace(yp, x)dnl
 my_extern_prefix`'exrat_double_replace (yp, (intb2c(double)) x)
')dnl

atsvoid_t0ype my_extern_prefix`'exrat_double_replace (REF(exrat) yp, floatt2c(double) x);

m4_foreachq(FLT1,`float,double',
`atsvoid_t0ype my_extern_prefix`'FLT1`'_exrat_replace (REF(FLT1) yp, floatt2c(exrat) x);
')dnl

/* FIXME: The following type-conversion-replacements are done by
          creating a new exrat and then doing an
          exrat_exrat_replace. Consider writing more efficient
          implementations. */
m4_foreachq(`INT',`intbases',
`m4_ifelementq(INT,`int8,int16,int32,sint,int,lint,ssize',,
`#define my_extern_prefix`'exrat_`'INT`'_replace(yp, x)dnl
 my_extern_prefix`'exrat_exrat_replace ((yp), my_extern_prefix`'g0int2float_`'INT`'_exrat ((x)))
')dnl
')dnl
m4_foreachq(`FLT1',`floattypes_without_exrat',
`m4_ifelementq(FLT1,`float,double',,
`#define my_extern_prefix`'exrat_`'FLT1`'_replace(yp, x)dnl
 my_extern_prefix`'exrat_exrat_replace ((yp), my_extern_prefix`'g0float2float_`'FLT1`'_exrat ((x)))
')dnl
')dnl

m4_foreachq(`OP',`abs, neg, reciprocal, succ, pred, unary_ops',
`atsvoid_t0ype my_extern_prefix`'exrat_`'OP`'_replace (REF(exrat), floatt2c(exrat));
')dnl

m4_foreachq(`OP',`min, max, add, sub, mul, div, mod,
                  binary_ops, floattype_intmax_ops',
`atsvoid_t0ype my_extern_prefix`'exrat_`'OP`'_replace (REF(exrat), floatt2c(exrat), floatt2c(exrat));
')dnl

m4_foreachq(`OP',`trinary_ops',
`atsvoid_t0ype my_extern_prefix`'exrat_`'OP`'_replace (REF(exrat), floatt2c(exrat), floatt2c(exrat), floatt2c(exrat));
')dnl

atsvoid_t0ype my_extern_prefix`'exrat_npow_replace (REF(exrat), floatt2c(exrat), intb2c(int));

atsvoid_t0ype my_extern_prefix`'exrat_intmax_pow_replace (REF(exrat), floatt2c(exrat), intb2c(intmax));
m4_foreachq(`INT',`intbases',
`m4_if(INT,`intmax',,
`#define my_extern_prefix`'exrat_`'INT`'_pow_replace(zp, x, n)dnl
 my_extern_prefix`'exrat_intmax_pow_replace ((zp), (x), (intb2c(intmax)) (n))
')dnl
')dnl

atsvoid_t0ype my_extern_prefix`'exrat_mul_2exp_intmax_replace (REF(exrat), floatt2c(exrat), intb2c(intmax));
m4_foreachq(`INT',`intbases',
`m4_if(INT,`intmax',,
`#define my_extern_prefix`'exrat_mul_2exp_`'INT`'_replace(zp, x, n)dnl
 my_extern_prefix`'exrat_mul_2exp_intmax_replace ((zp), (x), (intb2c(intmax)) (n))
#define my_extern_prefix`'exrat_div_2exp_`'INT`'_replace(zp, x, n)dnl
 my_extern_prefix`'exrat_mul_2exp_intmax_replace ((zp), (x), -((intb2c(intmax)) (n)))
')dnl
')dnl

/*------------------------------------------------------------------*/

#endif `/*' MY_EXTERN_PREFIX`'CATS__EXRAT_CATS__HEADER_GUARD__ */
dnl
dnl local variables:
dnl mode: C
dnl end:
dnl

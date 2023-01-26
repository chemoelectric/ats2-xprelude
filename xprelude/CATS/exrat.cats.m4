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

#ifndef my_extern_prefix`'inline
#define my_extern_prefix`'inline ATSinline ()
#endif

#include <stdatomic.h>
#include <stdlib.h>
#include <stdio.h>
#include <gmp.h>
#include <xprelude/CATS/fixed32p32.cats>

/*------------------------------------------------------------------*/

extern volatile atomic_int my_extern_prefix`'exrat_support_is_initialized;
extern atsvoid_t0ype my_extern_prefix`'exrat_support_initialize (atsvoid_t0ype);

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

#define my_extern_prefix`'g0int2float_int8_exrat(x)                 \
  (my_extern_prefix`'g0int2float_lint_exrat ((atstype_lint) (x)))
#define my_extern_prefix`'g0int2float_int16_exrat(x)                \
  (my_extern_prefix`'g0int2float_lint_exrat ((atstype_lint) (x)))
#define my_extern_prefix`'g0int2float_int32_exrat(x)                \
  (my_extern_prefix`'g0int2float_lint_exrat ((atstype_lint) (x)))
#define my_extern_prefix`'g0int2float_sint_exrat(x)                 \
  (my_extern_prefix`'g0int2float_lint_exrat ((atstype_lint) (x)))
#define my_extern_prefix`'g0int2float_int_exrat(x)                  \
  (my_extern_prefix`'g0int2float_lint_exrat ((atstype_lint) (x)))
#define my_extern_prefix`'g0int2float_ssize_exrat(x)                \
  (my_extern_prefix`'g0int2float_lint_exrat ((atstype_lint) (x)))

atstype_lint my_extern_prefix`'g0float2int_exrat_lint (floatt2c(exrat));

#define my_extern_prefix`'g0float2int_exrat_int8(x)             \
  ((atstype_int8) my_extern_prefix`'g0float2int_exrat_lint (x))
#define my_extern_prefix`'g0float2int_exrat_int16(x)                \
  ((atstype_int16) my_extern_prefix`'g0float2int_exrat_lint (x))
#define my_extern_prefix`'g0float2int_exrat_int32(x)                \
  ((atstype_int32) my_extern_prefix`'g0float2int_exrat_lint (x))
#define my_extern_prefix`'g0float2int_exrat_sint(x)             \
  ((atstype_sint) my_extern_prefix`'g0float2int_exrat_lint (x))
#define my_extern_prefix`'g0float2int_exrat_int(x)              \
  ((atstype_int) my_extern_prefix`'g0float2int_exrat_lint (x))
#define my_extern_prefix`'g0float2int_exrat_ssize(x)                \
  ((atstype_ssize) my_extern_prefix`'g0float2int_exrat_lint (x))

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
  (my_extern_prefix`'g0float2float_double_exrat ((atstype_double) (x)))

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

floatt2c(exrat) floatt2c(exrat)_numerator (floatt2c(exrat) x);
floatt2c(exrat) floatt2c(exrat)_denominator (floatt2c(exrat) x);

my_extern_prefix`'inline atstype_bool
floatt2c(exrat)_is_integer (floatt2c(exrat) x)
{
  return (mpz_cmp_si (mpq_denref (x[0]), 1) == 0);
}

my_extern_prefix`'inline atstype_bool
floatt2c(exrat)_is_even (floatt2c(exrat) x)
{
  return (mpz_cmp_si (mpq_denref (x[0]), 1) == 0
          && mpz_tstbit (mpq_numref (x[0]), 0) == 0);
}

my_extern_prefix`'inline atstype_bool
floatt2c(exrat)_is_odd (floatt2c(exrat) x)
{
  return (mpz_cmp_si (mpq_denref (x[0]), 1) == 0
          && mpz_tstbit (mpq_numref (x[0]), 0) != 0);
}

my_extern_prefix`'inline atstype_ulint
floatt2c(exrat)_ffs (floatt2c(exrat) x)
{
  return ((mpz_sgn (mpq_numref (x[0])) == 0) ?
          (0) :
          (mpz_scan1 (mpq_numref (x[0]), 0) + 1));
}

floatt2c(exrat) floatt2c(exrat)_mul_exp2 (floatt2c(exrat), atstype_ulint);
floatt2c(exrat) floatt2c(exrat)_div_exp2 (floatt2c(exrat), atstype_ulint);

/*------------------------------------------------------------------*/
/* Value-replacement symbols. */

atsvoid_t0ype my_extern_prefix`'exrat_exrat_replace (REF(exrat) yp, floatt2c(exrat) x);
atsvoid_t0ype my_extern_prefix`'exrat_exchange (REF(exrat) yp, REF(exrat) xp);
atsvoid_t0ype my_extern_prefix`'g0float_negate_exrat (REF(exrat) xp);

/*------------------------------------------------------------------*/

#endif /* MY_EXTERN_PREFIX`'CATS__EXRAT_CATS__HEADER_GUARD__ */
dnl
dnl local variables:
dnl mode: C
dnl end:
dnl

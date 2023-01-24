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

#ifndef my_extern_prefix`'inline
#define my_extern_prefix`'inline ATSinline ()
#endif

#include <stdatomic.h>
#include <stdlib.h>
#include <stdio.h>
#include <gmp.h>
#include <xprelude/CATS/fixed32p32.cats>

extern volatile atomic_int my_extern_prefix`'exrat_support_is_initialized;
extern atsvoid_t0ype my_extern_prefix`'exrat_support_initialize (atsvoid_t0ype);

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'exrat_one_time_initialization (void)
{
  if (!atomic_load_explicit (&my_extern_prefix`'exrat_support_is_initialized,
                             memory_order_acquire))
    my_extern_prefix`'exrat_support_initialize ();
}

typedef mpz_t my_extern_prefix`'mpz_t;
typedef mpq_t my_extern_prefix`'mpq_t;
typedef my_extern_prefix`'mpq_t *my_extern_prefix`'exrat;

atsvoid_t0ype my_extern_prefix`'fprint_exrat (atstype_ref fref,
                                          my_extern_prefix`'exrat x);
atsvoid_t0ype my_extern_prefix`'print_exrat (my_extern_prefix`'exrat x);
atsvoid_t0ype my_extern_prefix`'prerr_exrat (my_extern_prefix`'exrat x);

my_extern_prefix`'exrat my_extern_prefix`'g0float_exrat_make_ulint_ulint (atstype_ulint,
                                                                  atstype_ulint);
my_extern_prefix`'exrat my_extern_prefix`'g0float_exrat_make_lint_ulint (atstype_lint,
                                                                 atstype_ulint);

atsvoid_t0ype my_extern_prefix`'_g0float_exrat_make_from_string (atstype_string s,
                                                             atstype_int base,
                                                             atstype_ref p_y,
                                                             atstype_ref p_status);

atstype_string my_extern_prefix`'tostrptr_exrat_given_base (my_extern_prefix`'exrat, int);
atstype_string my_extern_prefix`'tostring_exrat_given_base (my_extern_prefix`'exrat, int);
atstype_string my_extern_prefix`'tostrptr_exrat_base10 (my_extern_prefix`'exrat);
atstype_string my_extern_prefix`'tostring_exrat_base10 (my_extern_prefix`'exrat);

my_extern_prefix`'exrat my_extern_prefix`'g0int2float_lint_exrat (atstype_lint);

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

atstype_lint my_extern_prefix`'g0float2int_exrat_lint (my_extern_prefix`'exrat);

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
my_extern_prefix`'exrat my_extern_prefix`'g0int2float_`'INT`'_exrat_32bit (intb2c(INT) x);
my_extern_prefix`'exrat my_extern_prefix`'g0int2float_`'INT`'_exrat (intb2c(INT) x);
')dnl

/* FIXME: on x86, etc., int64, llint, and intmax_t are larger than
   lint. Special handling is needed but not yet provided. */
m4_foreachq(`INT',`int64,llint,intmax',
`#define my_extern_prefix`'g0float2int_exrat_`'INT(x) dnl
((intb2c(INT)) my_extern_prefix`'g0float2int_exrat_lint (x))
')dnl

my_extern_prefix`'exrat my_extern_prefix`'g0float2float_double_exrat (atstype_double);
my_extern_prefix`'exrat my_extern_prefix`'g0float2float_ldouble_exrat (atstype_ldouble);
my_extern_prefix`'exrat my_extern_prefix`'g0float2float_fixed32p32_exrat (my_extern_prefix`'fixed32p32);
my_extern_prefix`'exrat my_extern_prefix`'g0float2float_fixed32p32_exrat_32bit (my_extern_prefix`'fixed32p32 x);

#define my_extern_prefix`'g0float2float_float_exrat(x)                  \
  (my_extern_prefix`'g0float2float_double_exrat ((atstype_double) (x)))

atstype_double my_extern_prefix`'g0float2float_exrat_double (my_extern_prefix`'exrat x);
atstype_ldouble my_extern_prefix`'g0float2float_exrat_ldouble (my_extern_prefix`'exrat x);
my_extern_prefix`'fixed32p32 my_extern_prefix`'g0float2float_exrat_fixed32p32 (my_extern_prefix`'exrat x);
my_extern_prefix`'fixed32p32 my_extern_prefix`'g0float2float_exrat_fixed32p32_32bit (my_extern_prefix`'exrat x);

#define my_extern_prefix`'g0float2float_exrat_float(x)                  \
  ((atstype_float) my_extern_prefix`'g0float2float_exrat_double (x))

my_extern_prefix`'inline my_extern_prefix`'exrat
my_extern_prefix`'g0float2float_exrat_exrat (my_extern_prefix`'exrat x)
{
  return x;
}

my_extern_prefix`'inline atstype_int
my_extern_prefix`'g0float_sgn_exrat (my_extern_prefix`'exrat x)
{
  return mpq_sgn (x[0]);
}

my_extern_prefix`'exrat my_extern_prefix`'g0float_neg_exrat (my_extern_prefix`'exrat x);
my_extern_prefix`'exrat my_extern_prefix`'g0float_abs_exrat (my_extern_prefix`'exrat x);
my_extern_prefix`'exrat my_extern_prefix`'g0float_fabs_exrat (my_extern_prefix`'exrat x);

my_extern_prefix`'exrat my_extern_prefix`'g0float_succ_exrat (my_extern_prefix`'exrat x);
my_extern_prefix`'exrat my_extern_prefix`'g0float_pred_exrat (my_extern_prefix`'exrat x);

my_extern_prefix`'exrat my_extern_prefix`'g0float_add_exrat (my_extern_prefix`'exrat x,
                                                     my_extern_prefix`'exrat y);
my_extern_prefix`'exrat my_extern_prefix`'g0float_sub_exrat (my_extern_prefix`'exrat x,
                                                     my_extern_prefix`'exrat y);

my_extern_prefix`'exrat my_extern_prefix`'g0float_min_exrat (my_extern_prefix`'exrat x,
                                                     my_extern_prefix`'exrat y);
my_extern_prefix`'exrat my_extern_prefix`'g0float_max_exrat (my_extern_prefix`'exrat x,
                                                     my_extern_prefix`'exrat y);

atstype_bool my_extern_prefix`'g0float_eq_exrat (my_extern_prefix`'exrat x,
                                             my_extern_prefix`'exrat y);
atstype_bool my_extern_prefix`'g0float_neq_exrat (my_extern_prefix`'exrat x,
                                              my_extern_prefix`'exrat y);
atstype_bool my_extern_prefix`'g0float_lt_exrat (my_extern_prefix`'exrat x,
                                             my_extern_prefix`'exrat y);
atstype_bool my_extern_prefix`'g0float_lte_exrat (my_extern_prefix`'exrat x,
                                              my_extern_prefix`'exrat y);
atstype_bool my_extern_prefix`'g0float_gt_exrat (my_extern_prefix`'exrat x,
                                             my_extern_prefix`'exrat y);
atstype_bool my_extern_prefix`'g0float_gte_exrat (my_extern_prefix`'exrat x,
                                              my_extern_prefix`'exrat y);

atstype_int my_extern_prefix`'g0float_compare_exrat (my_extern_prefix`'exrat x,
                                                 my_extern_prefix`'exrat y);

my_extern_prefix`'exrat my_extern_prefix`'g0float_mul_exrat (my_extern_prefix`'exrat x,
                                                     my_extern_prefix`'exrat y);
my_extern_prefix`'exrat my_extern_prefix`'g0float_div_exrat (my_extern_prefix`'exrat x,
                                                     my_extern_prefix`'exrat y);

my_extern_prefix`'exrat my_extern_prefix`'g0float_fma_exrat (my_extern_prefix`'exrat x,
                                                     my_extern_prefix`'exrat y,
                                                     my_extern_prefix`'exrat z);

my_extern_prefix`'exrat my_extern_prefix`'g0float_round_exrat (my_extern_prefix`'exrat x);
my_extern_prefix`'exrat my_extern_prefix`'g0float_nearbyint_exrat (my_extern_prefix`'exrat x);
my_extern_prefix`'exrat my_extern_prefix`'g0float_floor_exrat (my_extern_prefix`'exrat x);
my_extern_prefix`'exrat my_extern_prefix`'g0float_ceil_exrat (my_extern_prefix`'exrat x);
my_extern_prefix`'exrat my_extern_prefix`'g0float_trunc_exrat (my_extern_prefix`'exrat x);

my_extern_prefix`'inline my_extern_prefix`'exrat
my_extern_prefix`'g0float_rint_exrat (my_extern_prefix`'exrat x)
{
  return my_extern_prefix`'g0float_nearbyint_exrat (x);
}

my_extern_prefix`'exrat my_extern_prefix`'g0float_npow_exrat (my_extern_prefix`'exrat x,
                                                      atstype_int n);

my_extern_prefix`'exrat my_extern_prefix`'_g0float_intmax_pow_exrat (floatt2c(exrat) x,
                                                      intb2c(intmax) n);

my_extern_prefix`'exrat my_extern_prefix`'exrat_numerator (my_extern_prefix`'exrat x);
my_extern_prefix`'exrat my_extern_prefix`'exrat_denominator (my_extern_prefix`'exrat x);

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'exrat_is_integer (my_extern_prefix`'exrat x)
{
  return (mpz_cmp_si (mpq_denref (x[0]), 1) == 0);
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'exrat_is_even (my_extern_prefix`'exrat x)
{
  return (mpz_cmp_si (mpq_denref (x[0]), 1) == 0
          && mpz_tstbit (mpq_numref (x[0]), 0) == 0);
}

my_extern_prefix`'inline atstype_bool
my_extern_prefix`'exrat_is_odd (my_extern_prefix`'exrat x)
{
  return (mpz_cmp_si (mpq_denref (x[0]), 1) == 0
          && mpz_tstbit (mpq_numref (x[0]), 0) != 0);
}

my_extern_prefix`'inline atstype_ulint
my_extern_prefix`'exrat_ffs (my_extern_prefix`'exrat x)
{
  return ((mpz_sgn (mpq_numref (x[0])) == 0) ?
          (0) :
          (mpz_scan1 (mpq_numref (x[0]), 0) + 1));
}

my_extern_prefix`'exrat my_extern_prefix`'exrat_mul_exp2 (my_extern_prefix`'exrat,
                                                  atstype_ulint);
my_extern_prefix`'exrat my_extern_prefix`'exrat_div_exp2 (my_extern_prefix`'exrat,
                                                  atstype_ulint);

#endif /* MY_EXTERN_PREFIX`'CATS__EXRAT_CATS__HEADER_GUARD__ */
dnl
dnl local variables:
dnl mode: C
dnl end:
dnl

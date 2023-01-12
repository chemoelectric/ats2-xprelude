/*
  Copyright © 2022 Barry Schwartz

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

#ifndef ATS2_POLY_CATS__EXRAT_CATS__HEADER_GUARD__
#define ATS2_POLY_CATS__EXRAT_CATS__HEADER_GUARD__

#ifndef ats2_poly_inline
#define ats2_poly_inline ATSinline ()
#endif

#include <stdatomic.h>
#include <stdlib.h>
#include <stdio.h>
#include <gmp.h>
#include <xprelude/CATS/fixed32p32.cats>

extern volatile atomic_int ats2_poly_exrat_support_is_initialized;
extern atsvoid_t0ype ats2_poly_exrat_support_initialize (atsvoid_t0ype);

ats2_poly_inline atsvoid_t0ype
ats2_poly_exrat_one_time_initialization (void)
{
  if (!atomic_load_explicit (&ats2_poly_exrat_support_is_initialized,
                             memory_order_acquire))
    ats2_poly_exrat_support_initialize ();
}

typedef mpz_t ats2_poly_mpz_t;
typedef mpq_t ats2_poly_mpq_t;
typedef ats2_poly_mpq_t *ats2_poly_exrat;

atsvoid_t0ype ats2_poly_fprint_exrat (atstype_ref fref,
                                      ats2_poly_exrat x);
atsvoid_t0ype ats2_poly_print_exrat (ats2_poly_exrat x);
atsvoid_t0ype ats2_poly_prerr_exrat (ats2_poly_exrat x);

ats2_poly_exrat ats2_poly_g0float_exrat_make_ulint_ulint (atstype_ulint,
                                                          atstype_ulint);
ats2_poly_exrat ats2_poly_g0float_exrat_make_lint_ulint (atstype_lint,
                                                         atstype_ulint);

atsvoid_t0ype ats2_poly__g0float_exrat_make_from_string (atstype_string s,
                                                         atstype_int base,
                                                         atstype_ref p_y,
                                                         atstype_ref p_status);

atstype_string ats2_poly_tostrptr_exrat_given_base (ats2_poly_exrat, int);
atstype_string ats2_poly_tostring_exrat_given_base (ats2_poly_exrat, int);
atstype_string ats2_poly_tostrptr_exrat_base10 (ats2_poly_exrat);
atstype_string ats2_poly_tostring_exrat_base10 (ats2_poly_exrat);

ats2_poly_exrat ats2_poly_g0int2float_lint_exrat (atstype_lint);

#define ats2_poly_g0int2float_int8_exrat(x)                 \
  (ats2_poly_g0int2float_lint_exrat ((atstype_lint) (x)))
#define ats2_poly_g0int2float_int16_exrat(x)                \
  (ats2_poly_g0int2float_lint_exrat ((atstype_lint) (x)))
#define ats2_poly_g0int2float_int32_exrat(x)                \
  (ats2_poly_g0int2float_lint_exrat ((atstype_lint) (x)))
#define ats2_poly_g0int2float_sint_exrat(x)                 \
  (ats2_poly_g0int2float_lint_exrat ((atstype_lint) (x)))
#define ats2_poly_g0int2float_int_exrat(x)                  \
  (ats2_poly_g0int2float_lint_exrat ((atstype_lint) (x)))
#define ats2_poly_g0int2float_ssize_exrat(x)                \
  (ats2_poly_g0int2float_lint_exrat ((atstype_lint) (x)))

atstype_lint ats2_poly_g0float2int_exrat_lint (ats2_poly_exrat);

#define ats2_poly_g0float2int_exrat_int8(x)             \
  ((atstype_int8) ats2_poly_g0float2int_exrat_lint (x))
#define ats2_poly_g0float2int_exrat_int16(x)                \
  ((atstype_int16) ats2_poly_g0float2int_exrat_lint (x))
#define ats2_poly_g0float2int_exrat_int32(x)                \
  ((atstype_int32) ats2_poly_g0float2int_exrat_lint (x))
#define ats2_poly_g0float2int_exrat_sint(x)             \
  ((atstype_sint) ats2_poly_g0float2int_exrat_lint (x))
#define ats2_poly_g0float2int_exrat_int(x)              \
  ((atstype_int) ats2_poly_g0float2int_exrat_lint (x))
#define ats2_poly_g0float2int_exrat_ssize(x)                \
  ((atstype_ssize) ats2_poly_g0float2int_exrat_lint (x))

ats2_poly_exrat ats2_poly_g0int2float_int64_exrat_32bit (atstype_int64 x);
ats2_poly_exrat ats2_poly_g0int2float_int64_exrat (atstype_int64 x);

ats2_poly_exrat ats2_poly_g0int2float_llint_exrat_32bit (atstype_llint x);
ats2_poly_exrat ats2_poly_g0int2float_llint_exrat (atstype_llint x);

/* FIXME: on x86, etc., int64 and llint are larger than lint. Special
   handling is needed but not yet provided. */
#define ats2_poly_g0float2int_exrat_int64(x)                \
  ((atstype_int64) ats2_poly_g0float2int_exrat_lint (x))
#define ats2_poly_g0float2int_exrat_llint(x)                \
  ((atstype_llint) ats2_poly_g0float2int_exrat_lint (x))

ats2_poly_exrat ats2_poly_g0float2float_double_exrat (atstype_double);
ats2_poly_exrat ats2_poly_g0float2float_ldouble_exrat (atstype_ldouble);
ats2_poly_exrat ats2_poly_g0float2float_fixed32p32_exrat (ats2_poly_fixed32p32);
ats2_poly_exrat ats2_poly_g0float2float_fixed32p32_exrat_32bit (ats2_poly_fixed32p32 x);

#define ats2_poly_g0float2float_float_exrat(x)                  \
  (ats2_poly_g0float2float_double_exrat ((atstype_double) (x)))

atstype_double ats2_poly_g0float2float_exrat_double (ats2_poly_exrat x);
atstype_ldouble ats2_poly_g0float2float_exrat_ldouble (ats2_poly_exrat x);
ats2_poly_fixed32p32 ats2_poly_g0float2float_exrat_fixed32p32 (ats2_poly_exrat x);
ats2_poly_fixed32p32 ats2_poly_g0float2float_exrat_fixed32p32_32bit (ats2_poly_exrat x);

#define ats2_poly_g0float2float_exrat_float(x)                  \
  ((atstype_float) ats2_poly_g0float2float_exrat_double (x))

ats2_poly_inline ats2_poly_exrat
ats2_poly_g0float2float_exrat_exrat (ats2_poly_exrat x)
{
  return x;
}

ats2_poly_inline atstype_int
ats2_poly_g0float_sgn_exrat (ats2_poly_exrat x)
{
  return mpq_sgn (x[0]);
}

ats2_poly_exrat ats2_poly_g0float_neg_exrat (ats2_poly_exrat x);
ats2_poly_exrat ats2_poly_g0float_abs_exrat (ats2_poly_exrat x);
ats2_poly_exrat ats2_poly_g0float_fabs_exrat (ats2_poly_exrat x);

ats2_poly_exrat ats2_poly_g0float_succ_exrat (ats2_poly_exrat x);
ats2_poly_exrat ats2_poly_g0float_pred_exrat (ats2_poly_exrat x);

ats2_poly_exrat ats2_poly_g0float_add_exrat (ats2_poly_exrat x,
                                             ats2_poly_exrat y);
ats2_poly_exrat ats2_poly_g0float_sub_exrat (ats2_poly_exrat x,
                                             ats2_poly_exrat y);

ats2_poly_exrat ats2_poly_g0float_min_exrat (ats2_poly_exrat x,
                                             ats2_poly_exrat y);
ats2_poly_exrat ats2_poly_g0float_max_exrat (ats2_poly_exrat x,
                                             ats2_poly_exrat y);

atstype_bool ats2_poly_g0float_eq_exrat (ats2_poly_exrat x,
                                         ats2_poly_exrat y);
atstype_bool ats2_poly_g0float_neq_exrat (ats2_poly_exrat x,
                                          ats2_poly_exrat y);
atstype_bool ats2_poly_g0float_lt_exrat (ats2_poly_exrat x,
                                         ats2_poly_exrat y);
atstype_bool ats2_poly_g0float_lte_exrat (ats2_poly_exrat x,
                                          ats2_poly_exrat y);
atstype_bool ats2_poly_g0float_gt_exrat (ats2_poly_exrat x,
                                         ats2_poly_exrat y);
atstype_bool ats2_poly_g0float_gte_exrat (ats2_poly_exrat x,
                                          ats2_poly_exrat y);

atstype_int ats2_poly_g0float_compare_exrat (ats2_poly_exrat x,
                                             ats2_poly_exrat y);

ats2_poly_exrat ats2_poly_g0float_mul_exrat (ats2_poly_exrat x,
                                             ats2_poly_exrat y);
ats2_poly_exrat ats2_poly_g0float_div_exrat (ats2_poly_exrat x,
                                             ats2_poly_exrat y);

ats2_poly_exrat ats2_poly_g0float_fma_exrat (ats2_poly_exrat x,
                                             ats2_poly_exrat y,
                                             ats2_poly_exrat z);

ats2_poly_exrat ats2_poly_g0float_round_exrat (ats2_poly_exrat x);
ats2_poly_exrat ats2_poly_g0float_nearbyint_exrat (ats2_poly_exrat x);
ats2_poly_exrat ats2_poly_g0float_floor_exrat (ats2_poly_exrat x);
ats2_poly_exrat ats2_poly_g0float_ceil_exrat (ats2_poly_exrat x);
ats2_poly_exrat ats2_poly_g0float_trunc_exrat (ats2_poly_exrat x);

ats2_poly_inline ats2_poly_exrat
ats2_poly_g0float_rint_exrat (ats2_poly_exrat x)
{
  return ats2_poly_g0float_nearbyint_exrat (x);
}

ats2_poly_exrat ats2_poly_g0float_npow_exrat (ats2_poly_exrat x,
                                              atstype_int n);

ats2_poly_exrat ats2_poly_exrat_numerator (ats2_poly_exrat x);
ats2_poly_exrat ats2_poly_exrat_denominator (ats2_poly_exrat x);

ats2_poly_inline atstype_bool
ats2_poly_exrat_is_integer (ats2_poly_exrat x)
{
  return (mpz_cmp_si (mpq_denref (x[0]), 1) == 0);
}

ats2_poly_inline atstype_bool
ats2_poly_exrat_is_even (ats2_poly_exrat x)
{
  return (mpz_cmp_si (mpq_denref (x[0]), 1) == 0
          && mpz_tstbit (mpq_numref (x[0]), 0) == 0);
}

ats2_poly_inline atstype_bool
ats2_poly_exrat_is_odd (ats2_poly_exrat x)
{
  return (mpz_cmp_si (mpq_denref (x[0]), 1) == 0
          && mpz_tstbit (mpq_numref (x[0]), 0) != 0);
}

ats2_poly_inline atstype_ulint
ats2_poly_exrat_ffs (ats2_poly_exrat x)
{
  return ((mpz_sgn (mpq_numref (x[0])) == 0) ?
          (0) :
          (mpz_scan1 (mpq_numref (x[0]), 0) + 1));
}

ats2_poly_exrat ats2_poly_exrat_mul_exp2 (ats2_poly_exrat,
                                          atstype_ulint);
ats2_poly_exrat ats2_poly_exrat_div_exp2 (ats2_poly_exrat,
                                          atstype_ulint);

#endif /* ATS2_POLY_CATS__EXRAT_CATS__HEADER_GUARD__ */

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

#ifndef ATS2_XPRELUDE_CATS__FIXED32P32_CATS__HEADER_GUARD__
#define ATS2_XPRELUDE_CATS__FIXED32P32_CATS__HEADER_GUARD__

/* (32+32)-bit fixed point. */

#ifndef ats2_xprelude_inline
#define ats2_xprelude_inline ATSinline ()
#endif

#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <`inttypes'.h>

extern int64_t ats2_xprelude_fixed32p32_multiplication (int64_t x,
                                                        int64_t y);
extern int64_t ats2_xprelude_fixed32p32_division (int64_t x, int64_t y);
extern void ats2_xprelude_integer_division (size_t n_x, uint32_t x[n_x],
                                            size_t n_y, uint32_t y[n_y],
                                            size_t n_q, uint32_t q[n_q],
                                            uint32_t *r);

typedef atstype_int64 ats2_xprelude_fixed32p32;

#define ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS 32
#define ATS2_XPRELUDE_FIXED32P32_SCALE                      \
  (INT64_C(1) << ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS)
#define ATS2_XPRELUDE_FIXED32P32_MASK                           \
  ((INT64_C(1) << ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS) - 1)
#define ATS2_XPRELUDE_FIXED32P32_ONE_HALF                       \
  (INT64_C(1) << (ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS - 1))

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_epsilon_fixed32p32 (void)
{
  return (ats2_xprelude_fixed32p32) 1;
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0int2float_int64_fixed32p32 (atstype_int64 x)
{
  return (x << ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS);
}

m4_foreachq(`INT',`intbases',
`#define ats2_xprelude_g0int2float_`'INT`'_fixed32p32(x) dnl
(ats2_xprelude_g0int2float_int64_fixed32p32 ((atstype_int64) (x)))
')dnl

ats2_xprelude_inline atstype_int64
ats2_xprelude_g0float2int_fixed32p32_int64 (ats2_xprelude_fixed32p32 x)
{
  return (x < 0) ?
    (-((-x) >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS))
    : (x >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS);
}

m4_foreachq(`INT',`intbases',
`#define ats2_xprelude_g0float2int_fixed32p32_`'INT`'(x) dnl
((intb2c(INT)) ats2_xprelude_g0float2int_fixed32p32_int64 (x))
')dnl

#define _ats2_xprelude_g0float2float_ldouble_fixed32p32(x)  \
  ((ats2_xprelude_fixed32p32)                               \
   (nearbyintl ((x) * ATS2_XPRELUDE_FIXED32P32_SCALE)))

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float2float_float_fixed32p32 (atstype_float x)
{
  return _ats2_xprelude_g0float2float_ldouble_fixed32p32 (x);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float2float_double_fixed32p32 (atstype_double x)
{
  return _ats2_xprelude_g0float2float_ldouble_fixed32p32 (x);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float2float_ldouble_fixed32p32 (atstype_ldouble x)
{
  return _ats2_xprelude_g0float2float_ldouble_fixed32p32 (x);
}

#define _ats2_xprelude_g0float2float_fixed32p32_ldouble(x)  \
  (((long double) (x)) / ATS2_XPRELUDE_FIXED32P32_SCALE)

ats2_xprelude_inline atstype_float
ats2_xprelude_g0float2float_fixed32p32_float (ats2_xprelude_fixed32p32 x)
{
  return _ats2_xprelude_g0float2float_fixed32p32_ldouble (x);
}

ats2_xprelude_inline atstype_double
ats2_xprelude_g0float2float_fixed32p32_double (ats2_xprelude_fixed32p32 x)
{
  return _ats2_xprelude_g0float2float_fixed32p32_ldouble (x);
}

ats2_xprelude_inline atstype_ldouble
ats2_xprelude_g0float2float_fixed32p32_ldouble (ats2_xprelude_fixed32p32 x)
{
  return _ats2_xprelude_g0float2float_fixed32p32_ldouble (x);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float2float_fixed32p32_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  return x;
}

ats2_xprelude_inline atstype_int
ats2_xprelude_g0float_sgn_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  return ((x < 0) ? (-1) : ((x == 0) ? (0) : (1)));
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_neg_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  return (-x);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_abs_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  return (x < 0) ? (-x) : x;
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_fabs_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  return (x < 0) ? (-x) : x;
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_succ_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  return (x + ATS2_XPRELUDE_FIXED32P32_SCALE);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_pred_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  return (x - ATS2_XPRELUDE_FIXED32P32_SCALE);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_add_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                      ats2_xprelude_fixed32p32 y)
{
  return (x + y);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_sub_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                      ats2_xprelude_fixed32p32 y)
{
  return (x - y);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_min_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                      ats2_xprelude_fixed32p32 y)
{
  return (x < y) ? x : y;
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_max_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                      ats2_xprelude_fixed32p32 y)
{
  return (x < y) ? y : x;
}

ats2_xprelude_inline atstype_bool
ats2_xprelude_g0float_eq_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                     ats2_xprelude_fixed32p32 y)
{
  return (x == y);
}

ats2_xprelude_inline atstype_bool
ats2_xprelude_g0float_neq_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                      ats2_xprelude_fixed32p32 y)
{
  return (x != y);
}

ats2_xprelude_inline atstype_bool
ats2_xprelude_g0float_lt_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                     ats2_xprelude_fixed32p32 y)
{
  return (x < y);
}

ats2_xprelude_inline atstype_bool
ats2_xprelude_g0float_lte_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                      ats2_xprelude_fixed32p32 y)
{
  return (x <= y);
}

ats2_xprelude_inline atstype_bool
ats2_xprelude_g0float_gt_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                     ats2_xprelude_fixed32p32 y)
{
  return (x > y);
}

ats2_xprelude_inline atstype_bool
ats2_xprelude_g0float_gte_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                      ats2_xprelude_fixed32p32 y)
{
  return (x >= y);
}

ats2_xprelude_inline atstype_int
ats2_xprelude_g0float_compare_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                          ats2_xprelude_fixed32p32 y)
{
  return ((x < y) ? -1 : ((x > y) ? 1 : 0));
}

#if (defined(__GNUC__) && !defined(__wasm__)    \
     && defined(__SIZEOF_INT128__))

typedef __int128_t ats2_xprelude_int128;

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_mul_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                      ats2_xprelude_fixed32p32 y)
{
  return (ats2_xprelude_fixed32p32)
    ((((ats2_xprelude_int128) x) * y)
     >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_div_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                      ats2_xprelude_fixed32p32 y)
{
  return (ats2_xprelude_fixed32p32)
    ((((ats2_xprelude_int128) x)
      << ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS) / y);
}

#else

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_mul_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                      ats2_xprelude_fixed32p32 y)
{
  return ats2_xprelude_fixed32p32_multiplication (x, y);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_div_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                      ats2_xprelude_fixed32p32 y)
{
  return ats2_xprelude_fixed32p32_division (x, y);
}

#endif

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_fma_fixed32p32 (ats2_xprelude_fixed32p32 x,
                                      ats2_xprelude_fixed32p32 y,
                                      ats2_xprelude_fixed32p32 z)
{
  return (ats2_xprelude_g0float_add_fixed32p32
          (ats2_xprelude_g0float_mul_fixed32p32 (x, y), z));
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_round_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  return (((x < 0) ?
           (-(((-x) + ATS2_XPRELUDE_FIXED32P32_ONE_HALF)
              >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS))
           : (((x + ATS2_XPRELUDE_FIXED32P32_ONE_HALF)
               >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS)))
          << ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_nearbyint_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  ats2_xprelude_fixed32p32 y = (x < 0) ? -x : x;
  int64_t fraction = (y & ATS2_XPRELUDE_FIXED32P32_MASK);
  if (fraction < ATS2_XPRELUDE_FIXED32P32_ONE_HALF)
    y = y >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS;
  else if (fraction > ATS2_XPRELUDE_FIXED32P32_ONE_HALF)
    y = (y >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS) + 1;
  else if (((y >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS) & 1) == 0)
    y = y >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS;
  else
    y = (y >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS) + 1;
  return ((x < 0) ? -y : y) << ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS;
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_rint_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  return ats2_xprelude_g0float_nearbyint_fixed32p32 (x);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_floor_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  return (((0 <= x) ?
           (x >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS)
           : ((((-x) & ATS2_XPRELUDE_FIXED32P32_MASK) == 0) ?
              (-((-x) >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS))
              : (-1 - ((-x) >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS))))
          << ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_ceil_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  return (((x < 0) ?
           (-((-x) >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS))
           : (((x & ATS2_XPRELUDE_FIXED32P32_MASK) == 0) ?
              (x >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS)
              : (1 + (x >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS))))
          << ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS);
}

ats2_xprelude_inline ats2_xprelude_fixed32p32
ats2_xprelude_g0float_trunc_fixed32p32 (ats2_xprelude_fixed32p32 x)
{
  return (((x < 0) ?
           (-((-x) >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS))
           : (x >> ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS))
          << ATS2_XPRELUDE_FIXED32P32_FRACTION_BITS);
}

atstype_string ats2_xprelude_tostrptr_fixed32p32_given_decimal_places (ats2_xprelude_fixed32p32 x,
                                                                       int decimal_places);

ats2_xprelude_inline atstype_string
ats2_xprelude_tostring_fixed32p32_given_decimal_places (ats2_xprelude_fixed32p32 x,
                                                        int decimal_places)
{
  return ats2_xprelude_tostrptr_fixed32p32_given_decimal_places (x, decimal_places);
}

#endif /* ATS2_XPRELUDE_CATS__FIXED32P32_CATS__HEADER_GUARD__ */
dnl
dnl local variables:
dnl mode: C
dnl end:

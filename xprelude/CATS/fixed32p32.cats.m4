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

#ifndef MY_EXTERN_PREFIX`'CATS__FIXED32P32_CATS__HEADER_GUARD__
#define MY_EXTERN_PREFIX`'CATS__FIXED32P32_CATS__HEADER_GUARD__

/* (32+32)-bit fixed point. */

#include <xprelude/CATS/attributes.cats>
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <`inttypes'.h>

#ifndef my_extern_prefix`'boolc2ats
#define my_extern_prefix`'boolc2ats(B) \
  ((B) ? (atsbool_true) : (atsbool_false))
#endif

my_extern_prefix`'pure_extern int64_t
my_extern_prefix`'fixed32p32_multiplication (int64_t x, int64_t y);

my_extern_prefix`'pure_extern int64_t
my_extern_prefix`'fixed32p32_division (int64_t x, int64_t y);

extern void my_extern_prefix`'integer_division (size_t n_x, uint32_t x[n_x],
                                                size_t n_y, uint32_t y[n_y],
                                                size_t n_q, uint32_t q[n_q],
                                                uint32_t *r);

typedef atstype_int64 floatt2c(fixed32p32);

#define MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS 32
#define MY_EXTERN_PREFIX`'FIXED32P32_SCALE                      \
  (INT64_C(1) << MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS)
#define MY_EXTERN_PREFIX`'FIXED32P32_MASK                           \
  ((INT64_C(1) << MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS) - 1)
#define MY_EXTERN_PREFIX`'FIXED32P32_ONE                        \
  (INT64_C(1) << MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS)
#define MY_EXTERN_PREFIX`'FIXED32P32_ONE_HALF                       \
  (INT64_C(1) << (MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS - 1))

my_extern_prefix`'const_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_epsilon_fixed32p32 (void)
{
  return (floatt2c(fixed32p32)) 1;
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0int2float_int64_fixed32p32 (atstype_int64 x)
{
  return (x << MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS);
}

m4_foreachq(`INT',`intbases',
            `#define my_extern_prefix`'g0int2float_`'INT`'_fixed32p32(x) dnl
            (my_extern_prefix`'g0int2float_int64_fixed32p32 ((atstype_int64) (x)))
            ')dnl

my_extern_prefix`'pure_inline atstype_int64
my_extern_prefix`'g0float2int_fixed32p32_int64 (floatt2c(fixed32p32) x)
{
  return (x < 0) ?
    (-((-x) >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS))
    : (x >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS);
}

m4_foreachq(`INT',`intbases',
            `#define my_extern_prefix`'g0float2int_fixed32p32_`'INT`'(x) dnl
            ((intb2c(INT)) my_extern_prefix`'g0float2int_fixed32p32_int64 (x))
            ')dnl

#define _my_extern_prefix`'g0float2float_ldouble_fixed32p32(x)  \
  ((floatt2c(fixed32p32))                                       \
   (nearbyintl ((x) * MY_EXTERN_PREFIX`'FIXED32P32_SCALE)))

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float2float_float_fixed32p32 (atstype_float x)
{
  return _my_extern_prefix`'g0float2float_ldouble_fixed32p32 (x);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float2float_double_fixed32p32 (atstype_double x)
{
  return _my_extern_prefix`'g0float2float_ldouble_fixed32p32 (x);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float2float_ldouble_fixed32p32 (atstype_ldouble x)
{
  return _my_extern_prefix`'g0float2float_ldouble_fixed32p32 (x);
}

#define _my_extern_prefix`'g0float2float_fixed32p32_ldouble(x)  \
  (((long double) (x)) / MY_EXTERN_PREFIX`'FIXED32P32_SCALE)

my_extern_prefix`'pure_inline atstype_float
my_extern_prefix`'g0float2float_fixed32p32_float (floatt2c(fixed32p32) x)
{
  return _my_extern_prefix`'g0float2float_fixed32p32_ldouble (x);
}

my_extern_prefix`'pure_inline atstype_double
my_extern_prefix`'g0float2float_fixed32p32_double (floatt2c(fixed32p32) x)
{
  return _my_extern_prefix`'g0float2float_fixed32p32_ldouble (x);
}

my_extern_prefix`'pure_inline atstype_ldouble
my_extern_prefix`'g0float2float_fixed32p32_ldouble (floatt2c(fixed32p32) x)
{
  return _my_extern_prefix`'g0float2float_fixed32p32_ldouble (x);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float2float_fixed32p32_fixed32p32 (floatt2c(fixed32p32) x)
{
  return x;
}

my_extern_prefix`'pure_inline atstype_int
my_extern_prefix`'g0float_sgn_fixed32p32 (floatt2c(fixed32p32) x)
{
  return ((x < 0) ? (-1) : ((x == 0) ? (0) : (1)));
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_neg_fixed32p32 (floatt2c(fixed32p32) x)
{
  return (-x);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_abs_fixed32p32 (floatt2c(fixed32p32) x)
{
  return (x < 0) ? (-x) : x;
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_fabs_fixed32p32 (floatt2c(fixed32p32) x)
{
  return (x < 0) ? (-x) : x;
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_succ_fixed32p32 (floatt2c(fixed32p32) x)
{
  return (x + MY_EXTERN_PREFIX`'FIXED32P32_SCALE);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_pred_fixed32p32 (floatt2c(fixed32p32) x)
{
  return (x - MY_EXTERN_PREFIX`'FIXED32P32_SCALE);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_add_fixed32p32 (floatt2c(fixed32p32) x,
                                          floatt2c(fixed32p32) y)
{
  return (x + y);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_sub_fixed32p32 (floatt2c(fixed32p32) x,
                                          floatt2c(fixed32p32) y)
{
  return (x - y);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_min_fixed32p32 (floatt2c(fixed32p32) x,
                                          floatt2c(fixed32p32) y)
{
  return (x < y) ? x : y;
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_max_fixed32p32 (floatt2c(fixed32p32) x,
                                          floatt2c(fixed32p32) y)
{
  return (x < y) ? y : x;
}

my_extern_prefix`'pure_inline atstype_bool
my_extern_prefix`'g0float_eq_fixed32p32 (floatt2c(fixed32p32) x,
                                         floatt2c(fixed32p32) y)
{
  return my_extern_prefix`'boolc2ats (x == y);
}

my_extern_prefix`'pure_inline atstype_bool
my_extern_prefix`'g0float_neq_fixed32p32 (floatt2c(fixed32p32) x,
                                          floatt2c(fixed32p32) y)
{
  return my_extern_prefix`'boolc2ats (x != y);
}

my_extern_prefix`'pure_inline atstype_bool
my_extern_prefix`'g0float_lt_fixed32p32 (floatt2c(fixed32p32) x,
                                         floatt2c(fixed32p32) y)
{
  return my_extern_prefix`'boolc2ats (x < y);
}

my_extern_prefix`'pure_inline atstype_bool
my_extern_prefix`'g0float_lte_fixed32p32 (floatt2c(fixed32p32) x,
                                          floatt2c(fixed32p32) y)
{
  return my_extern_prefix`'boolc2ats (x <= y);
}

my_extern_prefix`'pure_inline atstype_bool
my_extern_prefix`'g0float_gt_fixed32p32 (floatt2c(fixed32p32) x,
                                         floatt2c(fixed32p32) y)
{
  return my_extern_prefix`'boolc2ats (x > y);
}

my_extern_prefix`'pure_inline atstype_bool
my_extern_prefix`'g0float_gte_fixed32p32 (floatt2c(fixed32p32) x,
                                          floatt2c(fixed32p32) y)
{
  return my_extern_prefix`'boolc2ats (x >= y);
}

my_extern_prefix`'pure_inline atstype_int
my_extern_prefix`'g0float_compare_fixed32p32 (floatt2c(fixed32p32) x,
                                              floatt2c(fixed32p32) y)
{
  return ((x < y) ? -1 : ((x > y) ? 1 : 0));
}

#if (defined(__GNUC__) && !defined(__wasm__)    \
     && defined(__SIZEOF_INT128__))

typedef __int128_t my_extern_prefix`'int128;

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_mul_fixed32p32 (floatt2c(fixed32p32) x,
                                          floatt2c(fixed32p32) y)
{
  return (floatt2c(fixed32p32))
    ((((my_extern_prefix`'int128) x) * y)
     >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_div_fixed32p32 (floatt2c(fixed32p32) x,
                                          floatt2c(fixed32p32) y)
{
  return (floatt2c(fixed32p32))
    ((((my_extern_prefix`'int128) x)
      << MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS) / y);
}

#else

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_mul_fixed32p32 (floatt2c(fixed32p32) x,
                                          floatt2c(fixed32p32) y)
{
  return my_extern_prefix`'fixed32p32_multiplication (x, y);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_div_fixed32p32 (floatt2c(fixed32p32) x,
                                          floatt2c(fixed32p32) y)
{
  return my_extern_prefix`'fixed32p32_division (x, y);
}

#endif

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_reciprocal_fixed32p32 (floatt2c(fixed32p32) x)
{
  return my_extern_prefix`'g0float_div_fixed32p32 (MY_EXTERN_PREFIX`'FIXED32P32_ONE, x);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_fma_fixed32p32 (floatt2c(fixed32p32) x,
                                          floatt2c(fixed32p32) y,
                                          floatt2c(fixed32p32) z)
{
  return (my_extern_prefix`'g0float_add_fixed32p32
          (my_extern_prefix`'g0float_mul_fixed32p32 (x, y), z));
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_round_fixed32p32 (floatt2c(fixed32p32) x)
{
  return (((x < 0) ?
           (-(((-x) + MY_EXTERN_PREFIX`'FIXED32P32_ONE_HALF)
              >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS))
           : (((x + MY_EXTERN_PREFIX`'FIXED32P32_ONE_HALF)
               >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS)))
          << MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_nearbyint_fixed32p32 (floatt2c(fixed32p32) x)
{
  floatt2c(fixed32p32) y = (x < 0) ? -x : x;
  int64_t fraction = (y & MY_EXTERN_PREFIX`'FIXED32P32_MASK);
  if (fraction < MY_EXTERN_PREFIX`'FIXED32P32_ONE_HALF)
    y = y >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS;
  else if (fraction > MY_EXTERN_PREFIX`'FIXED32P32_ONE_HALF)
    y = (y >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS) + 1;
  else if (((y >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS) & 1) == 0)
    y = y >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS;
  else
    y = (y >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS) + 1;
  return ((x < 0) ? -y : y) << MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS;
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_rint_fixed32p32 (floatt2c(fixed32p32) x)
{
  return my_extern_prefix`'g0float_nearbyint_fixed32p32 (x);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_floor_fixed32p32 (floatt2c(fixed32p32) x)
{
  return (((0 <= x) ?
           (x >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS)
           : ((((-x) & MY_EXTERN_PREFIX`'FIXED32P32_MASK) == 0) ?
              (-((-x) >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS))
              : (-1 - ((-x) >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS))))
          << MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_ceil_fixed32p32 (floatt2c(fixed32p32) x)
{
  return (((x < 0) ?
           (-((-x) >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS))
           : (((x & MY_EXTERN_PREFIX`'FIXED32P32_MASK) == 0) ?
              (x >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS)
              : (1 + (x >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS))))
          << MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS);
}

my_extern_prefix`'pure_inline floatt2c(fixed32p32)
my_extern_prefix`'g0float_trunc_fixed32p32 (floatt2c(fixed32p32) x)
{
  return (((x < 0) ?
           (-((-x) >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS))
           : (x >> MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS))
          << MY_EXTERN_PREFIX`'FIXED32P32_FRACTION_BITS);
}

my_extern_prefix`'extern atstype_string
my_extern_prefix`'tostrptr_fixed32p32_given_decimal_places (floatt2c(fixed32p32) x,
                                                            int decimal_places);

my_extern_prefix`'inline atstype_string
my_extern_prefix`'tostring_fixed32p32_given_decimal_places (floatt2c(fixed32p32) x,
                                                            int decimal_places)
{
  return my_extern_prefix`'tostrptr_fixed32p32_given_decimal_places (x, decimal_places);
}

#endif `/*' MY_EXTERN_PREFIX`'CATS__FIXED32P32_CATS__HEADER_GUARD__ */
dnl
dnl local variables:
dnl mode: C
dnl end:
dnl

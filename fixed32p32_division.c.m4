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
/*------------------------------------------------------------------*/

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>
#include <assert.h>

static void
_`'my_extern_prefix`'short_division (size_t n_u, uint32_t u[n_u],
                                     uint32_t v,
                                     uint32_t *q, uint32_t *r)
{
  uint32_t remainder = 0;

  for (size_t j1 = n_u; j1 != 0; j1 -= 1)
    {
      size_t j = j1 - 1;

      uint64_t tmp = (((uint64_t) remainder) << 32) | u[j];
      q[j] = tmp / v;
      remainder = tmp % v;
    }

  if (r != NULL)
    r[0] = remainder;
}

static void
_`'my_extern_prefix`'long_division (uint32_t *x, uint32_t *y, 
                                    uint32_t *q, uint32_t *r,
                                    size_t m, size_t n)
{
  /* The following implementation is based on Knuth’s Algorithm 4.3.1D
     from Volume 2. */

  uint32_t u[m + n + 1];
  uint32_t v[n];

  _Static_assert ((CHAR_BIT * sizeof (unsigned long)) >= 32,
                  "uint32_t is longer than an unsigned long,"
                  " which seems strange");
#if defined __GNUC__
  const int num_lz =
    __builtin_clzl (y[n - 1]) -
    ((CHAR_BIT * sizeof (unsigned long)) - 32);
  const int num_nonlz = 32 - num_lz;
#else
  /* Convert the leading zeros problem to a trailing ones problem, and
     then count trailing ones by de Bruijn sequence. See:

     {{cite web
      | title       = Bit Twiddling Hacks
      | url         = https://graphics.stanford.edu/~seander/bithacks.html
      | date        = 2023-01-14
      | archiveurl  = http://archive.today/GNADt
      | archivedate = 2023-01-14 }}

     where essentially the same method is used to count trailing
     zeros. */

  uint32_t tmp = y[n - 1];

  /* Fill in low bits with ones. */
  tmp |= tmp >> 1; 
  tmp |= tmp >> 2;
  tmp |= tmp >> 4;
  tmp |= tmp >> 8;
  tmp |= tmp >> 16;

  const int num_nonlz =
    "\0\1\34\2\35\16\30\3\36\26\24\17\31\21\4\10\37\33\15\27\25\23\20\7\32\14\22\6\13\5\12\11"
    [((~tmp & (tmp + 1)) * UINT32_C(0x077CB531)) >> 27];
  const int num_lz = 32 - num_nonlz;
#endif

  /* Make v be y normalized so its most significant bit is a one. Any
     normalization factor that achieves this goal will suffice; we
     choose 2**num_lz. ((2**32) div (y[n-1] + 1) also will work, and
     is the factor Knuth employs.) */
  v[0] = (y[0] << num_lz);
  for (size_t i = 1; i != n; i += 1)
    v[i] = (y[i] << num_lz) | (y[i - 1] >> num_nonlz);

  /* Check that the most significant bit is a one. */
  assert ((v[n - 1] >> 31) == 1);

  /* Make u be x, normalized (same as v) by multiplying x by
     2**num_lz. The quotient of u and v will be the same as the
     quotient of x and y, and the remainder will be enlarged by a
     factor of 2**num_lz. */
  u[0] = (x[0] << num_lz);
  for (size_t i = 1; i != m + n; i += 1)
    u[i] = (x[i] << num_lz) | (x[i - 1] >> num_nonlz);
  u[m + n] = (x[m + n - 1] >> num_nonlz);

  for (size_t j1 = m + 1; j1 != 0; j1 -= 1)
    {
      size_t j = j1 - 1;

      /* Calculate qhat. */
      uint64_t qhat;
      {
        uint64_t tmp = (((uint64_t) u[j + n]) << 32) | u[j + n - 1];
        qhat = tmp / v[n - 1];
        uint64_t rhat = tmp % v[n - 1];
        bool adjust;
        do
          {
            adjust =
              ((qhat >> 32) != 0)
              || ((qhat * v[n - 2]) > ((rhat << 32) | u[j + n - 2]));
            if (adjust)
              {
                qhat -= 1;
                rhat += v[n - 1];
                adjust = ((rhat >> 32) != 0);
              }
          }
        while (adjust);
      }

      /* Multiply and subtract. */
      uint64_t carry = 0;
      {
        uint32_t mul_carry = 0;
        for (size_t i = 0; i != n + 1; i += 1)
          {
            /* Multiplication. */
            uint64_t qhat_v_64 =
              (i != n) ? ((qhat * v[i]) + mul_carry) : mul_carry;
            mul_carry = (qhat_v_64 >> 32);
            uint32_t qhat_v = (uint32_t) qhat_v_64;

            /* Subtraction. If the difference is negative, the
               unsigned integers will simply wrap around. We use a
               carry to the subtrahend rather than a borrow from the
               minuend. (Carrying to the subtrahend is, by the way, a
               much faster and easier way to do subtraction by hand,
               than is borrowing from the minuend.) */
            uint64_t subtrahend = qhat_v + carry;
            carry = (u[j + i] < subtrahend);
            u[j + i] -= subtrahend;
          }
      }

      q[j] = (uint32_t) qhat;
      if (carry)
        {
          /* Add back. */
          q[j] -= 1;
          carry = 0;
          for (size_t i = 0; i != n; i += 1)
            {
              uint64_t sum = ((uint64_t) u[j + i] + v[i]) + carry;
              carry = (sum >> 32);
              u[j + i] = (uint32_t) sum;
            }
        }
    }

  /* Unnormalize the remainder. */
  if (r != NULL)
    {
      for (size_t i = 0; i != n - 1; i += 1)
        r[i] = (u[i] >> num_lz) | (u[i + 1] << num_nonlz);
      r[n - 1] = (u[n - 1] >> num_lz);
    }
}

void
my_extern_prefix`'integer_division (size_t n_x, uint32_t x[n_x],
                                    size_t n_y, uint32_t y[n_y],
                                    size_t n_q, uint32_t q[n_q],
                                    uint32_t *r)
{
  memset (q, 0, n_q * sizeof (uint32_t));
  if (r != NULL)
    memset (r, 0, n_y * sizeof (uint32_t));

  size_t n = n_y;
  while (y[n - 1] == 0)
    n -= 1;
  size_t m = n_x - n;

  if (n == 1)
    _`'my_extern_prefix`'short_division (n_x, x, y[0], q, r);
  else
    _`'my_extern_prefix`'long_division (x, y, q, r, m, n);
}

int64_t
my_extern_prefix`'fixed32p32_division (int64_t x, int64_t y)
{
  int is_negative = (x < 0) ^ (y < 0);
  uint64_t xmagn = (x < 0) ? -x : x;
  uint64_t ymagn = (y < 0) ? -y : y;

  uint32_t u[3];                /* xmagn times 2**32 */
  uint32_t v[2];                /* ymagn */
  uint32_t q[2];                /* quotient */
  u[0] = 0;
  u[1] = (uint32_t) xmagn;
  u[2] = (uint32_t) (xmagn >> 32);
  v[0] = (uint32_t) ymagn;
  v[1] = (uint32_t) (ymagn >> 32);
  my_extern_prefix`'integer_division (3, u, 2, v, 2, q, NULL);
  uint64_t quotient = ((uint64_t) q[0]) | (((uint64_t) q[1]) << 32);

  return (is_negative) ? -((int64_t) quotient) : ((int64_t) quotient);
}

/*------------------------------------------------------------------*/
dnl
dnl local variables:
dnl mode: C
dnl end:

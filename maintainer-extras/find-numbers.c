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

/* A program for finding numbers that require the ‘add back’ step in
   long division. */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>
#include <assert.h>

unsigned long int add_back_count = 0;

void
long_division (uint32_t *x, uint32_t *y, 
               uint32_t *q, uint32_t *r,
               size_t m, size_t n)
{
  /* The following implementation is based on Knuth’s Algorithm 4.3.1D
     from Volume 2. */

  uint32_t u[m + n + 1];
  uint32_t v[n];

  const int num_lz =
    __builtin_clzl (y[n - 1]) -
    ((CHAR_BIT * sizeof (unsigned long)) - 32);
  const int num_nonlz = 32 - num_lz;

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

          add_back_count += 1;
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

int
main (void)
{
  srand48 (0);

  uint32_t u[4];
  uint32_t v[4];
  uint32_t q[4];
  uint32_t r[4];

  add_back_count = 0;
  while (add_back_count != 5)
    {
      for (int i = 0; i != 4; i += 1)
        {
          u[i] = 0;
          v[i] = 0;
          q[i] = 0;
          r[i] = 0;
        }

      for (int i = 0; i != 3; i += 1)
        u[i] = (uint32_t) lrand48 ();
      for (int i = 0; i != 2; i += 1)
        v[i] = (uint32_t) lrand48 ();
      if (v[1] == 0)
        v[1] = 1;            /* Ensure a big enough divisor. */

      unsigned long int old_count = add_back_count;
      long_division (u, v, q, r, 1, 2);

      if (add_back_count != old_count)
        {
          printf ("\n");
          for (int i = 3; i != -1; i -= 1)
            printf ("%.8jX ", (uintmax_t) u[i]);
          printf ("\n");
          for (int i = 3; i != -1; i -= 1)
            printf ("%.8jX ", (uintmax_t) v[i]);
          printf ("\n");
          for (int i = 3; i != -1; i -= 1)
            printf ("%.8jX ", (uintmax_t) q[i]);
          printf ("\n");
          for (int i = 3; i != -1; i -= 1)
            printf ("%.8jX ", (uintmax_t) r[i]);
          printf ("\n");
        }
    }

  return 0;
}

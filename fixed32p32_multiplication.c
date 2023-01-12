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

#include <stdint.h>

#define MASK ((UINT64_C(1) << 32) - 1)

int64_t
ats2_poly_fixed32p32_multiplication (int64_t x, int64_t y)
{
  typedef uint64_t t;

  int is_negative = (x < 0) ^ (y < 0);
  t xmagn = (x < 0) ? -x : x;
  t ymagn = (y < 0) ? -y : y;

  t x0 = xmagn & MASK;
  t x1 = xmagn >> 32;
  t y0 = ymagn & MASK;
  t y1 = ymagn >> 32;

  t x0_y0 = x0 * y0;
  t x0_y1 = x0 * y1;
  t x1_y0 = x1 * y0;
  t x1_y1 = x1 * y1;

  /* We will discard the lower 32 bits of x0_y0. */
  t z0 = (x0_y0 >> 32) + (x0_y1 & MASK) + (x1_y0 & MASK);
  t z1 = (z0 >> 32) + (x0_y1 >> 32) + (x1_y0 >> 32) + x1_y1;

  /* There may be some overflow when z1 is shifted. Currently we
     ignore it. */
  t product = (z1 << 32) + (z0 & MASK);

  return (is_negative) ? -product : product;
}

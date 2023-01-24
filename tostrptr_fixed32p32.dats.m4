(*
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
*)
include(`common-macros.m4')m4_include(`ats2-xprelude-macros.m4')
(*------------------------------------------------------------------*)

#define ATS_DYNLOADFLAG 0

#define ATS_PACKNAME "ats2-xprelude.tostrptr_fixed32p32"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload "xprelude/SATS/fixed32p32.sats"

%{

#include <stdio.h>
#include <stdint.h>
#include <`inttypes.h'>
#include <limits.h>
#include <stdbool.h>
#include <assert.h>

#define DECIMAL_PLACES_THRESHOLD 100

static void
_round_towards_infinity (char *buf, int decimal_places)
{
  size_t i = 9 + decimal_places;
  bool done = false;
  while (!done)
    {
      if (buf[i] == ' ')
        {
          buf[i] = '1';
          done = true;
        }
      else if (buf[i] < '9')
        {
          buf[i] += 1;
          done = true;
        }
      else
        {
          assert (i != 0);
          buf[i] = '0';
          i -= 1;
        }
    }
}

static void
_fill_decimal_digits (char *buf, uint64_t x0, uint64_t x1,
                      int decimal_places)
{
  assert (0 <= decimal_places);

  snprintf (buf, 11, "%10" PRId64, x1);
  for (size_t i = 10; i != 10 + decimal_places; i += 1)
    {
      x0 *= 10;
      buf[i] = (x0 >> 32) + '0';
      x0 &= ((UINT64_C(1) << 32) - 1);
    }
  buf[10 + decimal_places] = '\0';
  if ((UINT64_C(1) << 31) < x0
        || (x0 == (UINT64_C(1) << 31)
              && (((buf[9 + decimal_places] - '0') & 1) != 0)))
    _round_towards_infinity (buf, decimal_places);
}

atstype_string
my_extern_prefix`'tostrptr_fixed32p32_given_decimal_places (my_extern_prefix`'fixed32p32 x,
                                                    int decimal_places)
{
  int64_t x_as_int64 = (int64_t) x;
  bool negative = (x_as_int64 < 0);
  uint64_t x_as_uint64 = (negative) ? -x : x;
  uint64_t x1 = (x_as_uint64 >> 32);
  uint64_t x0 = (x_as_uint64 & ((UINT64_C(1) << 32) - 1));

  char stack_buf[10 + DECIMAL_PLACES_THRESHOLD];
  char *buf;
  if (decimal_places < DECIMAL_PLACES_THRESHOLD)
    buf = stack_buf;
  else
    buf = ATS_MALLOC (sizeof (char) * (11 + decimal_places));

  _fill_decimal_digits (buf, x0, x1, decimal_places);

  const char *p = buf;
  while ( *p == ' ' )
    p += 1;

  size_t leading_spaces = p - buf;
  size_t total_digits = 10 + decimal_places - leading_spaces;
  size_t decimal_point = (decimal_places != 0);
  size_t total_chars = negative + total_digits + decimal_point;

  char *retval = ATS_MALLOC (sizeof (char) * (total_chars + 1));
  char *q = retval;
  if (negative)
    {
      *q = '-';
      q += 1;
    }
  for (size_t i = 0; i != 10 - leading_spaces; i += 1)
    {
      *q = *p;
      q += 1;
      p += 1;
    }
  if (0 < decimal_places)
    {
      *q = '.';
      q += 1;
    }
  for (size_t i = 0; i != decimal_places; i += 1)
    {
      *q = *p;
      q += 1;
      p += 1;
    }
  *q = '\0';

  if (decimal_places >= DECIMAL_PLACES_THRESHOLD)
    ATS_MFREE (buf);

  return retval;
}

%}

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

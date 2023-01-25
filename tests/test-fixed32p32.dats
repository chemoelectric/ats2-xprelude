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

#define ATS_EXTERN_PREFIX "ats2_xprelude_"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"
#include "xprelude/HATS/symbols.hats"

staload UN = "prelude/SATS/unsafe.sats"

staload "xprelude/SATS/fixed32p32.sats"
staload _ = "xprelude/DATS/fixed32p32.dats"

%{^

static atstype_bool
ats2_xprelude_test_integer_division_add_back (void)
{
  /* Test the ‘Add back’ branch of long division. The test case was
     found by random search, and expected results were computed with
     CHICKEN Scheme 5. */

  atstype_bool success = atsbool_true;

  uint32_t u[4];
  uint32_t v[3];

  /* u = 1054e9c3 5f1efdbd 2dcc3129 650c41e8 */
  u[3] = 0x1054e9c3LU;
  u[2] = 0x5f1efdbdLU;
  u[1] = 0x2dcc3129LU;
  u[0] = 0x650c41e8LU;

  /* v = 1092d73e 5eb87854 36831474 */
  v[2] = 0x1092d73eLU;
  v[1] = 0x5eb87854LU;
  v[0] = 0x36831474LU;

  /* Expected quotient = 00000000 fc437319 */
  uint32_t q_expected[2];
  q_expected[1] = 0;
  q_expected[0] = 0xfc437319LU;

  /* Expected remainder = 0f86935e ac075002 a5b32694 */
  uint32_t r_expected[3];
  r_expected[2] = 0x0f86935eLU;
  r_expected[1] = 0xac075002LU;
  r_expected[0] = 0xa5b32694LU;

  uint32_t q[2];
  uint32_t r[3];
  ats2_xprelude_integer_division (4, u, 3, v, 2, q, r);
  for (int i = 1; i != -1; i -= 1)
    {
      //printf("%08lx\n", (unsigned long) q[i]);
      if (q[i] != q_expected[i])
        success = atsbool_false;
    }
  for (int i = 2; i != -1; i -= 1)
    {
      //printf("%08lx\n", (unsigned long) r[i]);
      if (r[i] != r_expected[i])
        success = atsbool_false;
    }

  return success;
}

%}

(* Test our code for multiplication, even on systems where we do not
   use it. *)
extern fn
fixed32p32_multiplication :
  (fixed32p32, fixed32p32) -<> fixed32p32 = "mac#%"
macdef mul = fixed32p32_multiplication

(* Test our code for division, even on systems where we do not use
   it. *)
extern fn
fixed32p32_division :
  (fixed32p32, fixed32p32) -<> fixed32p32 = "mac#%"
macdef div = fixed32p32_division

(* Test an uncommonly executed branch of the long division routine. *)
extern fn
test_integer_division_add_back :
  () -> bool = "mac#%"

macdef i2fx = g0int2float<intknd,fix32p32knd>
macdef d2fx = g0float2float<dblknd,fix32p32knd>

fn test0 () : void =
  let
    val x : fixed32p32 = g0i2f ~5
    val y : fixed32p32 = g0i2f 30LL

    val- true = ~x = g0i2f 5L
    val- true = ~y = g0i2f ~30LL

    val- true = abs x = g0i2f 5L
    val- true = abs y = g0i2f 30LL

    val- true = (x + y) = g0i2f 25L
    val- true = (y + x) = g0i2f 25

    val- true = (x - y) = g0i2f ~35
    val- true = (y - x) = g0i2f 35

    val- false = x = y
    val- false = y = x
    val- true  = x = x

    val- true  = x <> y
    val- true  = y <> x
    val- false = x <> x

    val- true  = x < y
    val- false = y < x
    val- false = x < x

    val- true  = x <= y
    val- false = y <= x
    val- true  = x <= x

    val- false = x > y
    val- true  = y > x
    val- false = x > x

    val- false = x >= y
    val- true  = y >= x
    val- true  = x >= x

    val- true = (x \compare y) < 0
    val- true = (y \compare x) > 0
    val- true = (x \compare x) = 0

    val- true  = x * y = g0i2f ~150
    val- true  = y * x = g0i2f ~150
    val- true  = x * x = g0i2f 25
    val- true  = y * y = g0i2f 900
    val- true  = (((g0f2f 2.5) : fixed32p32) * (g0f2f 7.5)) = g0f2f 18.75
    val- true  = (((g0f2f ~2.5) : fixed32p32) * (g0f2f 7.5)) = g0f2f ~18.75
    val- true  = (((g0f2f 2.5) : fixed32p32) * (g0f2f ~7.5)) = g0f2f ~18.75
    val- true  = (((g0f2f ~2.5) : fixed32p32) * (g0f2f ~7.5)) = g0f2f 18.75

    val- true  = (x \mul y) = g0i2f ~150
    val- true  = (y \mul x) = g0i2f ~150
    val- true  = (x \mul x) = g0i2f 25
    val- true  = (y \mul y) = g0i2f 900
    val- true  = (((g0f2f 2.5) : fixed32p32) \mul (g0f2f 7.5)) = g0f2f 18.75
    val- true  = (((g0f2f ~2.5) : fixed32p32) \mul (g0f2f 7.5)) = g0f2f ~18.75
    val- true  = (((g0f2f 2.5) : fixed32p32) \mul (g0f2f ~7.5)) = g0f2f ~18.75
    val- true  = (((g0f2f ~2.5) : fixed32p32) \mul (g0f2f ~7.5)) = g0f2f 18.75

    val- true = x / y < g0i2f 0
    val- true = abs ((x / y) * g0i2f 100000) - g0i2f 16666 < g0i2f 1
    val- true = y / x = g0i2f ~6
    val- true = x / x = g0i2f 1
    val- true = y / y = g0i2f 1

    val- true = (x \div y) < g0i2f 0
    val- true = abs ((x \div y) * g0i2f 100000) - g0i2f 16666 < g0i2f 1
    val- true = (y \div x) = g0i2f ~6
    val- true = (x \div x) = g0i2f 1
    val- true = (y \div y) = g0i2f 1

    val- true = ((g0f2f 3.5F) : fixed32p32) = ((g0i2f 7) : fixed32p32) / g0i2f 2
    val- true = ((g0f2f 3.5) : fixed32p32) = ((g0i2f 7) : fixed32p32) / g0i2f 2
    val- true = ((g0f2f 3.5L) : fixed32p32) = ((g0i2f 7) : fixed32p32) / g0i2f 2

    val- true = ((g0f2f 3.5F) : fixed32p32) = (((g0i2f 7) : fixed32p32) \div g0i2f 2)
    val- true = ((g0f2f 3.5) : fixed32p32) = (((g0i2f 7) : fixed32p32) \div g0i2f 2)
    val- true = ((g0f2f 3.5L) : fixed32p32) = (((g0i2f 7) : fixed32p32) \div g0i2f 2)

    val- 3.5F = g0f2f (((g0i2f 7) : fixed32p32) / g0i2f 2)
    val- 3.5  = g0f2f (((g0i2f 7) : fixed32p32) / g0i2f 2)
    val- 3.5L = g0f2f (((g0i2f 7) : fixed32p32) / g0i2f 2)

    val- 3.5F = g0f2f (((g0i2f 7) : fixed32p32) \div (g0i2f 2))
    val- 3.5  = g0f2f (((g0i2f 7) : fixed32p32) \div (g0i2f 2))
    val- 3.5L = g0f2f (((g0i2f 7) : fixed32p32) \div (g0i2f 2))

    (* The following tests that fractions are handled
       correctly. Initially I had had a bug in the code that would
       have caused this test to fail. *)
    val- true = abs ((((g0f2f 7.25) : fixed32p32) \div (g0f2f 1.2345)) - g0f2f 5.8728) < g0f2f 0.001
    (* Here is the same test but using / instead of \div. *)
    val- true = abs ((((g0f2f 7.25) : fixed32p32) / (g0f2f 1.2345)) - g0f2f 5.8728) < g0f2f 0.001

    val- true = test_integer_division_add_back ()

    (* Test that epsilon is 1/(1<<32) *)
    val- true = epsilon<fix32p32knd> () * g0i2f (1 << 16) * g0i2f (1 << 16) = g0i2f 1

    val- true = (isltz x) * ~(isltz y)
    val- true = (isltez x) * ~(isltez y)
    val- true = ~(isgtz x) * (isgtz y)
    val- true = ~(isgtez x) * (isgtez y)
    val- true = ~(iseqz x) * ~(iseqz y)
    val- true = (isneqz x) * (isneqz y)
    val- true = (iseqz (x - x)) * ~(isneqz (x - x))
    val- true = (isltez (x - x)) * (isgtez (x - x))

    val- true = succ x = g0i2f ~4
    val- true = succ y = g0i2f 31
    val- true = pred x = g0i2f ~6
    val- true = pred y = g0i2f 29

    val- true = max (x, y) = y
    val- true = min (x, y) = x

    val- true = g0float_npow (x, 0) = g0i2f 1
    val- true = g0float_npow (x, 1) = g0i2f ~5
    val- true = g0float_npow (x, 2) = g0i2f 25
    val- true = g0float_npow (x, 3) = g0i2f ~125
    val- true = g0float_npow (x, 4) = g0i2f 625
    val- true = g0float_npow (x, 5) = g0i2f ~3125

    val- true = x**0 = g0i2f 1
    val- true = x**1 = g0i2f ~5
    val- true = x**2L = g0i2f 25
    val- true = x**3LL = g0i2f ~125
    val- true = x**4 = g0i2f 625
    val- true = x**5 = g0i2f ~3125

    val- true = (i2fx 2)**((g0i2i ~3) : sint) = i2fx 1 / i2fx 8

    val- true = ((g0f2i (i2fx 0)) : int) = 0
    val- true = ((g0f2i (d2fx 5.2)) : lint) = 5L
    val- true = ((g0f2i (d2fx ~5.2)) : llint) = ~5LL

    val- true = round x = x
    val- true = round y = y
    val- true = round (d2fx 0.0) = d2fx 0.0
    val- true = round (d2fx 0.5) = d2fx 1.0
    val- true = round (d2fx ~0.5) = d2fx ~1.0
    val- true = round (d2fx 5.0) = d2fx 5.0
    val- true = round (d2fx ~5.0) = d2fx ~5.0
    val- true = round (d2fx 5.2) = d2fx 5.0
    val- true = round (d2fx ~5.2) = d2fx ~5.0
    val- true = round (d2fx 5.8) = d2fx 6.0
    val- true = round (d2fx ~5.8) = d2fx ~6.0
    val- true = round (d2fx 5.5) = d2fx 6.0
    val- true = round (d2fx ~5.5) = d2fx ~6.0
    val- true = round (d2fx 6.5) = d2fx 7.0
    val- true = round (d2fx ~6.5) = d2fx ~7.0

    val- true = nearbyint x = x
    val- true = nearbyint y = y
    val- true = nearbyint (d2fx 0.0) = d2fx 0.0
    val- true = nearbyint (d2fx 0.5) = d2fx 0.0
    val- true = nearbyint (d2fx ~0.5) = d2fx ~0.0
    val- true = nearbyint (d2fx 5.0) = d2fx 5.0
    val- true = nearbyint (d2fx ~5.0) = d2fx ~5.0
    val- true = nearbyint (d2fx 5.2) = d2fx 5.0
    val- true = nearbyint (d2fx ~5.2) = d2fx ~5.0
    val- true = nearbyint (d2fx 5.8) = d2fx 6.0
    val- true = nearbyint (d2fx ~5.8) = d2fx ~6.0
    val- true = nearbyint (d2fx 5.5) = d2fx 6.0
    val- true = nearbyint (d2fx ~5.5) = d2fx ~6.0
    val- true = nearbyint (d2fx 6.5) = d2fx 6.0
    val- true = nearbyint (d2fx ~6.5) = d2fx ~6.0

    val- true = rint x = x
    val- true = rint y = y
    val- true = rint (d2fx 0.0) = d2fx 0.0
    val- true = rint (d2fx 0.5) = d2fx 0.0
    val- true = rint (d2fx ~0.5) = d2fx ~0.0
    val- true = rint (d2fx 5.0) = d2fx 5.0
    val- true = rint (d2fx ~5.0) = d2fx ~5.0
    val- true = rint (d2fx 5.2) = d2fx 5.0
    val- true = rint (d2fx ~5.2) = d2fx ~5.0
    val- true = rint (d2fx 5.8) = d2fx 6.0
    val- true = rint (d2fx ~5.8) = d2fx ~6.0
    val- true = rint (d2fx 5.5) = d2fx 6.0
    val- true = rint (d2fx ~5.5) = d2fx ~6.0
    val- true = rint (d2fx 6.5) = d2fx 6.0
    val- true = rint (d2fx ~6.5) = d2fx ~6.0

    val- true = floor x = x
    val- true = floor y = y
    val- true = floor (d2fx 0.0) = d2fx 0.0
    val- true = floor (d2fx 0.5) = d2fx 0.0
    val- true = floor (d2fx ~0.5) = d2fx ~1.0
    val- true = floor (d2fx 5.0) = d2fx 5.0
    val- true = floor (d2fx ~5.0) = d2fx ~5.0
    val- true = floor (d2fx 5.2) = d2fx 5.0
    val- true = floor (d2fx ~5.2) = d2fx ~6.0
    val- true = floor (d2fx 5.8) = d2fx 5.0
    val- true = floor (d2fx ~5.8) = d2fx ~6.0
    val- true = floor (d2fx 5.5) = d2fx 5.0
    val- true = floor (d2fx ~5.5) = d2fx ~6.0

    val- true = ceil x = x
    val- true = ceil y = y
    val- true = ceil (d2fx 0.0) = d2fx 0.0
    val- true = ceil (d2fx 0.5) = d2fx 1.0
    val- true = ceil (d2fx ~0.5) = d2fx ~0.0
    val- true = ceil (d2fx 5.0) = d2fx 5.0
    val- true = ceil (d2fx ~5.0) = d2fx ~5.0
    val- true = ceil (d2fx 5.2) = d2fx 6.0
    val- true = ceil (d2fx ~5.2) = d2fx ~5.0
    val- true = ceil (d2fx 5.8) = d2fx 6.0
    val- true = ceil (d2fx ~5.8) = d2fx ~5.0
    val- true = ceil (d2fx 5.5) = d2fx 6.0
    val- true = ceil (d2fx ~5.5) = d2fx ~5.0

    val- true = trunc x = x
    val- true = trunc y = y
    val- true = trunc (d2fx 0.0) = d2fx 0.0
    val- true = trunc (d2fx 0.5) = d2fx 0.0
    val- true = trunc (d2fx ~0.5) = d2fx 0.0
    val- true = trunc (d2fx 5.0) = d2fx 5.0
    val- true = trunc (d2fx ~5.0) = d2fx ~5.0
    val- true = trunc (d2fx 5.2) = d2fx 5.0
    val- true = trunc (d2fx ~5.2) = d2fx ~5.0
    val- true = trunc (d2fx 5.8) = d2fx 5.0
    val- true = trunc (d2fx ~5.8) = d2fx ~5.0
    val- true = trunc (d2fx 5.5) = d2fx 5.0
    val- true = trunc (d2fx ~5.5) = d2fx ~5.0

    val- true = sqrt (d2fx 0.0) = d2fx 0.0
    val- true = sqrt (d2fx 1.0) = d2fx 1.0
    val- true = sqrt (d2fx 25.0) = d2fx 5.0
    val- true = abs ((sqrt (d2fx 2.0) * sqrt (d2fx 2.0)) - d2fx 2.0) <= g0i2f 3 * epsilon ()
    val- true = abs ((sqrt (d2fx 3.1415926535) * sqrt (d2fx 3.1415926535)) - d2fx 3.1415926535) <= g0i2f 3 * epsilon ()
    val- true = abs ((sqrt (d2fx 0.3333) * sqrt (d2fx 0.3333)) - d2fx 0.3333) <= g0i2f 3 * epsilon ()

    val- "31415926.535000" = tostring_fixed32p32 (d2fx 31415926.535)
    val- "31415926.535" = tostring_fixed32p32 (d2fx 31415926.535, 3)
    val- "31415926" = tostring_fixed32p32 (d2fx 31415926.333, 0) (* Truncation. *)
    val- "31415927" = tostring_fixed32p32 (d2fx 31415926.535, 0) (* Rounding. *)

    val- "-31415926.535000" = tostring_fixed32p32 (d2fx ~31415926.535)
    val- "-31415926.535" = tostring_fixed32p32 (d2fx ~31415926.535, 3)
    val- "-31415926" = tostring_fixed32p32 (d2fx ~31415926.333, 0) (* Truncation. *)
    val- "-31415927" = tostring_fixed32p32 (d2fx ~31415926.535, 0) (* Rounding. *)

    val- "31415926.535000" = strptr2string (tostrptr_fixed32p32 (d2fx 31415926.535))
    val- "31415926.535" = strptr2string (tostrptr_fixed32p32 (d2fx 31415926.535, 3))
    val- "31415926" = strptr2string (tostrptr_fixed32p32 (d2fx 31415926.333, 0)) (* Truncation. *)
    val- "31415927" = strptr2string (tostrptr_fixed32p32 (d2fx 31415926.535, 0)) (* Rounding. *)

    val- "-31415926.535000" = strptr2string (tostrptr_fixed32p32 (d2fx ~31415926.535))
    val- "-31415926.535" = strptr2string (tostrptr_fixed32p32 (d2fx ~31415926.535, 3))
    val- "-31415926" = strptr2string (tostrptr_fixed32p32 (d2fx ~31415926.333, 0)) (* Truncation. *)
    val- "-31415927" = strptr2string (tostrptr_fixed32p32 (d2fx ~31415926.535, 0)) (* Rounding. *)

    val- "1000000" = tostring_fixed32p32 (d2fx 999999.9999, 0)
    val- "1000000.0" = tostring_fixed32p32 (d2fx 999999.9999, 1)
    val- "1000000.00" = tostring_fixed32p32 (d2fx 999999.9999, 2)
    val- "1000000.000" = tostring_fixed32p32 (d2fx 999999.9999, 3)
    val- "999999.9999" = tostring_fixed32p32 (d2fx 999999.9999, 4)
    val- "999999.99990" = tostring_fixed32p32 (d2fx 999999.9999, 5)

    val- "999998" = tostring_fixed32p32 (d2fx 999997.5, 0)
    val- "999998" = tostring_fixed32p32 (d2fx 999998.5, 0)
    val- "1000000" = tostring_fixed32p32 (d2fx 999999.5, 0)
    val- "-999998" = tostring_fixed32p32 (d2fx ~999997.5, 0)
    val- "-999998" = tostring_fixed32p32 (d2fx ~999998.5, 0)
    val- "-1000000" = tostring_fixed32p32 (d2fx ~999999.5, 0)

    val- "999998" = tostring_fixed32p32 (d2fx 999997.5001, 0)
    val- "999999" = tostring_fixed32p32 (d2fx 999998.5001, 0)
    val- "1000000" = tostring_fixed32p32 (d2fx 999999.5001, 0)
    val- "-999998" = tostring_fixed32p32 (d2fx ~999997.5001, 0)
    val- "-999999" = tostring_fixed32p32 (d2fx ~999998.5001, 0)
    val- "-1000000" = tostring_fixed32p32 (d2fx ~999999.5001, 0)

    val- "999997" = tostring_fixed32p32 (d2fx 999997.4999, 0)
    val- "999998" = tostring_fixed32p32 (d2fx 999998.4999, 0)
    val- "999999" = tostring_fixed32p32 (d2fx 999999.4999, 0)
    val- "-999997" = tostring_fixed32p32 (d2fx ~999997.4999, 0)
    val- "-999998" = tostring_fixed32p32 (d2fx ~999998.4999, 0)
    val- "-999999" = tostring_fixed32p32 (d2fx ~999999.4999, 0)

    val- "0.001000" = tostring_fixed32p32 (d2fx 0.001)
    val- "0.000001" = tostring_fixed32p32 (d2fx 0.000001)
    val- "0.000000" = tostring_fixed32p32 (d2fx 0.0000001)
    val- "0.000000" = tostring_fixed32p32 (d2fx 0.0000005)
    val- "0.000001" = tostring_fixed32p32 (d2fx 0.0000006)

    val- true = sgn (d2fx ~123.456) = ~1
    val- true = sgn (d2fx 0.0) = 0
    val- true = sgn (d2fx 123.456) = 1

    val- true = g0float2float<fix32p32knd,fix32p32knd> (d2fx 1234.5) = d2fx 1234.5
  in
  end

fn
test1 () : void =
  let
    var x : fixed32p32 = g0i2f 5
    val () = x <- 6
    val- true = x = i2fx 6
    var y : double = g0float_nan ()
    val () = y <- x
    val- true = y = 6.0
  in
  end

implement
main () =
  begin
    test0 ();
    test1 ();
    0
  end

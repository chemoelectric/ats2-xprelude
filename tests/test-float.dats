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

staload UN = "prelude/SATS/unsafe.sats"

fn
test1 () : void =
  let
    val- true = epsilon<fltknd> () > 0.0F
    val- true = epsilon<dblknd> () > 0.0
    val- true = epsilon<ldblknd> () > 0.0L
    val- true = epsilon<fltknd> () <= 1E-5F
    val- true = epsilon<dblknd> () <= 1E-9
    val- true = epsilon<ldblknd> () <= 1E-9L
  in
  end

fn
test2 () : void =
  let
    val- true = sgn ~1.0F = ~1
    val- true = sgn ~2.0 = ~1
    val- true = sgn ~3.0L = ~1
    val- true = sgn 0.0F = 0
    val- true = sgn 0.0 = 0
    val- true = sgn 0.0L = 0
    val- true = sgn 1.0F = 1
    val- true = sgn 2.0 = 1
    val- true = sgn 3.0L = 1
  in
  end

fn
test3 () : void =
  let
    val- true = round 5.2F = 5.0F
    val- true = round ~5.2F = ~5.0F
    val- true = round 5.2 = 5.0
    val- true = round ~5.2 = ~5.0
    val- true = round 5.2L = 5.0L
    val- true = round ~5.2L = ~5.0L
    val- true = round 4.5L = 5.0L
    val- true = round 5.5L = 6.0L
    val- true = round ~4.5L = ~5.0L
    val- true = round ~5.5L = ~6.0L
  in
  end

fn
test4 () : void =
  let
    val- true = nearbyint 5.2F = 5.0F
    val- true = nearbyint ~5.2F = ~5.0F
    val- true = nearbyint 5.2 = 5.0
    val- true = nearbyint ~5.2 = ~5.0
    val- true = nearbyint 5.2L = 5.0L
    val- true = nearbyint ~5.2L = ~5.0L
    val- true = nearbyint 4.5L = 4.0L
    val- true = nearbyint 5.5L = 6.0L
    val- true = nearbyint ~4.5L = ~4.0L
    val- true = nearbyint ~5.5L = ~6.0L
  in
  end

fn
test5 () : void =
  let
    val- true = rint 5.2F = 5.0F
    val- true = rint ~5.2F = ~5.0F
    val- true = rint 5.2 = 5.0
    val- true = rint ~5.2 = ~5.0
    val- true = rint 5.2L = 5.0L
    val- true = rint ~5.2L = ~5.0L
    val- true = rint 4.5L = 4.0L
    val- true = rint 5.5L = 6.0L
    val- true = rint ~4.5L = ~4.0L
    val- true = rint ~5.5L = ~6.0L
  in
  end

fn
test6 () : void =
  let
    val- true = floor 5.2F = 5.0F
    val- true = floor ~5.2F = ~6.0F
    val- true = floor 5.2 = 5.0
    val- true = floor ~5.2 = ~6.0
    val- true = floor 5.2L = 5.0L
    val- true = floor ~5.2L = ~6.0L
    val- true = floor 4.5L = 4.0L
    val- true = floor 5.5L = 5.0L
  in
  end

fn
test7 () : void =
  let
    val- true = ceil 5.2F = 6.0F
    val- true = ceil ~5.2F = ~5.0F
    val- true = ceil 5.2 = 6.0
    val- true = ceil ~5.2 = ~5.0
    val- true = ceil 5.2L = 6.0L
    val- true = ceil ~5.2L = ~5.0L
    val- true = ceil 4.5L = 5.0L
    val- true = ceil 5.5L = 6.0L
  in
  end

fn
test8 () : void =
  let
    val- true = trunc 5.2F = 5.0F
    val- true = trunc ~5.2F = ~5.0F
    val- true = trunc 5.2 = 5.0
    val- true = trunc ~5.2 = ~5.0
    val- true = trunc 5.2L = 5.0L
    val- true = trunc ~5.2L = ~5.0L
    val- true = trunc 4.5L = 4.0L
    val- true = trunc 5.5L = 5.0L
  in
  end

fn
test9 () : void =
  let
    val- true = sqrt 0.0F = 0.0F
    val- true = sqrt 1.0L = 1.0L
    val- true = sqrt 4.0 = 2.0
    val- true = sqrt 25.0 = 5.0
  in
  end

fn
test10 () : void =
  let
    val- true = sin 0.0F = 0.0F
    val- true = abs (sin 1.57079632675 - 1.0) < 0.000001
    val- true = cos 0.0L = 1.0L
    val- true = abs (cos 1.57079632675) < 0.000001
    val- true = abs (tan 0.785398163375 - 1.0) < 0.000001
    val- true = abs (asin 1.0 - 1.57079632675) < 0.000001
    val- true = abs (acos 0.0 - 1.57079632675) < 0.000001
    val- true = abs (atan 1.0 - 0.785398163375) < 0.000001
    val- true = abs (atan2 (3.0L, 4.0L) - 0.643501108793284L) < 0.000001L
  in
  end

fn
test11 () : void =
  let
    val- true = abs (M_Ef - $extval (float, "M_E")) = 0.0F
    val- true = abs (M_LOG2Ef - $extval (float, "M_LOG2E")) = 0.0F
    val- true = abs (M_LOG10Ef - $extval (float, "M_LOG10E")) = 0.0F
    val- true = abs (M_LN2f - $extval (float, "M_LN2")) = 0.0F
    val- true = abs (M_LN10f - $extval (float, "M_LN10")) = 0.0F
    val- true = abs (M_PIf - $extval (float, "M_PI")) = 0.0F
    val- true = abs (M_PI_2f - $extval (float, "M_PI_2")) = 0.0F
    val- true = abs (M_PI_4f - $extval (float, "M_PI_4")) = 0.0F
    val- true = abs (M_1_PIf - $extval (float, "M_1_PI")) = 0.0F
    val- true = abs (M_2_PIf - $extval (float, "M_2_PI")) = 0.0F
    val- true = abs (M_2_SQRTPIf - $extval (float, "M_2_SQRTPI")) = 0.0F
    val- true = abs (M_SQRT2f - $extval (float, "M_SQRT2")) = 0.0F
    val- true = abs (M_SQRT1_2f - $extval (float, "M_SQRT1_2")) = 0.0F

    val- true = abs (M_E - $extval (double, "M_E")) = 0.0
    val- true = abs (M_LOG2E - $extval (double, "M_LOG2E")) = 0.0
    val- true = abs (M_LOG10E - $extval (double, "M_LOG10E")) = 0.0
    val- true = abs (M_LN2 - $extval (double, "M_LN2")) = 0.0
    val- true = abs (M_LN10 - $extval (double, "M_LN10")) = 0.0
    val- true = abs (M_PI - $extval (double, "M_PI")) = 0.0
    val- true = abs (M_PI_2 - $extval (double, "M_PI_2")) = 0.0
    val- true = abs (M_PI_4 - $extval (double, "M_PI_4")) = 0.0
    val- true = abs (M_1_PI - $extval (double, "M_1_PI")) = 0.0
    val- true = abs (M_2_PI - $extval (double, "M_2_PI")) = 0.0
    val- true = abs (M_2_SQRTPI - $extval (double, "M_2_SQRTPI")) = 0.0
    val- true = abs (M_SQRT2 - $extval (double, "M_SQRT2")) = 0.0
    val- true = abs (M_SQRT1_2 - $extval (double, "M_SQRT1_2")) = 0.0

    val- true = abs (M_El - $extval (ldouble, "M_E")) < 0.0000000001L
    val- true = abs (M_LOG2El - $extval (ldouble, "M_LOG2E")) < 0.0000000001L
    val- true = abs (M_LOG10El - $extval (ldouble, "M_LOG10E")) < 0.0000000001L
    val- true = abs (M_LN2l - $extval (ldouble, "M_LN2")) < 0.0000000001L
    val- true = abs (M_LN10l - $extval (ldouble, "M_LN10")) < 0.0000000001L
    val- true = abs (M_PIl - $extval (ldouble, "M_PI")) < 0.0000000001L
    val- true = abs (M_PI_2l - $extval (ldouble, "M_PI_2")) < 0.0000000001L
    val- true = abs (M_PI_4l - $extval (ldouble, "M_PI_4")) < 0.0000000001L
    val- true = abs (M_1_PIl - $extval (ldouble, "M_1_PI")) < 0.0000000001L
    val- true = abs (M_2_PIl - $extval (ldouble, "M_2_PI")) < 0.0000000001L
    val- true = abs (M_2_SQRTPIl - $extval (ldouble, "M_2_SQRTPI")) < 0.0000000001L
    val- true = abs (M_SQRT2l - $extval (ldouble, "M_SQRT2")) < 0.0000000001L
    val- true = abs (M_SQRT1_2l - $extval (ldouble, "M_SQRT1_2")) < 0.0000000001L
  in
  end

fn
test12 () : void =
  let
    val- true = abs (mathconst_E () - $extval (float, "M_E")) = 0.0F
    val- true = abs (mathconst_LOG2E () - $extval (float, "M_LOG2E")) = 0.0F
    val- true = abs (mathconst_LOG10E () - $extval (float, "M_LOG10E")) = 0.0F
    val- true = abs (mathconst_LN2 () - $extval (float, "M_LN2")) = 0.0F
    val- true = abs (mathconst_LN10 () - $extval (float, "M_LN10")) = 0.0F
    val- true = abs (mathconst_PI () - $extval (float, "M_PI")) = 0.0F
    val- true = abs (mathconst_PI_2 () - $extval (float, "M_PI_2")) = 0.0F
    val- true = abs (mathconst_PI_4 () - $extval (float, "M_PI_4")) = 0.0F
    val- true = abs (mathconst_1_PI () - $extval (float, "M_1_PI")) = 0.0F
    val- true = abs (mathconst_2_PI () - $extval (float, "M_2_PI")) = 0.0F
    val- true = abs (mathconst_2_SQRTPI () - $extval (float, "M_2_SQRTPI")) = 0.0F
    val- true = abs (mathconst_SQRT2 () - $extval (float, "M_SQRT2")) = 0.0F
    val- true = abs (mathconst_SQRT1_2 () - $extval (float, "M_SQRT1_2")) = 0.0F

    val- true = abs (mathconst_E () - $extval (double, "M_E")) = 0.0
    val- true = abs (mathconst_LOG2E () - $extval (double, "M_LOG2E")) = 0.0
    val- true = abs (mathconst_LOG10E () - $extval (double, "M_LOG10E")) = 0.0
    val- true = abs (mathconst_LN2 () - $extval (double, "M_LN2")) = 0.0
    val- true = abs (mathconst_LN10 () - $extval (double, "M_LN10")) = 0.0
    val- true = abs (mathconst_PI () - $extval (double, "M_PI")) = 0.0
    val- true = abs (mathconst_PI_2 () - $extval (double, "M_PI_2")) = 0.0
    val- true = abs (mathconst_PI_4 () - $extval (double, "M_PI_4")) = 0.0
    val- true = abs (mathconst_1_PI () - $extval (double, "M_1_PI")) = 0.0
    val- true = abs (mathconst_2_PI () - $extval (double, "M_2_PI")) = 0.0
    val- true = abs (mathconst_2_SQRTPI () - $extval (double, "M_2_SQRTPI")) = 0.0
    val- true = abs (mathconst_SQRT2 () - $extval (double, "M_SQRT2")) = 0.0
    val- true = abs (mathconst_SQRT1_2 () - $extval (double, "M_SQRT1_2")) = 0.0

    val- true = abs (mathconst_E () - $extval (ldouble, "M_E")) < 0.0000000001L
    val- true = abs (mathconst_LOG2E () - $extval (ldouble, "M_LOG2E")) < 0.0000000001L
    val- true = abs (mathconst_LOG10E () - $extval (ldouble, "M_LOG10E")) < 0.0000000001L
    val- true = abs (mathconst_LN2 () - $extval (ldouble, "M_LN2")) < 0.0000000001L
    val- true = abs (mathconst_LN10 () - $extval (ldouble, "M_LN10")) < 0.0000000001L
    val- true = abs (mathconst_PI () - $extval (ldouble, "M_PI")) < 0.0000000001L
    val- true = abs (mathconst_PI_2 () - $extval (ldouble, "M_PI_2")) < 0.0000000001L
    val- true = abs (mathconst_PI_4 () - $extval (ldouble, "M_PI_4")) < 0.0000000001L
    val- true = abs (mathconst_1_PI () - $extval (ldouble, "M_1_PI")) < 0.0000000001L
    val- true = abs (mathconst_2_PI () - $extval (ldouble, "M_2_PI")) < 0.0000000001L
    val- true = abs (mathconst_2_SQRTPI () - $extval (ldouble, "M_2_SQRTPI")) < 0.0000000001L
    val- true = abs (mathconst_SQRT2 () - $extval (ldouble, "M_SQRT2")) < 0.0000000001L
    val- true = abs (mathconst_SQRT1_2 () - $extval (ldouble, "M_SQRT1_2")) < 0.0000000001L
  in
  end

implement
main () =
  begin
    test1 ();
    test2 ();
    test3 ();
    test4 ();
    test5 ();
    test6 ();
    test7 ();
    test8 ();
    test9 ();
    test10 ();
    test11 ();
    test12 ();

    // FIXME: GIVE EXTENDED FLOATING POINT ITS OWN SET OF TESTS, CONDITIONAL ON THEIR INCLUSION.
    let
      val () = println!(((g0f2f 3.14159) : float128))
      val () = println!(tostring_val<float128> ((g0f2f 3.14159) : float128))
      val () = println!(((g0f2f 3.14159) : float128) < g0i2f 3)
      val () = println!(((g0f2f 3.14159) : float128) < g0f2f 3.14159)
      val () = println!(((g0f2f 3.14159) : float128) < g0i2f 4)
      val () = println!(~((g0f2f 3.14159) : decimal64) = g0f2f ~3.14159)
      val () = println!(g0float2float<dec32knd,flt32knd> (M_Ed32))
      val () = println!(g0float2float<flt128knd,flt32knd> (M_PIf128))
      //    val- true = abs (atan2 (g0f2f 3.0L, g0f2f 4.0L) - g0f2f 0.643501108793284L) < ((g0f2f 0.000001L) : float128)
    in
    end;
    0
  end

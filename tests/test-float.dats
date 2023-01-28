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

fn
test13 () : void =
  let
    val- true = g0float_neg 3.0 = ~3.0
    val- true = ~ (2.0 + 1.0) = ~3.0

    val- true = fabs 3.0 = 3.0
    val- true = fabs ~3.0 = 3.0
    val- true = fabs 3.0 = abs 3.0
    val- true = fabs ~3.0 = abs ~3.0

    val- true = 1.0 + 2.0 = 3.0
    val- true = 2.0 + 1.0 = 3.0
    val- true = 3.0 - 1.0 = 2.0
    val- true = 1.0 - 3.0 = ~2.0
    val- true = 3.0 * 2.0 = 6.0
    val- true = 2.0 * 3.0 = 6.0
    val- true = 6.0 / 2.0 = 3.0
    val- true = 6.0 / 3.0 = 2.0
    val- true = 6.0 mod 2.0 = 0.0
    val- true = 6.0 mod 3.0 = 0.0
    val- true = 2.0 * (3.0 / 2.0) = 3.0
    val- true = 3.0 mod 2.0 = 1.0
    val- true = 2.0 mod 3.0 = 2.0

    val- true = fma (2.0, 3.0, 1.0) = 7.0
  in
  end

fn
test14 () : void =
  let
    val- true = ~3.0 < 3.0
    val- false = ~3.0 > 3.0
    val- true = ~3.0 <= 3.0
    val- false = ~3.0 >= 3.0
    val- false = ~3.0 = 3.0
    val- true = ~3.0 <> 3.0
    val- true = ~3.0 != 3.0

    val- false = 3.0 < ~3.0
    val- true = 3.0 > ~3.0
    val- false = 3.0 <= ~3.0
    val- true = 3.0 >= ~3.0
    val- false = 3.0 = ~3.0
    val- true = 3.0 <> ~3.0
    val- true = 3.0 != ~3.0

    val- false = 3.0 < 3.0
    val- false = 3.0 > 3.0
    val- true = 3.0 <= 3.0
    val- true = 3.0 >= 3.0
    val- true = 3.0 = 3.0
    val- false = 3.0 <> 3.0
    val- false = 3.0 != 3.0
  in
  end

fn
test15 () : void =
  let
    val- true = isltz ~3.0
    val- true = isltez ~3.0
    val- false = isgtz ~3.0
    val- false = isgtez ~3.0
    val- false = iseqz ~3.0
    val- true = isneqz ~3.0

    val- false = isltz 0.0
    val- true = isltez 0.0
    val- false = isgtz 0.0
    val- true = isgtez 0.0
    val- true = iseqz 0.0
    val- false = isneqz 0.0

    val- false = isltz 3.0
    val- false = isltez 3.0
    val- true = isgtz 3.0
    val- true = isgtez 3.0
    val- false = iseqz 3.0
    val- true = isneqz 3.0
  in
  end

fn
test16 () : void =
  let
    val- true = min (~3.0, 3.0) = ~3.0
    val- true = min (3.0, ~3.0) = ~3.0

    val- true = max (~3.0, 3.0) = 3.0
    val- true = max (3.0, ~3.0) = 3.0
  in
  end

fn
test17 () : void =
  let
    val- true = succ ~3.0 = ~2.0
    val- true = succ 3.0 = 4.0

    val- true = pred ~3.0 = ~4.0
    val- true = pred 3.0 = 2.0
  in
  end

fn
test18 () : void =
  let
    overload ** with g0float_npow of 1000

    val- true = g0float_npow (0.0, 0) = 1.0
    val- true = g0float_npow (1.0, 0) = 1.0
    val- true = g0float_npow (2.0, 0) = 1.0
    val- true = g0float_npow (3.0, 0) = 1.0
    val- true = g0float_npow (4.0, 0) = 1.0

    val- true = g0float_npow (0.0, 1) = 0.0
    val- true = g0float_npow (1.0, 1) = 1.0
    val- true = g0float_npow (2.0, 1) = 2.0
    val- true = g0float_npow (3.0, 1) = 3.0
    val- true = g0float_npow (4.0, 1) = 4.0

    val- true = g0float_npow (0.0, 2) = 0.0
    val- true = g0float_npow (1.0, 2) = 1.0
    val- true = g0float_npow (2.0, 2) = 4.0
    val- true = g0float_npow (3.0, 2) = 9.0
    val- true = g0float_npow (4.0, 2) = 16.0

    val- true = g0float_npow (0.0, 3) = 0.0
    val- true = g0float_npow (1.0, 3) = 1.0
    val- true = g0float_npow (2.0, 3) = 8.0
    val- true = g0float_npow (3.0, 3) = 27.0
    val- true = g0float_npow (4.0, 3) = 64.0

    val- true = 0.0 ** 0 = 1.0
    val- true = 1.0 ** 0 = 1.0
    val- true = 2.0 ** 0 = 1.0
    val- true = 3.0 ** 0 = 1.0
    val- true = 4.0 ** 0 = 1.0

    val- true = 0.0 ** 1 = 0.0
    val- true = 1.0 ** 1 = 1.0
    val- true = 2.0 ** 1 = 2.0
    val- true = 3.0 ** 1 = 3.0
    val- true = 4.0 ** 1 = 4.0

    val- true = 0.0 ** 2 = 0.0
    val- true = 1.0 ** 2 = 1.0
    val- true = 2.0 ** 2 = 4.0
    val- true = 3.0 ** 2 = 9.0
    val- true = 4.0 ** 2 = 16.0

    val- true = 0.0 ** 3 = 0.0
    val- true = 1.0 ** 3 = 1.0
    val- true = 2.0 ** 3 = 8.0
    val- true = 3.0 ** 3 = 27.0
    val- true = 4.0 ** 3 = 64.0

    val- true = pow (0.0, 0.0) = 1.0
    val- true = pow (1.0, 0.0) = 1.0
    val- true = pow (2.0, 0.0) = 1.0
    val- true = pow (3.0, 0.0) = 1.0
    val- true = pow (4.0, 0.0) = 1.0

    val- true = pow (0.0, 1.0) = 0.0
    val- true = pow (1.0, 1.0) = 1.0
    val- true = pow (2.0, 1.0) = 2.0
    val- true = pow (3.0, 1.0) = 3.0
    val- true = pow (4.0, 1.0) = 4.0

    val- true = pow (0.0, 2.0) = 0.0
    val- true = pow (1.0, 2.0) = 1.0
    val- true = pow (2.0, 2.0) = 4.0
    val- true = pow (3.0, 2.0) = 9.0
    val- true = pow (4.0, 2.0) = 16.0

    val- true = pow (0.0, 3.0) = 0.0
    val- true = pow (1.0, 3.0) = 1.0
    val- true = pow (2.0, 3.0) = 8.0
    val- true = pow (3.0, 3.0) = 27.0
    val- true = pow (4.0, 3.0) = 64.0

    val- true = 0.0 ** 0.0 = 1.0
    val- true = 1.0 ** 0.0 = 1.0
    val- true = 2.0 ** 0.0 = 1.0
    val- true = 3.0 ** 0.0 = 1.0
    val- true = 4.0 ** 0.0 = 1.0

    val- true = 0.0 ** 1.0 = 0.0
    val- true = 1.0 ** 1.0 = 1.0
    val- true = 2.0 ** 1.0 = 2.0
    val- true = 3.0 ** 1.0 = 3.0
    val- true = 4.0 ** 1.0 = 4.0

    val- true = 0.0 ** 2.0 = 0.0
    val- true = 1.0 ** 2.0 = 1.0
    val- true = 2.0 ** 2.0 = 4.0
    val- true = 3.0 ** 2.0 = 9.0
    val- true = 4.0 ** 2.0 = 16.0

    val- true = 0.0 ** 3.0 = 0.0
    val- true = 1.0 ** 3.0 = 1.0
    val- true = 2.0 ** 3.0 = 8.0
    val- true = 3.0 ** 3.0 = 27.0
    val- true = 4.0 ** 3.0 = 64.0

    val- true = g0float_npow (0.0F, 3) = 0.0F
    val- true = g0float_npow (1.0F, 3) = 1.0F
    val- true = g0float_npow (2.0F, 3) = 8.0F
    val- true = g0float_npow (3.0F, 3) = 27.0F
    val- true = g0float_npow (4.0F, 3) = 64.0F

    val- true = g0float_npow (0.0L, 3) = 0.0L
    val- true = g0float_npow (1.0L, 3) = 1.0L
    val- true = g0float_npow (2.0L, 3) = 8.0L
    val- true = g0float_npow (3.0L, 3) = 27.0L
    val- true = g0float_npow (4.0L, 3) = 64.0L
  in
  end

fn
test19 () : void =
  let
    val- true = g0float_radix<fltknd> () = $extval (Int, "FLT_RADIX")
    val- true = g0float_radix<dblknd> () = $extval (Int, "FLT_RADIX")
    val- true = g0float_radix<ldblknd> () = $extval (Int, "FLT_RADIX")
  in
  end

fn
test20 () : void =
  let
    val- true = g0float_mant_dig<fltknd> () = $extval (Int, "FLT_MANT_DIG")
    val- true = g0float_mant_dig<dblknd> () = $extval (Int, "DBL_MANT_DIG")
    val- true = g0float_mant_dig<ldblknd> () = $extval (Int, "LDBL_MANT_DIG")

    val- true = g0float_decimal_dig<fltknd> () = $extval (Int, "FLT_DECIMAL_DIG")
    val- true = g0float_decimal_dig<dblknd> () = $extval (Int, "DBL_DECIMAL_DIG")
    val- true = g0float_decimal_dig<ldblknd> () = $extval (Int, "LDBL_DECIMAL_DIG")

    val- true = g0float_dig<fltknd> () = $extval (Int, "FLT_DIG")
    val- true = g0float_dig<dblknd> () = $extval (Int, "DBL_DIG")
    val- true = g0float_dig<ldblknd> () = $extval (Int, "LDBL_DIG")

    val- true = g0float_min_exp<fltknd> () = $extval (Int, "FLT_MIN_EXP")
    val- true = g0float_min_exp<dblknd> () = $extval (Int, "DBL_MIN_EXP")
    val- true = g0float_min_exp<ldblknd> () = $extval (Int, "LDBL_MIN_EXP")

    val- true = g0float_min_10_exp<fltknd> () = $extval (Int, "FLT_MIN_10_EXP")
    val- true = g0float_min_10_exp<dblknd> () = $extval (Int, "DBL_MIN_10_EXP")
    val- true = g0float_min_10_exp<ldblknd> () = $extval (Int, "LDBL_MIN_10_EXP")

    val- true = g0float_max_exp<fltknd> () = $extval (Int, "FLT_MAX_EXP")
    val- true = g0float_max_exp<dblknd> () = $extval (Int, "DBL_MAX_EXP")
    val- true = g0float_max_exp<ldblknd> () = $extval (Int, "LDBL_MAX_EXP")

    val- true = g0float_max_10_exp<fltknd> () = $extval (Int, "FLT_MAX_10_EXP")
    val- true = g0float_max_10_exp<dblknd> () = $extval (Int, "DBL_MAX_10_EXP")
    val- true = g0float_max_10_exp<ldblknd> () = $extval (Int, "LDBL_MAX_10_EXP")

    val- true = g0float_max_value<fltknd> () = $extval (float, "FLT_MAX")
    val- true = g0float_max_value<dblknd> () = $extval (double, "DBL_MAX")
    val- true = g0float_max_value<ldblknd> () = $extval (ldouble, "LDBL_MAX")

    val- true = g0float_min_value<fltknd> () = $extval (float, "FLT_MIN")
    val- true = g0float_min_value<dblknd> () = $extval (double, "DBL_MIN")
    val- true = g0float_min_value<ldblknd> () = $extval (ldouble, "LDBL_MIN")

    val- true = g0float_true_min_value<fltknd> () = $extval (float, "FLT_TRUE_MIN")
    val- true = g0float_true_min_value<dblknd> () = $extval (double, "DBL_TRUE_MIN")
    val- true = g0float_true_min_value<ldblknd> () = $extval (ldouble, "LDBL_TRUE_MIN")
  in
  end

fn
test21 () : void =
  let
      var buf : @[byte][100]

      val m = g0float_unsafe_strfrom (buf, i2sz 100, "%.4f", 1.2345F)
      val- true = $UN.cast{string} buf = "1.2345"

      val m = g0float_unsafe_strfrom (buf, i2sz 100, "%.4f", 1.2345)
      val- true = $UN.cast{string} buf = "1.2345"

      val m = g0float_unsafe_strfrom (buf, i2sz 100, "%.4f", 1.2345L)
      val- true = $UN.cast{string} buf = "1.2345"

      val s = g0float_strfrom ("%.4f", 1.2345F)
      val- true = s = "1.2345"
      val () = free s

      val s = g0float_strfrom ("%.4f", 1.2345)
      val- true = s = "1.2345"
      val () = free s

      val s = g0float_strfrom ("%.4f", 1.2345L)
      val- true = s = "1.2345"
      val () = free s

      (* Test whether g0float_strfrom works if a large buffer has to
         be allocated. *)
      val s = g0float_strfrom ("%.1024f", 1.5L)
      val- true = s = "1.5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
      val () = free s
  in
  end

fn
test22 () : void =
  let
    typedef c_char_p = $extype"char *"

    var p : c_char_p
    val x : float = g0float_unsafe_strto ($UN.cast{ptr} "1.2345", addr@ p)
    val- true = abs (x - 1.2345F) <= 0.0000001F

    var p : c_char_p
    val x : double = g0float_unsafe_strto ($UN.cast{ptr} "1.2345", addr@ p)
    val- true = abs (x - 1.2345) <= 0.0000001

    var p : c_char_p
    val x : ldouble = g0float_unsafe_strto ($UN.cast{ptr} "1.2345", addr@ p)
    val- true = abs (x - 1.2345L) <= 0.0000001L

    val s : String = "  1.2345"
    val @(x, j) = g0float_strto<fltknd> (s, i2sz 2)
    val- true = abs (x - 1.2345F) <= 0.0000001F
    val- true = string_is_atend (s, j)

    val s : String = "1.2345"
    val @(x, j) = g0float_strto<dblknd> (s, i2sz 0)
    val- true = abs (x - 1.2345) <= 0.0000001
    val- true = string_is_atend (s, j)

    val s : String = "x = 1.2345; /* example */"
    val @(x, j) = g0float_strto<ldblknd> (s, i2sz 4)
    val- true = abs (x - 1.2345L) <= 0.0000001L
    val- true = string_isnot_atend (s, j)
    val- true = s[j] = ';'
  in
  end

fn
test23 () : void =
  let
    val- true = g0float_int_pow (0.0, 0) = 1.0
    val- true = g0float_int_pow (1.0, 0) = 1.0
    val- true = g0float_int_pow (2.0, 0) = 1.0
    val- true = g0float_int_pow (3.0, 0) = 1.0
    val- true = g0float_int_pow (4.0, 0) = 1.0

    val- true = g0float_int_pow (0.0F, 1L) = 0.0F
    val- true = g0float_int_pow (1.0F, 1L) = 1.0F
    val- true = g0float_int_pow (2.0F, 1L) = 2.0F
    val- true = g0float_int_pow (3.0F, 1L) = 3.0F
    val- true = g0float_int_pow (4.0F, 1L) = 4.0F

    val- true = g0float_int_pow (0.0L, 2LL) = 0.0L
    val- true = g0float_int_pow (1.0L, 2LL) = 1.0L
    val- true = g0float_int_pow (2.0L, 2LL) = 4.0L
    val- true = g0float_int_pow (3.0L, 2LL) = 9.0L
    val- true = g0float_int_pow (4.0L, 2LL) = 16.0L

    val- true = g0float_int_pow (0.0, 3) = 0.0
    val- true = g0float_int_pow (1.0, 3) = 1.0
    val- true = g0float_int_pow (2.0, 3) = 8.0
    val- true = g0float_int_pow (3.0, 3) = 27.0
    val- true = g0float_int_pow (4.0, 3) = 64.0

    val- true = g0float_int_pow (0.0, ~1) > 1e100
    val- true = g0float_int_pow (1.0, ~1) = 1.0
    val- true = g0float_int_pow (2.0, ~1) = 0.5
    val- true = g0float_int_pow (4.0, ~1) = 0.25

    val- true = g0float_int_pow (0.0L, ~2LL) > 1e100L
    val- true = g0float_int_pow (1.0L, ~2LL) = 1.0L
    val- true = g0float_int_pow (2.0L, ~2LL) = 0.25L
    val- true = g0float_int_pow (4.0L, ~2LL) = 0.0625L

    val- true = (0.0 ** 0) = 1.0
    val- true = (1.0 ** 0) = 1.0
    val- true = (2.0 ** 0) = 1.0
    val- true = (3.0 ** 0) = 1.0
    val- true = (4.0 ** 0) = 1.0

    val- true = (0.0F ** 1L) = 0.0F
    val- true = (1.0F ** 1L) = 1.0F
    val- true = (2.0F ** 1L) = 2.0F
    val- true = (3.0F ** 1L) = 3.0F
    val- true = (4.0F ** 1L) = 4.0F

    val- true = (0.0L ** 2LL) = 0.0L
    val- true = (1.0L ** 2LL) = 1.0L
    val- true = (2.0L ** 2LL) = 4.0L
    val- true = (3.0L ** 2LL) = 9.0L
    val- true = (4.0L ** 2LL) = 16.0L

    val- true = (0.0 ** 3) = 0.0
    val- true = (1.0 ** 3) = 1.0
    val- true = (2.0 ** 3) = 8.0
    val- true = (3.0 ** 3) = 27.0
    val- true = (4.0 ** 3) = 64.0

    val- true = (0.0 ** ~1) > 1e100
    val- true = (1.0 ** ~1) = 1.0
    val- true = (2.0 ** ~1) = 0.5
    val- true = (4.0 ** ~1) = 0.25

    val- true = (0.0L ** ~2LL) > 1e100L
    val- true = (1.0L ** ~2LL) = 1.0L
    val- true = (2.0L ** ~2LL) = 0.25L
    val- true = (4.0L ** ~2LL) = 0.0625L
  in
  end

fn
test24 () : void =
  let
    val- true = huge_val<fltknd> () > 1e30F
    val- true = huge_val<dblknd> () > 1e100
    val- true = huge_val<ldblknd> () > 1e100L

    val- true = ~huge_val<fltknd> () < ~1e30F
    val- true = ~huge_val<dblknd> () < ~1e100
    val- true = ~huge_val<ldblknd> () < ~1e100L

    val- true = infinity<fltknd> () > 1e30F
    val- true = infinity<dblknd> () > 1e100
    val- true = infinity<ldblknd> () > 1e100L

    val- true = ~infinity<fltknd> () < ~1e30F
    val- true = ~infinity<dblknd> () < ~1e100
    val- true = ~infinity<ldblknd> () < ~1e100L

    val- true = isfinite (1.2345F)
    val- true = isfinite (1.2345)
    val- true = isfinite (1.2345L)
    val- true = isnormal (1.2345F)
    val- true = isnormal (1.2345)
    val- true = isnormal (1.2345L)
    val- false = isnan (1.2345F)
    val- false = isnan (1.2345)
    val- false = isnan (1.2345L)
    val- false = isinf (1.2345F)
    val- false = isinf (1.2345)
    val- false = isinf (1.2345L)

    val- false = isfinite (g0float_nan<fltknd> ())
    val- false = isfinite (g0float_nan<dblknd> ())
    val- false = isfinite (g0float_nan<ldblknd> ())
    val- false = isnormal (g0float_nan<fltknd> ())
    val- false = isnormal (g0float_nan<dblknd> ())
    val- false = isnormal (g0float_nan<ldblknd> ())
    val- true = isnan (g0float_nan<fltknd> ())
    val- true = isnan (g0float_nan<dblknd> ())
    val- true = isnan (g0float_nan<ldblknd> ())
    val- false = isinf (g0float_nan<fltknd> ())
    val- false = isinf (g0float_nan<dblknd> ())
    val- false = isinf (g0float_nan<ldblknd> ())

    val- false = isfinite (g0float_snan<fltknd> ())
    val- false = isfinite (g0float_snan<dblknd> ())
    val- false = isfinite (g0float_snan<ldblknd> ())
    val- false = isnormal (g0float_snan<fltknd> ())
    val- false = isnormal (g0float_snan<dblknd> ())
    val- false = isnormal (g0float_snan<ldblknd> ())
    val- true = isnan (g0float_snan<fltknd> ())
    val- true = isnan (g0float_snan<dblknd> ())
    val- true = isnan (g0float_snan<ldblknd> ())
    val- false = isinf (g0float_snan<fltknd> ())
    val- false = isinf (g0float_snan<dblknd> ())
    val- false = isinf (g0float_snan<ldblknd> ())

    val- false = isfinite (infinity<fltknd> ())
    val- false = isfinite (infinity<dblknd> ())
    val- false = isfinite (infinity<ldblknd> ())
    val- false = isnormal (infinity<fltknd> ())
    val- false = isnormal (infinity<dblknd> ())
    val- false = isnormal (infinity<ldblknd> ())
    val- false = isnan (infinity<fltknd> ())
    val- false = isnan (infinity<dblknd> ())
    val- false = isnan (infinity<ldblknd> ())
    val- true = isinf (infinity<fltknd> ())
    val- true = isinf (infinity<dblknd> ())
    val- true = isinf (infinity<ldblknd> ())
  in
  end

fn
test25 () : void =
  let
    val () = println! ()
    val () = println! ("g0float_mant_dig<fltknd> () = ", g0float_mant_dig<fltknd> ())
    val () = println! ("g0float_decimal_dig<fltknd> () = ", g0float_decimal_dig<fltknd> ())
    val () = println! ("g0float_dig<fltknd> () = ", g0float_dig<fltknd> ())
    val () = println! ("g0float_min_exp<fltknd> () = ", g0float_min_exp<fltknd> ())
    val () = println! ("g0float_min_10_exp<fltknd> () = ", g0float_min_10_exp<fltknd> ())
    val () = println! ("g0float_max_exp<fltknd> () = ", g0float_max_exp<fltknd> ())
    val () = println! ("g0float_max_10_exp<fltknd> () = ", g0float_max_10_exp<fltknd> ())
    val () = println! ("g0float_max_value<fltknd> () = ", g0float_max_value<fltknd> ())
    val s = strptr2string (g0float_strfrom ("%.10e", g0float_min_value<fltknd> ()))
    val () = println! ("g0float_min_value<fltknd> () = ", s)
    val s = strptr2string (g0float_strfrom ("%.10e", g0float_true_min_value<fltknd> ()))
    val () = println! ("g0float_true_min_value<fltknd> () = ", s)

    val () = println! ()
    val () = println! ("g0float_mant_dig<dblknd> () = ", g0float_mant_dig<dblknd> ())
    val () = println! ("g0float_decimal_dig<dblknd> () = ", g0float_decimal_dig<dblknd> ())
    val () = println! ("g0float_dig<dblknd> () = ", g0float_dig<dblknd> ())
    val () = println! ("g0float_min_exp<dblknd> () = ", g0float_min_exp<dblknd> ())
    val () = println! ("g0float_min_10_exp<dblknd> () = ", g0float_min_10_exp<dblknd> ())
    val () = println! ("g0float_max_exp<dblknd> () = ", g0float_max_exp<dblknd> ())
    val () = println! ("g0float_max_10_exp<dblknd> () = ", g0float_max_10_exp<dblknd> ())
    val () = println! ("g0float_max_value<dblknd> () = ", g0float_max_value<dblknd> ())
    val s = strptr2string (g0float_strfrom ("%.10e", g0float_min_value<dblknd> ()))
    val () = println! ("g0float_min_value<dblknd> () = ", s)
    val s = strptr2string (g0float_strfrom ("%.10e", g0float_true_min_value<dblknd> ()))
    val () = println! ("g0float_true_min_value<dblknd> () = ", s)

    val () = println! ()
    val () = println! ("g0float_mant_dig<ldblknd> () = ", g0float_mant_dig<ldblknd> ())
    val () = println! ("g0float_decimal_dig<ldblknd> () = ", g0float_decimal_dig<ldblknd> ())
    val () = println! ("g0float_dig<ldblknd> () = ", g0float_dig<ldblknd> ())
    val () = println! ("g0float_min_exp<ldblknd> () = ", g0float_min_exp<ldblknd> ())
    val () = println! ("g0float_min_10_exp<ldblknd> () = ", g0float_min_10_exp<ldblknd> ())
    val () = println! ("g0float_max_exp<ldblknd> () = ", g0float_max_exp<ldblknd> ())
    val () = println! ("g0float_max_10_exp<ldblknd> () = ", g0float_max_10_exp<ldblknd> ())
    val () = println! ("g0float_max_value<ldblknd> () = ", g0float_max_value<ldblknd> ())
    val s = strptr2string (g0float_strfrom ("%.10e", g0float_min_value<ldblknd> ()))
    val () = println! ("g0float_min_value<ldblknd> () = ", s)
    val s = strptr2string (g0float_strfrom ("%.10e", g0float_true_min_value<ldblknd> ()))
    val () = println! ("g0float_true_min_value<ldblknd> () = ", s)
  in
  end

fn
test26 () : void =
  let
    var x = 5.0F
    val- true = x = 5.0F
    val () = replace (x, 6.0L)
    val- true = x = 6.0F
    val () = replace (x, 7)
    val- true = x = 7.0F
  in
  end

fn
test27 () : void =
  let
    var x = 3.0L
    var y = 5.0L
    val- true = x = 3.0L
    val- true = y = 5.0L
    val () = exchange (x, y)
    val- true = x = 5.0L
    val- true = y = 3.0L
  in
  end

fn
test28 () : void =
  let
    var x = 1234.0
    val- true = x = 1234.0
    val () = neg_replace (x, x)
    val- true = x = ~1234.0
    val () = add_replace (x, x, 234.0)
    val- true = x = ~1000.0
    val () = sub_replace (x, x, ~2000.0)
    val- true = x = 1000.0
    val () = mul_replace (x, 2.0, x)
    val- true = x = 2000.0
    val () = div_replace (x, x, 10.0)
    val- true = x = 200.0
    val () = succ_replace (x, x)
    val- true = x = 201.0
    val () = pred_replace (x, x)
    val- true = x = 200.0
    val () = npow_replace (x, 2.0, 3)
    val- true = x = 8.0
    val () = int_pow_replace (x, 2.0, ~3)
    val- true = x = 0.125
    val- () = div_replace (x, 1.0, x)
    val- true = x = 8.0
  in
  end

fn
test29 () : void =
  let
    var x = 0.0
    val () = sin_replace (x, mathconst_PI () / 3.0)
    val- true = abs (x - (0.5 * sqrt (3.0))) < 0.000001
    val () = cos_replace (x, mathconst_PI () / 3.0)
    val- true = abs (x - 0.5) < 0.000001
    val () = pow_replace (x, 2.0, 10.0)
    val- true = x = 1024.0
    val () = fma_replace (x, 2.0, 3.0, 4.0)
    val- true = x = 10.0
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
    test13 ();
    test14 ();
    test15 ();
    test16 ();
    test17 ();
    test18 ();
    test19 ();
    test20 ();
    test21 ();
    test22 ();
    test23 ();
    test24 ();
    test25 ();
    test26 ();
    test27 ();
    test28 ();
    test29 ();
    0
  end

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
    val- true = epsilon<flt128knd> () > $extval (float128, "0.0f128")
    val- true = epsilon<flt128knd> () <= $extval (float128, "2.23E-16f128")

    val- true = epsilon () > $extval (float128, "0.0f128")
    val- true = epsilon () <= $extval (float128, "2.23E-16f128")
  in
  end

fn
test2 () : void =
  let
    val- true = sgn ($extval (float128, "-2.0f128")) = ~1
    val- true = sgn ($extval (float128, "-0.0f128")) = 0
    val- true = sgn ($extval (float128, "0.0f128")) = 0
    val- true = sgn ($extval (float128, "3.0f128")) = 1
  in
  end

fn
test3 () : void =
  let
    val- true = round ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = round ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = round ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = round ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = round ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = round ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = round ($extval (float128, "4.5f128")) = ($extval (float128, "5.0f128"))
    val- true = round ($extval (float128, "5.5f128")) = ($extval (float128, "6.0f128"))
    val- true = round ($extval (float128, "-4.5f128")) = ($extval (float128, "-5.0f128"))
    val- true = round ($extval (float128, "-5.5f128")) = ($extval (float128, "-6.0f128"))
  in
  end

fn
test4 () : void =
  let
    val- true = nearbyint ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = nearbyint ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = nearbyint ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = nearbyint ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = nearbyint ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = nearbyint ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = nearbyint ($extval (float128, "4.5f128")) = ($extval (float128, "4.0f128"))
    val- true = nearbyint ($extval (float128, "5.5f128")) = ($extval (float128, "6.0f128"))
    val- true = nearbyint ~($extval (float128, "4.5f128")) = ~($extval (float128, "4.0f128"))
    val- true = nearbyint ($extval (float128, "-5.5f128")) = ($extval (float128, "-6.0f128"))
  in
  end

fn
test5 () : void =
  let
    val- true = rint ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = rint ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = rint ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = rint ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = rint ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = rint ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = rint ($extval (float128, "4.5f128")) = ($extval (float128, "4.0f128"))
    val- true = rint ($extval (float128, "5.5f128")) = ($extval (float128, "6.0f128"))
    val- true = rint ~($extval (float128, "4.5f128")) = ~($extval (float128, "4.0f128"))
    val- true = rint ($extval (float128, "-5.5f128")) = ($extval (float128, "-6.0f128"))
  in
  end

fn
test6 () : void =
  let
    val- true = floor ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = floor ($extval (float128, "-5.2f128")) = ($extval (float128, "-6.0f128"))
    val- true = floor ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = floor ($extval (float128, "-5.2f128")) = ($extval (float128, "-6.0f128"))
    val- true = floor ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = floor ($extval (float128, "-5.2f128")) = ($extval (float128, "-6.0f128"))
    val- true = floor ($extval (float128, "4.5f128")) = ($extval (float128, "4.0f128"))
    val- true = floor ($extval (float128, "5.5f128")) = ($extval (float128, "5.0f128"))
  in
  end

fn
test7 () : void =
  let
    val- true = ceil ($extval (float128, "5.2f128")) = ($extval (float128, "6.0f128"))
    val- true = ceil ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = ceil ($extval (float128, "5.2f128")) = ($extval (float128, "6.0f128"))
    val- true = ceil ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = ceil ($extval (float128, "5.2f128")) = ($extval (float128, "6.0f128"))
    val- true = ceil ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = ceil ($extval (float128, "4.5f128")) = ($extval (float128, "5.0f128"))
    val- true = ceil ($extval (float128, "5.5f128")) = ($extval (float128, "6.0f128"))
  in
  end

fn
test8 () : void =
  let
    val- true = trunc ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = trunc ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = trunc ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = trunc ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = trunc ($extval (float128, "5.2f128")) = ($extval (float128, "5.0f128"))
    val- true = trunc ($extval (float128, "-5.2f128")) = ($extval (float128, "-5.0f128"))
    val- true = trunc ($extval (float128, "4.5f128")) = ($extval (float128, "4.0f128"))
    val- true = trunc ($extval (float128, "5.5f128")) = ($extval (float128, "5.0f128"))
  in
  end

fn
test9 () : void =
  let
    val- true = sqrt ($extval (float128, "25.0f128")) = ($extval (float128, "5.0f128"))
  in
  end

fn
test10 () : void =
  let
    val- true = sin ($extval (float128, "0.0f128")) = ($extval (float128, "0.0f128"))
    val- true = abs (sin ($extval (float128, "1.57079632675")) - ($extval (float128, "1.0f128"))) < ($extval (float128, "1E-10f128"))
    val- true = cos ($extval (float128, "0.0f128")) = ($extval (float128, "1.0f128"))
    val- true = abs (cos ($extval (float128, "1.57079632675"))) < ($extval (float128, "1E-10f128"))
    val- true = abs (tan ($extval (float128, "0.785398163375")) - ($extval (float128, "1.0f128"))) < ($extval (float128, "1E-10f128"))
    val- true = abs (asin ($extval (float128, "1.0f128")) - ($extval (float128, "1.57079632675"))) < ($extval (float128, "1E-10f128"))
    val- true = abs (acos ($extval (float128, "0.0f128")) - ($extval (float128, "1.57079632675"))) < ($extval (float128, "1E-10f128"))
    val- true = abs (atan ($extval (float128, "1.0f128")) - ($extval (float128, "0.785398163375"))) < ($extval (float128, "1E-10f128"))
    val- true = abs (atan2 (($extval (float128, "3.0f128")), ($extval (float128, "4.0f128"))) - ($extval (float128, "0.643501108793284"))) < ($extval (float128, "1E-10f128"))
  in
  end

fn
test11 () : void =
  let
    val- true = abs (M_Ef128 - $extval (float128, "M_E")) < ($extval (float128, "0.000001f128"))
    val- true = abs (M_LOG2Ef128 - $extval (float128, "M_LOG2E")) < ($extval (float128, "0.000001f128"))
    val- true = abs (M_LOG10Ef128 - $extval (float128, "M_LOG10E")) < ($extval (float128, "0.000001f128"))
    val- true = abs (M_LN2f128 - $extval (float128, "M_LN2")) < ($extval (float128, "0.000001f128"))
    val- true = abs (M_LN10f128 - $extval (float128, "M_LN10")) < ($extval (float128, "0.000001f128"))
    val- true = abs (M_PIf128 - $extval (float128, "M_PI")) < ($extval (float128, "0.000001f128"))
    val- true = abs (M_PI_2f128 - $extval (float128, "M_PI_2")) < ($extval (float128, "0.000001f128"))
    val- true = abs (M_PI_4f128 - $extval (float128, "M_PI_4")) < ($extval (float128, "0.000001f128"))
    val- true = abs (M_1_PIf128 - $extval (float128, "M_1_PI")) < ($extval (float128, "0.000001f128"))
    val- true = abs (M_2_PIf128 - $extval (float128, "M_2_PI")) < ($extval (float128, "0.000001f128"))
    val- true = abs (M_2_SQRTPIf128 - $extval (float128, "M_2_SQRTPI")) < ($extval (float128, "0.000001f128"))
    val- true = abs (M_SQRT2f128 - $extval (float128, "M_SQRT2")) < ($extval (float128, "0.000001f128"))
    val- true = abs (M_SQRT1_2f128 - $extval (float128, "M_SQRT1_2")) < ($extval (float128, "0.000001f128"))
  in
  end

fn
test12 () : void =
  let
    val- true = abs (mathconst_E () - $extval (float128, "M_E")) < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_LOG2E () - $extval (float128, "M_LOG2E")) < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_LOG10E () - $extval (float128, "M_LOG10E")) < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_LN2 () - $extval (float128, "M_LN2")) < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_LN10 () - $extval (float128, "M_LN10")) < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_PI () - $extval (float128, "M_PI")) < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_PI_2 () - $extval (float128, "M_PI_2")) < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_PI_4 () - $extval (float128, "M_PI_4")) < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_1_PI () - $extval (float128, "M_1_PI")) < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_2_PI () - $extval (float128, "M_2_PI")) < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_2_SQRTPI () - $extval (float128, "M_2_SQRTPI")) < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_SQRT2 () - $extval (float128, "M_SQRT2")) < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_SQRT1_2 () - $extval (float128, "M_SQRT1_2")) < ($extval (float128, "0.000001f128"))
  in
  end

fn
test13 () : void =
  let
    val- true = g0float_neg ($extval (float128, "3.0f128")) = ~($extval (float128, "3.0f128"))
    val- true = ~ (($extval (float128, "2.0f128")) + ($extval (float128, "1.0f128"))) = ~($extval (float128, "3.0f128"))

    val- true = fabs ($extval (float128, "3.0f128")) = ($extval (float128, "3.0f128"))
    val- true = fabs ~($extval (float128, "3.0f128")) = ($extval (float128, "3.0f128"))
    val- true = fabs ($extval (float128, "3.0f128")) = abs ($extval (float128, "3.0f128"))
    val- true = fabs ~($extval (float128, "3.0f128")) = abs ~($extval (float128, "3.0f128"))

    val- true = ($extval (float128, "1.0f128")) + ($extval (float128, "2.0f128")) = ($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "2.0f128")) + ($extval (float128, "1.0f128")) = ($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "3.0f128")) - ($extval (float128, "1.0f128")) = ($extval (float128, "2.0f128"))
    val- true = ($extval (float128, "1.0f128")) - ($extval (float128, "3.0f128")) = ~($extval (float128, "2.0f128"))
    val- true = ($extval (float128, "3.0f128")) * ($extval (float128, "2.0f128")) = ($extval (float128, "6.0f128"))
    val- true = ($extval (float128, "2.0f128")) * ($extval (float128, "3.0f128")) = ($extval (float128, "6.0f128"))
    val- true = ($extval (float128, "6.0f128")) / ($extval (float128, "2.0f128")) = ($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "6.0f128")) / ($extval (float128, "3.0f128")) = ($extval (float128, "2.0f128"))
    val- true = ($extval (float128, "6.0f128")) mod ($extval (float128, "2.0f128")) = ($extval (float128, "0.0f128"))
    val- true = ($extval (float128, "6.0f128")) mod ($extval (float128, "3.0f128")) = ($extval (float128, "0.0f128"))
    val- true = ($extval (float128, "2.0f128")) * (($extval (float128, "3.0f128")) / ($extval (float128, "2.0f128"))) = ($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "3.0f128")) mod ($extval (float128, "2.0f128")) = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "2.0f128")) mod ($extval (float128, "3.0f128")) = ($extval (float128, "2.0f128"))

    val- true = fma (($extval (float128, "2.0f128")), ($extval (float128, "3.0f128")), ($extval (float128, "1.0f128"))) = ($extval (float128, "7.0f128"))
  in
  end

fn
test14 () : void =
  let
    val- true = ~($extval (float128, "3.0f128")) < ($extval (float128, "3.0f128"))
    val- false = ~($extval (float128, "3.0f128")) > ($extval (float128, "3.0f128"))
    val- true = ~($extval (float128, "3.0f128")) <= ($extval (float128, "3.0f128"))
    val- false = ~($extval (float128, "3.0f128")) >= ($extval (float128, "3.0f128"))
    val- false = ~($extval (float128, "3.0f128")) = ($extval (float128, "3.0f128"))
    val- true = ~($extval (float128, "3.0f128")) <> ($extval (float128, "3.0f128"))
    val- true = ~($extval (float128, "3.0f128")) != ($extval (float128, "3.0f128"))

    val- false = ($extval (float128, "3.0f128")) < ~($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "3.0f128")) > ~($extval (float128, "3.0f128"))
    val- false = ($extval (float128, "3.0f128")) <= ~($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "3.0f128")) >= ~($extval (float128, "3.0f128"))
    val- false = ($extval (float128, "3.0f128")) = ~($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "3.0f128")) <> ~($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "3.0f128")) != ~($extval (float128, "3.0f128"))

    val- false = ($extval (float128, "3.0f128")) < ($extval (float128, "3.0f128"))
    val- false = ($extval (float128, "3.0f128")) > ($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "3.0f128")) <= ($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "3.0f128")) >= ($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "3.0f128")) = ($extval (float128, "3.0f128"))
    val- false = ($extval (float128, "3.0f128")) <> ($extval (float128, "3.0f128"))
    val- false = ($extval (float128, "3.0f128")) != ($extval (float128, "3.0f128"))
  in
  end

fn
test15 () : void =
  let
    val- true = isltz ~($extval (float128, "3.0f128"))
    val- true = isltez ~($extval (float128, "3.0f128"))
    val- false = isgtz ~($extval (float128, "3.0f128"))
    val- false = isgtez ~($extval (float128, "3.0f128"))
    val- false = iseqz ~($extval (float128, "3.0f128"))
    val- true = isneqz ~($extval (float128, "3.0f128"))

    val- false = isltz ($extval (float128, "0.0f128"))
    val- true = isltez ($extval (float128, "0.0f128"))
    val- false = isgtz ($extval (float128, "0.0f128"))
    val- true = isgtez ($extval (float128, "0.0f128"))
    val- true = iseqz ($extval (float128, "0.0f128"))
    val- false = isneqz ($extval (float128, "0.0f128"))

    val- false = isltz ($extval (float128, "3.0f128"))
    val- false = isltez ($extval (float128, "3.0f128"))
    val- true = isgtz ($extval (float128, "3.0f128"))
    val- true = isgtez ($extval (float128, "3.0f128"))
    val- false = iseqz ($extval (float128, "3.0f128"))
    val- true = isneqz ($extval (float128, "3.0f128"))
  in
  end

fn
test16 () : void =
  let
    val- true = min (~($extval (float128, "3.0f128")), ($extval (float128, "3.0f128"))) = ~($extval (float128, "3.0f128"))
    val- true = min (($extval (float128, "3.0f128")), ~($extval (float128, "3.0f128"))) = ~($extval (float128, "3.0f128"))

    val- true = max (~($extval (float128, "3.0f128")), ($extval (float128, "3.0f128"))) = ($extval (float128, "3.0f128"))
    val- true = max (($extval (float128, "3.0f128")), ~($extval (float128, "3.0f128"))) = ($extval (float128, "3.0f128"))
  in
  end

fn
test17 () : void =
  let
    val- true = succ ~($extval (float128, "3.0f128")) = ~($extval (float128, "2.0f128"))
    val- true = succ ($extval (float128, "3.0f128")) = ($extval (float128, "4.0f128"))

    val- true = pred ~($extval (float128, "3.0f128")) = ~($extval (float128, "4.0f128"))
    val- true = pred ($extval (float128, "3.0f128")) = ($extval (float128, "2.0f128"))
  in
  end

fn
test18 () : void =
  let
    val- true = g0float_npow (($extval (float128, "0.0f128")), 0) = ($extval (float128, "1.0f128"))
    val- true = g0float_npow (($extval (float128, "1.0f128")), 0) = ($extval (float128, "1.0f128"))
    val- true = g0float_npow (($extval (float128, "2.0f128")), 0) = ($extval (float128, "1.0f128"))
    val- true = g0float_npow (($extval (float128, "3.0f128")), 0) = ($extval (float128, "1.0f128"))
    val- true = g0float_npow (($extval (float128, "4.0f128")), 0) = ($extval (float128, "1.0f128"))

    val- true = g0float_npow (($extval (float128, "0.0f128")), 1) = ($extval (float128, "0.0f128"))
    val- true = g0float_npow (($extval (float128, "1.0f128")), 1) = ($extval (float128, "1.0f128"))
    val- true = g0float_npow (($extval (float128, "2.0f128")), 1) = ($extval (float128, "2.0f128"))
    val- true = g0float_npow (($extval (float128, "3.0f128")), 1) = ($extval (float128, "3.0f128"))
    val- true = g0float_npow (($extval (float128, "4.0f128")), 1) = ($extval (float128, "4.0f128"))

    val- true = g0float_npow (($extval (float128, "0.0f128")), 2) = ($extval (float128, "0.0f128"))
    val- true = g0float_npow (($extval (float128, "1.0f128")), 2) = ($extval (float128, "1.0f128"))
    val- true = g0float_npow (($extval (float128, "2.0f128")), 2) = ($extval (float128, "4.0f128"))
    val- true = g0float_npow (($extval (float128, "3.0f128")), 2) = ($extval (float128, "9.0f128"))
    val- true = g0float_npow (($extval (float128, "4.0f128")), 2) = ($extval (float128, "16.0f128"))

    val- true = g0float_npow (($extval (float128, "0.0f128")), 3) = ($extval (float128, "0.0f128"))
    val- true = g0float_npow (($extval (float128, "1.0f128")), 3) = ($extval (float128, "1.0f128"))
    val- true = g0float_npow (($extval (float128, "2.0f128")), 3) = ($extval (float128, "8.0f128"))
    val- true = g0float_npow (($extval (float128, "3.0f128")), 3) = ($extval (float128, "27.0f128"))
    val- true = g0float_npow (($extval (float128, "4.0f128")), 3) = ($extval (float128, "64.0f128"))

    val- true = ($extval (float128, "0.0f128")) ** 0 = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "1.0f128")) ** 0 = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "2.0f128")) ** 0 = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "3.0f128")) ** 0 = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "4.0f128")) ** 0 = ($extval (float128, "1.0f128"))

    val- true = ($extval (float128, "0.0f128")) ** 1 = ($extval (float128, "0.0f128"))
    val- true = ($extval (float128, "1.0f128")) ** 1 = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "2.0f128")) ** 1 = ($extval (float128, "2.0f128"))
    val- true = ($extval (float128, "3.0f128")) ** 1 = ($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "4.0f128")) ** 1 = ($extval (float128, "4.0f128"))

    val- true = ($extval (float128, "0.0f128")) ** 2 = ($extval (float128, "0.0f128"))
    val- true = ($extval (float128, "1.0f128")) ** 2 = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "2.0f128")) ** 2 = ($extval (float128, "4.0f128"))
    val- true = ($extval (float128, "3.0f128")) ** 2 = ($extval (float128, "9.0f128"))
    val- true = ($extval (float128, "4.0f128")) ** 2 = ($extval (float128, "16.0f128"))

    val- true = ($extval (float128, "0.0f128")) ** 3 = ($extval (float128, "0.0f128"))
    val- true = ($extval (float128, "1.0f128")) ** 3 = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "2.0f128")) ** 3 = ($extval (float128, "8.0f128"))
    val- true = ($extval (float128, "3.0f128")) ** 3 = ($extval (float128, "27.0f128"))
    val- true = ($extval (float128, "4.0f128")) ** 3 = ($extval (float128, "64.0f128"))

    val- true = pow (($extval (float128, "0.0f128")), ($extval (float128, "0.0f128"))) = ($extval (float128, "1.0f128"))
    val- true = pow (($extval (float128, "1.0f128")), ($extval (float128, "0.0f128"))) = ($extval (float128, "1.0f128"))
    val- true = pow (($extval (float128, "2.0f128")), ($extval (float128, "0.0f128"))) = ($extval (float128, "1.0f128"))
    val- true = pow (($extval (float128, "3.0f128")), ($extval (float128, "0.0f128"))) = ($extval (float128, "1.0f128"))
    val- true = pow (($extval (float128, "4.0f128")), ($extval (float128, "0.0f128"))) = ($extval (float128, "1.0f128"))

    val- true = pow (($extval (float128, "0.0f128")), ($extval (float128, "1.0f128"))) = ($extval (float128, "0.0f128"))
    val- true = pow (($extval (float128, "1.0f128")), ($extval (float128, "1.0f128"))) = ($extval (float128, "1.0f128"))
    val- true = pow (($extval (float128, "2.0f128")), ($extval (float128, "1.0f128"))) = ($extval (float128, "2.0f128"))
    val- true = pow (($extval (float128, "3.0f128")), ($extval (float128, "1.0f128"))) = ($extval (float128, "3.0f128"))
    val- true = pow (($extval (float128, "4.0f128")), ($extval (float128, "1.0f128"))) = ($extval (float128, "4.0f128"))

    val- true = pow (($extval (float128, "0.0f128")), ($extval (float128, "2.0f128"))) = ($extval (float128, "0.0f128"))
    val- true = pow (($extval (float128, "1.0f128")), ($extval (float128, "2.0f128"))) = ($extval (float128, "1.0f128"))
    val- true = pow (($extval (float128, "2.0f128")), ($extval (float128, "2.0f128"))) = ($extval (float128, "4.0f128"))
    val- true = pow (($extval (float128, "3.0f128")), ($extval (float128, "2.0f128"))) = ($extval (float128, "9.0f128"))
    val- true = pow (($extval (float128, "4.0f128")), ($extval (float128, "2.0f128"))) = ($extval (float128, "16.0f128"))

    val- true = pow (($extval (float128, "0.0f128")), ($extval (float128, "3.0f128"))) = ($extval (float128, "0.0f128"))
    val- true = pow (($extval (float128, "1.0f128")), ($extval (float128, "3.0f128"))) = ($extval (float128, "1.0f128"))
    val- true = pow (($extval (float128, "2.0f128")), ($extval (float128, "3.0f128"))) = ($extval (float128, "8.0f128"))
    val- true = pow (($extval (float128, "3.0f128")), ($extval (float128, "3.0f128"))) = ($extval (float128, "27.0f128"))
    val- true = pow (($extval (float128, "4.0f128")), ($extval (float128, "3.0f128"))) = ($extval (float128, "64.0f128"))

    val- true = ($extval (float128, "0.0f128")) ** ($extval (float128, "0.0f128")) = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "1.0f128")) ** ($extval (float128, "0.0f128")) = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "2.0f128")) ** ($extval (float128, "0.0f128")) = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "3.0f128")) ** ($extval (float128, "0.0f128")) = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "4.0f128")) ** ($extval (float128, "0.0f128")) = ($extval (float128, "1.0f128"))

    val- true = ($extval (float128, "0.0f128")) ** ($extval (float128, "1.0f128")) = ($extval (float128, "0.0f128"))
    val- true = ($extval (float128, "1.0f128")) ** ($extval (float128, "1.0f128")) = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "2.0f128")) ** ($extval (float128, "1.0f128")) = ($extval (float128, "2.0f128"))
    val- true = ($extval (float128, "3.0f128")) ** ($extval (float128, "1.0f128")) = ($extval (float128, "3.0f128"))
    val- true = ($extval (float128, "4.0f128")) ** ($extval (float128, "1.0f128")) = ($extval (float128, "4.0f128"))

    val- true = ($extval (float128, "0.0f128")) ** ($extval (float128, "2.0f128")) = ($extval (float128, "0.0f128"))
    val- true = ($extval (float128, "1.0f128")) ** ($extval (float128, "2.0f128")) = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "2.0f128")) ** ($extval (float128, "2.0f128")) = ($extval (float128, "4.0f128"))
    val- true = ($extval (float128, "3.0f128")) ** ($extval (float128, "2.0f128")) = ($extval (float128, "9.0f128"))
    val- true = ($extval (float128, "4.0f128")) ** ($extval (float128, "2.0f128")) = ($extval (float128, "16.0f128"))

    val- true = ($extval (float128, "0.0f128")) ** ($extval (float128, "3.0f128")) = ($extval (float128, "0.0f128"))
    val- true = ($extval (float128, "1.0f128")) ** ($extval (float128, "3.0f128")) = ($extval (float128, "1.0f128"))
    val- true = ($extval (float128, "2.0f128")) ** ($extval (float128, "3.0f128")) = ($extval (float128, "8.0f128"))
    val- true = ($extval (float128, "3.0f128")) ** ($extval (float128, "3.0f128")) = ($extval (float128, "27.0f128"))
    val- true = ($extval (float128, "4.0f128")) ** ($extval (float128, "3.0f128")) = ($extval (float128, "64.0f128"))
  in
  end

fn
test19 () : void =
  let
    val- true = g0float_radix<flt128knd> () = 2
  in
  end

fn
test20 () : void =
  let
    val- true = g0float_mant_dig<flt128knd> () = $extval (Int, "FLT128_MANT_DIG")
    val- true = g0float_decimal_dig<flt128knd> () = $extval (Int, "FLT128_DECIMAL_DIG")
    val- true = g0float_dig<flt128knd> () = $extval (Int, "FLT128_DIG")
    val- true = g0float_min_exp<flt128knd> () = $extval (Int, "FLT128_MIN_EXP")
    val- true = g0float_min_10_exp<flt128knd> () = $extval (Int, "FLT128_MIN_10_EXP")
    val- true = g0float_max_exp<flt128knd> () = $extval (Int, "FLT128_MAX_EXP")
    val- true = g0float_max_10_exp<flt128knd> () = $extval (Int, "FLT128_MAX_10_EXP")
    val- true = g0float_max_value<flt128knd> () = $extval (float128, "FLT128_MAX")
    val- true = g0float_min_value<flt128knd> () = $extval (float128, "FLT128_MIN")
    val- true = g0float_true_min_value<flt128knd> () = $extval (float128, "FLT128_TRUE_MIN")
  in
  end

fn
test21 () : void =
  let
      var buf : @[byte][100]

      val m = g0float_unsafe_strfrom (buf, i2sz 100, "%.4f", $extval (float128, "1.2345f128"))
      val- true = $UN.cast{string} buf = "1.2345"

      val s = g0float_strfrom ("%.4f", $extval (float128, "1.2345f128"))
      val- true = s = "1.2345"
      val () = free s
  in
  end

fn
test22 () : void =
  let
    typedef c_char_p = $extype"char *"

    var p : c_char_p
    val x : float128 = g0float_unsafe_strto ($UN.cast{ptr} "1.2345", addr@ p)
    val- true = abs (x - $extval (float128, "1.2345f128")) <= $extval (float128, "0.0000001f128")

    val s : String = "x = 1.2345; /* example */"
    val @(x, j) = g0float_strto<flt128knd> (s, i2sz 4)
    val- true = abs (x - $extval (float128, "1.2345f128")) <= $extval (float128, "0.0000001f128")
    val- true = string_isnot_atend (s, j)
    val- true = s[j] = ';'
  in
  end

fn
test23 () : void =
  let
    val- true = g0float_g0int_pow ($extval (float128, "2.0f128"), 3) = $extval (float128, "8.0f128")
    val- true = g0float_g0int_pow ($extval (float128, "2.0f128"), ~3) = $extval (float128, "0.125f128")
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
    0
  end

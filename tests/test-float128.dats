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


    val- true = abs (mathconst_EULER () - $extval (float128, "0.57721566490153286060651209008240243104215933593992f128"))
                        < ($extval (float128, "0.000001f128"))
    val- true = abs (mathconst_CATALAN () - $extval (float128, "0.915965594177219015054603514932384110774f128"))
                        < ($extval (float128, "0.000001f128"))
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

    var p : c_char_p
    var x : float128 = g0i2f 0
    val () = g0float_unsafe_strto_replace (x, $UN.cast{ptr} "1.2345", addr@ p)
    val- true = abs (x - $extval (float128, "1.2345f128")) <= $extval (float128, "0.0000001f128")

    val s : String = "x = 1.2345; /* example */"
    val @(x, j) = g0float_strto<flt128knd> (s, i2sz 4)
    val- true = abs (x - $extval (float128, "1.2345f128")) <= $extval (float128, "0.0000001f128")
    val- true = string_isnot_atend (s, j)
    val- true = s[j] = ';'

    val s : String = "x = 1.2345; /* example */"
    var x : float128 = g0i2f 0
    var j : size_t
    val () = g0float_strto_replace (x, j, s, i2sz 4)
    val- true = abs (x - $extval (float128, "1.2345f128")) <= $extval (float128, "0.0000001f128")
    val- true = string_isnot_atend (s, j)
    val- true = s[j] = ';'
  in
  end

fn
test23 () : void =
  let
    val- true = g0float_int_pow ($extval (float128, "2.0f128"), 3) = $extval (float128, "8.0f128")
    val- true = g0float_int_pow ($extval (float128, "2.0f128"), ~3) = $extval (float128, "0.125f128")

    val- true = ($extval (float128, "2.0f128") ** 3) = $extval (float128, "8.0f128")
    val- true = ($extval (float128, "2.0f128") ** ~3) = $extval (float128, "0.125f128")
  in
  end

fn
test24 () : void =
  let
    val- true = huge_val<flt128knd> () > $extval (float128, "1e4900f128")
    val- true = ~huge_val<flt128knd> () < $extval (float128, "-1e4900f128")
    val- true = infinity<flt128knd> () > $extval (float128, "1e4900f128")
    val- true = ~infinity<flt128knd> () < $extval (float128, "-1e4900f128")

    val- true = isfinite ($extval (float128, "1.2345f128"))
    val- true = isnormal ($extval (float128, "1.2345f128"))
    val- false = isnan ($extval (float128, "1.2345f128"))
    val- true = isinf ($extval (float128, "1.2345f128")) = 0

    val- false = isfinite (g0float_nan<flt128knd> ())
    val- false = isnormal (g0float_nan<flt128knd> ())
    val- true = isnan (g0float_nan<flt128knd> ())
    val- true = isinf (g0float_nan<flt128knd> ()) = 0

    val- false = isfinite (g0float_snan<flt128knd> ())
    val- false = isnormal (g0float_snan<flt128knd> ())
    val- true = isnan (g0float_snan<flt128knd> ())
    val- true = isinf (g0float_snan<flt128knd> ()) = 0

    val- false = isfinite (infinity<flt128knd> ())
    val- false = isnormal (infinity<flt128knd> ())
    val- false = isnan (infinity<flt128knd> ())
    val- true = isinf (infinity<flt128knd> ()) = 1
    val- true = isinf (~infinity<flt128knd> ()) = ~1
  in
  end

fn
test25 () : void =
  let
    val () = println! ()

    val () = println! ("g0float_mant_dig<flt128knd> () = ", g0float_mant_dig<flt128knd> ())
    val- true = g0float_mant_dig<flt128knd> () = 113

    val () = println! ("g0float_decimal_dig<flt128knd> () = ", g0float_decimal_dig<flt128knd> ())
    val- true = g0float_decimal_dig<flt128knd> () = 36

    val () = println! ("g0float_dig<flt128knd> () = ", g0float_dig<flt128knd> ())
    val- true = g0float_dig<flt128knd> () = 33

    val () = println! ("g0float_min_exp<flt128knd> () = ", g0float_min_exp<flt128knd> ())
    val- true = g0float_min_exp<flt128knd> () = ~16381

    val () = println! ("g0float_min_10_exp<flt128knd> () = ", g0float_min_10_exp<flt128knd> ())
    val- true = g0float_min_10_exp<flt128knd> () = ~4931

    val () = println! ("g0float_max_exp<flt128knd> () = ", g0float_max_exp<flt128knd> ())
    val- true = g0float_max_exp<flt128knd> () = 16384

    val () = println! ("g0float_max_10_exp<flt128knd> () = ", g0float_max_10_exp<flt128knd> ())
    val- true = g0float_max_10_exp<flt128knd> () = 4932

    val () = println! ("g0float_max_value<flt128knd> () = ", g0float_max_value<flt128knd> ())
    val- true = g0float_max_value<flt128knd> () = $extval (float128, "1189731495357231765085759326628007016196469052641694045529698884212163579755312392324974012848462073525902033564749126859755265433573804462672698751945261490853461958725021262845865799405404493574681566096686172574953791792292256220777095858112702436475442537092608935138247345677279593806773692330094615746119725784172889892521939920757654204864565673356452247278152288867700638935595456496699511441752909606878513250948311396886100526833092128683974752192266386791880873694343077348155564101669971138512786874753496996549221727686770196551512812712488289469952298031867469924683981576664562667786719061499639630341657098305425237220876664630087808767256182803220212219924852375903049520911395910918921205273496768588119030111593018789368039232011671404175845108854706965215605777113516257404818817695075025715299705916714352103671782759119316034498392169720631800164034124698918142227577300459309880454715179606299895507583075851195185857971173167676966057998899352631885417716295302014668802384075846036226606480142977595407135050379808649130157164024060311786908796372510335873512774795275748595417572920936651398752709055215663939505589207804914540432978557623565645991208599669097180808881920063722771431218489011922209679053545963628417326002439732802939524313786668514027381434321036636571171670423586472759561231970793967839279147282720195377060602122638457883204809341717526809639253539447730280863675704796054050525162959099932535265586464682793821550087166946662209865086040990507131145474267411042839542322762994938759613112743837192839682676257555388372814490845395747128162065871588219108887240116651361962050800029176299938826082417547516732269930473133261258921845516815235455354310458114528303607394526100730578774092094736822286015459361126642549541799645333882549670764145955017051330800061253865140180153211929361456500343514792890205532021760061882232615736553377294980974059590520187961459799386741513028505934410453603480192383349321115171811051004108592830991811382552909064873029533418691087118107895004426881765865961841419267486232005929789956207494587649901662172318722999484512325826087031561936383689740686505279775296789331613683822798597040651600524129025149894873153196942095056670847466927644812596506700129443579512479230621373978088731257089799622902183824105412930483065603459863120371744282301377070153823878609951218937542956964157950988060608985782910656238116142203574104757451828170804875257446204128348513829082731722364189380493588338947664370623279820755831646205417488393062838201789547219543194450902113699925965376908192792152122212824578879336506875288617303469517112245451315447164280392523574962804175375927948971096983905242318797695347043690474223813266505639761164438844266531364626851219633994434154098562127395936184421821444273431534507860161614287022720984061569660333372788241037131538077377480152670583257920535569973318188112685673318997967497786786001251403873023920127717626858627038170562807276699687356274072773403132694104831615879354395811585825112837841563222761623334459188131537882355732483030085976890382969734476214593428191212717141333047577867552218517431064848760373196290310124466145087078377140528533048684204278799596652514009368964527494988719996088230065668196236298805733689960371306226158464997243490564472254071897564144128539839986096045563264771285585066304177995720101744844387158329767375560416207800878830072072413908657855667239546369357775781344288195989176313356856417845434232814886744226746707066979755577121788798468777700116472954103621810567107869855646414713502627836321256957407217461738363552424248762436478085351810995749293238174081331905048144612700905541425702220302537611494824228765324577933778519818778697340282580912780674979058938062556856001076057705982166686824756037569615760497619819482052758118532729333127733603742149847001463931981340719681330844408263017545241644293372483217234561694263937855759294448662979095419227451801588425977869694026601427919655168415895923043115191751872713346095752634608254475988154162254952597853199039645883742199236387610395830948074365988397707849632252080920941206268114832425403540515474312327876180802357701527842702008781378306569508588571830140611098042683009530862797403015355464377406249853964481000402231771665700893607521804084523668568649103258862666293372472441435563520595461701042390500795615834505944837326652542467444364861499184275097485253621979537504128523848241127715641240965261646703516395599407360083455079665191393229410544185167999099787655424462558900874388405649169453726739312260234815543297842308646072190147948072928456725835039546121182133640777769925841807579051735838823112759622714067509669913645288281894558925612972425252452248453502562347348900936766966136332741088135837550717443838484760651019872222926016920811114616937143207743488504602012776364256746872315205952601072228970686460932435222754496341763535189105548847634608972381760403137363968.000000f128")

    val s = strptr2string (g0float_strfrom ("%.10e", g0float_min_value<flt128knd> ()))
    val () = println! ("g0float_min_value<flt128knd> () = ", s)
    val- true = s = "3.3621031431e-4932"

    val s = strptr2string (g0float_strfrom ("%.10e", g0float_true_min_value<flt128knd> ()))
    val () = println! ("g0float_true_min_value<flt128knd> () = ", s)
    val- true = s = "6.4751751194e-4966"
  in
  end

(* fn *)
(* test26 () : void = *)
(*   let *)
(*     var x : float128 = g0i2f 5 *)
(*     val () = negate x *)
(*     val- true = x = ((g0i2f ~5) : float128) *)
(*   in *)
(*   end *)

(* fn *)
(* test27 () : void = *)
(*   let *)
(*     var x : float128 = g0i2f 5 *)
(*     val- true = x = ((g0i2f 5) : float128) *)
(*     val () = x <- 6.0 *)
(*     val- true = x = ((g0i2f 6) : float128) *)
(*     val () = x <- 7 *)
(*     val- true = x = ((g0i2f 7) : float128) *)
(*   in *)
(*   end *)

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
    (* test26 (); *)
    (* test27 (); *)
    0
  end

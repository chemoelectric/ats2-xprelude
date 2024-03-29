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

staload "xprelude/SATS/fixed32p32.sats"
staload _ = "xprelude/DATS/fixed32p32.dats"

staload "xprelude/SATS/exrat.sats"
staload _ = "xprelude/DATS/exrat.dats"

staload "xprelude/SATS/mpfr.sats"
staload _ = "xprelude/DATS/mpfr.dats"

(* Significand sizes, in bits. *)
#define SINGLE_PREC 24
#define DOUBLE_PREC 53
#define QUAD_PREC 113
#define OCTUPLE_PREC 237

val euler_constant = mpfr_make "0.57721566490153286060651209008240243"

fn
test1 () : void =
  let
    var v1 = mpfr_make QUAD_PREC
    var v2 = mpfr_make QUAD_PREC
    val () = replace (v1, 1.2345)
    val () = replace (v2, 0.0000001)

    val s : String = "x = 1.2345; /* example */"
    val @(x, j) = g0float_strto<mpfrknd> (s, i2sz 4)
    val- true = abs (x - v1) <= v2
    val- true = string_isnot_atend (s, j)
    val- true = s[j] = ';'

    val- false = isnan x
    val- true = isnormal x
    val- true = isfinite x
    val- 0 = isinf x

    val- true = abs (x - mpfr_make ("1.2345", OCTUPLE_PREC)) <= mpfr_make ("0.0000001", QUAD_PREC)
    val- true = abs (x - mpfr_make ("1.2345")) <= mpfr_make ("0.00001")
    val- true = mpfr_make "1234" = mpfr_make "1234.0"

    var v3 = mpfr_make ()

    val- true = isnan v3
    val- false = isnormal v3
    val- false = isfinite v3
    val- 0 = isinf v3

    val v4 = mpfr_make "1" / mpfr_make "0"

    val- false = isnan v4
    val- false = isnormal v4
    val- false = isfinite v4
    val- 1 = isinf v4
    val- 1 = ~isinf (~v4)

    val v5 : mpfr = infinity ()

    val- false = isnan v5
    val- false = isnormal v5
    val- false = isfinite v5
    val- 1 = isinf v5

    val v6 : mpfr = huge_val ()

    val- false = isnan v6
    val- false = isnormal v6
    val- false = isfinite v6
    val- 1 = isinf v6

    val v7 : mpfr = g0float_nan ()

    val- true = isnan v7
    val- false = isnormal v7
    val- false = isfinite v7
    val- 0 = isinf v7

    var x : mpfr = infinity ()
    val () = nan_replace x

    val- true = isnan x
    val- false = isnormal x
    val- false = isfinite x
    val- 0 = isinf x

    val v8 = mpfr_make ()

    val- true = isnan v8
    val- false = isnormal v8
    val- false = isfinite v8
    val- 0 = isinf v8

    val- true =
      begin
        try
          let 
            val _ = mpfr_make ""
          in
            false
          end
        with
        | ~ IllegalArgExn msg => true
      end : bool

    val- true =
      begin
        try
          let 
            val _ = mpfr_make "1234|"
          in
            false
          end
        with
        | ~ IllegalArgExn msg => true
      end : bool

    val- true =
      begin
        try
          let 
            val _ = mpfr_make "1234 "
          in
            false
          end
        with
        | ~ IllegalArgExn msg => true
      end : bool
  in
  end

fn
test2 () : void =
  let
    (* Negatives. *)
    val- true = ~mpfr_make "123" = mpfr_make "-123"

    (* Absolute values. *)
    val- true = abs (mpfr_make "123") = mpfr_make "123"
    val- true = abs (mpfr_make "-123") = mpfr_make "123"

    (* Reciprocals. *)
    val- true = reciprocal (mpfr_make "2") = mpfr_make "0.5"
    val- true = reciprocal (mpfr_make "-2") = mpfr_make "-0.5"
    val- 1 = isinf (reciprocal (mpfr_make "0"))

    (* Radicals. *)
    val- true = sqrt (mpfr_make "16") = mpfr_make "4"
    val- true = cbrt (mpfr_make "64") = mpfr_make "4"

    (* Exponentials. *)
    val- true = abs (exp (mpfr_make "1") - mpfr_make "2.718281828459") < mpfr_make "0.000001"
    val- true = abs (expm1 (mpfr_make "1") - mpfr_make "1.718281828459") < mpfr_make "0.000001"
    val- true = exp2 (mpfr_make "1") = mpfr_make "2"
    val- true = exp2m1 (mpfr_make "1") = mpfr_make "1"
    val- true = exp10 (mpfr_make "1") = mpfr_make "10"
    val- true = exp10m1 (mpfr_make "1") = mpfr_make "9"

    (* Logarithms. *)
    val- true = abs (log (mpfr_make "2.718281828459") - mpfr_make "1") < mpfr_make "0.000001"
    val- true = abs (log1p (mpfr_make "1.718281828459") - mpfr_make "1") < mpfr_make "0.000001"
    val- true = abs (logp1 (mpfr_make "1.718281828459") - mpfr_make "1") < mpfr_make "0.000001"
    val- true = log2 (mpfr_make "2") = mpfr_make "1"
    val- true = log2p1 (mpfr_make "1") = mpfr_make "1"
    val- true = log10 (mpfr_make "10") = mpfr_make "1"
    val- true = log10p1 (mpfr_make "9") = mpfr_make "1"

    (* Circular functions. *)
    val- true = abs (sin (mpfr_make "0.523598775598") - mpfr_make "0.5") < mpfr_make "0.000001"
    val- true = abs (sinpi (mpfr_make "0.1666666666667") - mpfr_make "0.5") < mpfr_make "0.000001"
    val- true = abs (cos (mpfr_make "0.523598775598") - mpfr_make "0.866025403784") < mpfr_make "0.000001"
    val- true = abs (cospi (mpfr_make "0.1666666666667") - mpfr_make "0.866025403784") < mpfr_make "0.000001"
    val- true = abs (tan (mpfr_make "0.523598775598") - mpfr_make "0.5773502691896") < mpfr_make "0.000001"
    val- true = abs (tanpi (mpfr_make "0.1666666666667") - mpfr_make "0.5773502691896") < mpfr_make "0.000001"

    (* Inverse circular functions. *)
    val- true = abs (asin (mpfr_make "0.5") - mpfr_make "0.523598775598") < mpfr_make "0.000001"
    val- true = abs (asinpi (mpfr_make "0.5") - mpfr_make "0.1666666666667") < mpfr_make "0.000001"
    val- true = abs (acos (mpfr_make "0.866025403784") - mpfr_make "0.523598775598") < mpfr_make "0.000001"
    val- true = abs (acospi (mpfr_make "0.866025403784") - mpfr_make "0.1666666666667") < mpfr_make "0.000001"
    val- true = abs (atan (mpfr_make "0.5773502691896") - mpfr_make "0.523598775598") < mpfr_make "0.000001"
    val- true = abs (atanpi (mpfr_make "0.5773502691896") - mpfr_make "0.1666666666667") < mpfr_make "0.000001"

    (* Hyperbolic functions. *)
    val- true = abs (sinh (mpfr_make "1") - mpfr_make "1.1752011936438") < mpfr_make "0.000001"
    val- true = abs (cosh (mpfr_make "1") - mpfr_make "1.5430806348152") < mpfr_make "0.000001"
    val- true = abs (tanh (mpfr_make "1") - mpfr_make "0.76159415595576") < mpfr_make "0.000001"

    (* Inverse hyperbolic functions. *)
    val- true = abs (asinh (mpfr_make "1.1752011936438") - mpfr_make "1") < mpfr_make "0.000001"
    val- true = abs (acosh (mpfr_make "1.5430806348152") - mpfr_make "1") < mpfr_make "0.000001"
    val- true = abs (atanh (mpfr_make "0.76159415595576") - mpfr_make "1") < mpfr_make "0.000001"

    (* Error function. *)
    val- true = abs (erf (mpfr_make "1") - mpfr_make "0.84270079294971") < mpfr_make "0.000001"
    val- true = abs (erfc (mpfr_make "1") - mpfr_make "0.157299207050285") < mpfr_make "0.000001"

    (* Gamma function. *)
    val- true = abs (lgamma (mpfr_make "6") - mpfr_make "4.787491742782046") < mpfr_make "0.000001"
    val- true = tgamma (mpfr_make "6") = mpfr_make "120"
    val- true = abs (digamma (mpfr_make "1") + euler_constant) < mpfr_make "0.000001"

    (* Bessel functions. *)
    val- true = abs (j0 (mpfr_make "1") - mpfr_make "0.7651976865579666") < mpfr_make "0.000001"
    val- true = abs (j1 (mpfr_make "1") - mpfr_make "0.4400505857449335") < mpfr_make "0.000001"
    val- true = abs (y0 (mpfr_make "1") - mpfr_make "0.08825696421567691") < mpfr_make "0.000001"
    val- true = abs (y1 (mpfr_make "1") - mpfr_make "-0.7812128213002888") < mpfr_make "0.000001"

    (* Exponential integrals. *)
    val- true = abs (eint (mpfr_make "1") - mpfr_make "1.895117816355937") < mpfr_make "0.000001"

    (* Dilogarithm (Spence’s function). *)
    val- true = abs (li2 (mpfr_make "1") - mpfr_make "1.644934066848226") < mpfr_make "0.000001"

    (* Riemann’s zeta function. *)
    val- true = abs (zeta (mpfr_make "2") - mpfr_make "1.644934066848226") < mpfr_make "0.000001"

    (* Airy’s Ai function. *)
    val- true = abs (ai (mpfr_make "1") - mpfr_make "0.1352924163128814") < mpfr_make "0.000001"
  in
  end

fn
test3 () : void =
  let
    val- true = mpfr_make "3" < mpfr_make "5"
    val- true = mpfr_make "3" <= mpfr_make "5"
    val- false = mpfr_make "3" > mpfr_make "5"
    val- false = mpfr_make "3" >= mpfr_make "5"
    val- false = mpfr_make "3" = mpfr_make "5"
    val- true = mpfr_make "3" <> mpfr_make "5"
    val- true = mpfr_make "3" != mpfr_make "5"
    val- true = compare (mpfr_make "3", mpfr_make "5") = ~1

    val- false = mpfr_make "8" < mpfr_make "5"
    val- false = mpfr_make "8" <= mpfr_make "5"
    val- true = mpfr_make "8" > mpfr_make "5"
    val- true = mpfr_make "8" >= mpfr_make "5"
    val- false = mpfr_make "8" = mpfr_make "5"
    val- true = mpfr_make "8" <> mpfr_make "5"
    val- true = mpfr_make "8" != mpfr_make "5"
    val- true = compare (mpfr_make "8", mpfr_make "5") = 1

    val- false = mpfr_make "5" < mpfr_make "5"
    val- true = mpfr_make "5" <= mpfr_make "5"
    val- false = mpfr_make "5" > mpfr_make "5"
    val- true = mpfr_make "5" >= mpfr_make "5"
    val- true = mpfr_make "5" = mpfr_make "5"
    val- false = mpfr_make "5" <> mpfr_make "5"
    val- false = mpfr_make "5" != mpfr_make "5"
    val- true = compare (mpfr_make "5", mpfr_make "5") = 0

    val- true = isltz (mpfr_make "-3")
    val- true = isltez (mpfr_make "-3")
    val- false = isgtz (mpfr_make "-3")
    val- false = isgtez (mpfr_make "-3")
    val- false = iseqz (mpfr_make "-3")
    val- true = isneqz (mpfr_make "-3")

    val- false = isltz (mpfr_make "-0")
    val- true = isltez (mpfr_make "-0")
    val- false = isgtz (mpfr_make "-0")
    val- true = isgtez (mpfr_make "-0")
    val- true = iseqz (mpfr_make "-0")
    val- false = isneqz (mpfr_make "-0")

    val- false = isltz (mpfr_make "0")
    val- true = isltez (mpfr_make "0")
    val- false = isgtz (mpfr_make "0")
    val- true = isgtez (mpfr_make "0")
    val- true = iseqz (mpfr_make "0")
    val- false = isneqz (mpfr_make "0")

    val- false = isltz (mpfr_make "5")
    val- false = isltez (mpfr_make "5")
    val- true = isgtz (mpfr_make "5")
    val- true = isgtez (mpfr_make "5")
    val- false = iseqz (mpfr_make "5")
    val- true = isneqz (mpfr_make "5")
  in
  end

fn
test4 () : void =
  let
    val constval = mpfr_make ("2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642742746", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_E ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_E ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_E OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_E (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_E_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("1.4426950408889634073599246810018921374266459541529859341354494069311092191811850798855266", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_LOG2E ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_LOG2E ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_LOG2E OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_LOG2E (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_LOG2E_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("0.434294481903251827651128918916605082294397005803666566114453783165864649208870774729224949338431748318706", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_LOG10E ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_LOG10E ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_LOG10E OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_LOG10E (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_LOG10E_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("2.30258509299404568401799145468436420760110148862877297603332790096757260967735248023599", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_LN10 ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_LN10 ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_LN10 OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_LN10 (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_LN10_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("0.693147180559945309417232121458176568075500134360255254120680009493393621969694715605863326996418687", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_LN2 ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_LN2 ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_LN2 OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_LN2 (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_LN2_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_PI ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_PI ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_PI OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_PI (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_PI_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("1.57079632679489661923132169163975144209858469968755291048747229615390820314310449931401741267105853", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_PI_2 ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_PI_2 ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_PI_2 OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_PI_2 (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_PI_2_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("0.785398163397448309615660845819875721049292349843776455243736148076954101571552249657008706335529266995537", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_PI_4 ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_PI_4 ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_PI_4 OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_PI_4 (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_PI_4_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("0.318309886183790671537767526745028724068919291480912897495334688117793595268453070180227605532506171", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_1_PI ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_1_PI ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_1_PI OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_1_PI (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_1_PI_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("0.636619772367581343075535053490057448137838582961825794990669376235587190536906140360455211065012343824291", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_2_PI ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_2_PI ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_2_PI OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_2_PI (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_2_PI_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("1.128379167095512573896158903121545171688101258657997713688171443421284936882", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_2_SQRTPI ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_2_SQRTPI ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_2_SQRTPI OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_2_SQRTPI (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_2_SQRTPI_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("1.41421356237309504880168872420969807856967187537694807317667973799073247846210703885038753432764157", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_SQRT2 ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_SQRT2 ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_SQRT2 OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_SQRT2 (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_SQRT2_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("0.707106781186547524400844362104849039284835937688474036588339868995366239231053519425193767163820786367506", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_SQRT1_2 ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_SQRT1_2 ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_SQRT1_2 OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_SQRT1_2 (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_SQRT1_2_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("0.577215664901532860606512090082402431042159335939923598805767234884867726777664670936947063291746749", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_EULER ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_EULER ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_EULER OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_EULER (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_EULER_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"

    val constval = mpfr_make ("0.915965594177219015054603514932384110774149374281672134266498119621763019776254769479356512926115106248574", OCTUPLE_PREC)
    val v1 : mpfr = mathconst_CATALAN ()
    val- true = abs (v1 - constval) < mpfr_make "0.000001"
    val v2 = mpfr_CATALAN ()
    val- true = abs (v2 - constval) < mpfr_make "0.000001"
    val v3 = mpfr_CATALAN OCTUPLE_PREC
    val- true = abs (v3 - constval) < mpfr_make "1e-30"
    val v4 = mpfr_CATALAN (i2sz OCTUPLE_PREC)
    val- true = abs (v4 - constval) < mpfr_make "1e-30"
    var x = mpfr_make OCTUPLE_PREC
    val () = mathconst_CATALAN_replace x
    val- true = abs (x - constval) < mpfr_make "1e-30"
  in
  end

fn
test5 () : void =
  let
    val- true = mul_2exp (mpfr_make ("1"), 0) = mpfr_make ("1")
    val- true = mul_2exp (mpfr_make ("1"), 1) = mpfr_make ("2")
    val- true = mul_2exp (mpfr_make ("1"), 2) = mpfr_make ("4")
    val- true = mul_2exp (mpfr_make ("1"), 3) = mpfr_make ("8")

    val- true = div_2exp (mpfr_make ("1"), 0L) = mpfr_make ("1")
    val- true = div_2exp (mpfr_make ("1"), ~1L) = mpfr_make ("2")
    val- true = div_2exp (mpfr_make ("1"), ~2LL) = mpfr_make ("4")
    val- true = div_2exp (mpfr_make ("1"), ~3) = mpfr_make ("8")

    val- true = div_2exp (mpfr_make ("1"), 0) = mpfr_make ("1")
    val- true = div_2exp (mpfr_make ("2"), 1) = mpfr_make ("1")
    val- true = div_2exp (mpfr_make ("4"), 2) = mpfr_make ("1")
    val- true = div_2exp (mpfr_make ("8"), 3) = mpfr_make ("1")

    val- true = mul_2exp (mpfr_make ("1"), ~0) = mpfr_make ("1")
    val- true = mul_2exp (mpfr_make ("2"), ~1L) = mpfr_make ("1")
    val- true = mul_2exp (mpfr_make ("4"), ~2LL) = mpfr_make ("1")
    val- true = mul_2exp (mpfr_make ("8"), ~3) = mpfr_make ("1")

    var x = mpfr_make OCTUPLE_PREC
    val () = mul_2exp_replace (x, mpfr_make "10", 3)
    val- true = x = mpfr_make "80"

    var x = mpfr_make OCTUPLE_PREC
    val () = div_2exp_replace (x, mpfr_make "10", ~3LL)
    val- true = x = mpfr_make "80"
  in
  end

fn
test6 () : void =
  let
    val- true = round (mpfr_make "1.5") = mpfr_make "2"
    val- true = round (mpfr_make "2.5") = mpfr_make "3"
    val- true = round (mpfr_make "3.5") = mpfr_make "4"
    val- true = round (mpfr_make "-1.5") = mpfr_make "-2"
    val- true = round (mpfr_make "-2.5") = mpfr_make "-3"
    val- true = round (mpfr_make "-3.5") = mpfr_make "-4"

    val- true = nearbyint (mpfr_make "1.5") = mpfr_make "2"
    val- true = nearbyint (mpfr_make "2.5") = mpfr_make "2"
    val- true = nearbyint (mpfr_make "3.5") = mpfr_make "4"
    val- true = nearbyint (mpfr_make "-1.5") = mpfr_make "-2"
    val- true = nearbyint (mpfr_make "-2.5") = mpfr_make "-2"
    val- true = nearbyint (mpfr_make "-3.5") = mpfr_make "-4"

    val- true = rint (mpfr_make "1.5") = mpfr_make "2"
    val- true = rint (mpfr_make "2.5") = mpfr_make "2"
    val- true = rint (mpfr_make "3.5") = mpfr_make "4"
    val- true = rint (mpfr_make "-1.5") = mpfr_make "-2"
    val- true = rint (mpfr_make "-2.5") = mpfr_make "-2"
    val- true = rint (mpfr_make "-3.5") = mpfr_make "-4"

    val- true = roundeven (mpfr_make "1.5") = mpfr_make "2"
    val- true = roundeven (mpfr_make "2.5") = mpfr_make "2"
    val- true = roundeven (mpfr_make "3.5") = mpfr_make "4"
    val- true = roundeven (mpfr_make "-1.5") = mpfr_make "-2"
    val- true = roundeven (mpfr_make "-2.5") = mpfr_make "-2"
    val- true = roundeven (mpfr_make "-3.5") = mpfr_make "-4"

    val- true = floor (mpfr_make "1.5") = mpfr_make "1"
    val- true = floor (mpfr_make "2.5") = mpfr_make "2"
    val- true = floor (mpfr_make "3.5") = mpfr_make "3"
    val- true = floor (mpfr_make "-1.5") = mpfr_make "-2"
    val- true = floor (mpfr_make "-2.5") = mpfr_make "-3"
    val- true = floor (mpfr_make "-3.5") = mpfr_make "-4"

    val- true = ceil (mpfr_make "1.5") = mpfr_make "2"
    val- true = ceil (mpfr_make "2.5") = mpfr_make "3"
    val- true = ceil (mpfr_make "3.5") = mpfr_make "4"
    val- true = ceil (mpfr_make "-1.5") = mpfr_make "-1"
    val- true = ceil (mpfr_make "-2.5") = mpfr_make "-2"
    val- true = ceil (mpfr_make "-3.5") = mpfr_make "-3"

    val- true = trunc (mpfr_make "1.5") = mpfr_make "1"
    val- true = trunc (mpfr_make "2.5") = mpfr_make "2"
    val- true = trunc (mpfr_make "3.5") = mpfr_make "3"
    val- true = trunc (mpfr_make "-1.5") = mpfr_make "-1"
    val- true = trunc (mpfr_make "-2.5") = mpfr_make "-2"
    val- true = trunc (mpfr_make "-3.5") = mpfr_make "-3"

    var x = mpfr_make "0"

    val () = round_replace (x, mpfr_make "1.5")
    val- true = x = mpfr_make "2"
    val () = round_replace (x, mpfr_make "2.5")
    val- true = x = mpfr_make "3"
    val () = round_replace (x, mpfr_make "3.5")
    val- true = x = mpfr_make "4"

    val () = round_replace (x, mpfr_make "-1.5")
    val- true = x = mpfr_make "-2"
    val () = round_replace (x, mpfr_make "-2.5")
    val- true = x = mpfr_make "-3"
    val () = round_replace (x, mpfr_make "-3.5")
    val- true = x = mpfr_make "-4"

    val () = nearbyint_replace (x, mpfr_make "1.5")
    val- true = x = mpfr_make "2"
    val () = nearbyint_replace (x, mpfr_make "2.5")
    val- true = x = mpfr_make "2"
    val () = nearbyint_replace (x, mpfr_make "3.5")
    val- true = x = mpfr_make "4"

    val () = nearbyint_replace (x, mpfr_make "-1.5")
    val- true = x = mpfr_make "-2"
    val () = nearbyint_replace (x, mpfr_make "-2.5")
    val- true = x = mpfr_make "-2"
    val () = nearbyint_replace (x, mpfr_make "-3.5")
    val- true = x = mpfr_make "-4"

    val () = rint_replace (x, mpfr_make "1.5")
    val- true = x = mpfr_make "2"
    val () = rint_replace (x, mpfr_make "2.5")
    val- true = x = mpfr_make "2"
    val () = rint_replace (x, mpfr_make "3.5")
    val- true = x = mpfr_make "4"

    val () = rint_replace (x, mpfr_make "-1.5")
    val- true = x = mpfr_make "-2"
    val () = rint_replace (x, mpfr_make "-2.5")
    val- true = x = mpfr_make "-2"
    val () = rint_replace (x, mpfr_make "-3.5")
    val- true = x = mpfr_make "-4"

    val () = roundeven_replace (x, mpfr_make "1.5")
    val- true = x = mpfr_make "2"
    val () = roundeven_replace (x, mpfr_make "2.5")
    val- true = x = mpfr_make "2"
    val () = roundeven_replace (x, mpfr_make "3.5")
    val- true = x = mpfr_make "4"

    val () = roundeven_replace (x, mpfr_make "-1.5")
    val- true = x = mpfr_make "-2"
    val () = roundeven_replace (x, mpfr_make "-2.5")
    val- true = x = mpfr_make "-2"
    val () = roundeven_replace (x, mpfr_make "-3.5")
    val- true = x = mpfr_make "-4"

    val () = floor_replace (x, mpfr_make "1.5")
    val- true = x = mpfr_make "1"
    val () = floor_replace (x, mpfr_make "2.5")
    val- true = x = mpfr_make "2"
    val () = floor_replace (x, mpfr_make "3.5")
    val- true = x = mpfr_make "3"

    val () = floor_replace (x, mpfr_make "-1.5")
    val- true = x = mpfr_make "-2"
    val () = floor_replace (x, mpfr_make "-2.5")
    val- true = x = mpfr_make "-3"
    val () = floor_replace (x, mpfr_make "-3.5")
    val- true = x = mpfr_make "-4"

    val () = ceil_replace (x, mpfr_make "1.5")
    val- true = x = mpfr_make "2"
    val () = ceil_replace (x, mpfr_make "2.5")
    val- true = x = mpfr_make "3"
    val () = ceil_replace (x, mpfr_make "3.5")
    val- true = x = mpfr_make "4"

    val () = ceil_replace (x, mpfr_make "-1.5")
    val- true = x = mpfr_make "-1"
    val () = ceil_replace (x, mpfr_make "-2.5")
    val- true = x = mpfr_make "-2"
    val () = ceil_replace (x, mpfr_make "-3.5")
    val- true = x = mpfr_make "-3"

    val () = trunc_replace (x, mpfr_make "1.5")
    val- true = x = mpfr_make "1"
    val () = trunc_replace (x, mpfr_make "2.5")
    val- true = x = mpfr_make "2"
    val () = trunc_replace (x, mpfr_make "3.5")
    val- true = x = mpfr_make "3"

    val () = trunc_replace (x, mpfr_make "-1.5")
    val- true = x = mpfr_make "-1"
    val () = trunc_replace (x, mpfr_make "-2.5")
    val- true = x = mpfr_make "-2"
    val () = trunc_replace (x, mpfr_make "-3.5")
    val- true = x = mpfr_make "-3"
  in
  end

fn
test7 () : void =
  let
    val- true = nextup (mpfr_make ("1", 2)) = mpfr_make ("1.5", 2)
    val- true = nextdown (mpfr_make ("1", 2)) = mpfr_make ("0.75", 2)

    var x = mpfr_make 2
    val () = nextup_replace (x, mpfr_make ("1", 2))
    val- true = x = mpfr_make ("1.5", 2)

    var x = mpfr_make 2
    val () = nextdown_replace (x, mpfr_make ("1", 2))
    val- true = x = mpfr_make ("0.75", 2)
  in
  end

fn
test8 () : void =
  let
    val- true = fmod (mpfr_make "3", mpfr_make "5") = mpfr_make "3"
    val- true = fmod (mpfr_make "12", mpfr_make "5") = mpfr_make "2"
    val- true = fmod (mpfr_make "25", mpfr_make "5") = mpfr_make "0"

    val- true = remainder (mpfr_make "3", mpfr_make "5") = mpfr_make "-2"
    val- true = remainder (mpfr_make "12", mpfr_make "5") = mpfr_make "2"
    val- true = remainder (mpfr_make "25", mpfr_make "5") = mpfr_make "0"

    val- true = copysign (mpfr_make "3", mpfr_make "5") = mpfr_make "3"
    val- true = copysign (mpfr_make "-3", mpfr_make "5") = mpfr_make "3"
    val- true = copysign (mpfr_make "3", mpfr_make "-5") = mpfr_make "-3"
    val- true = copysign (mpfr_make "-3", mpfr_make "-5") = mpfr_make "-3"

    val- true = pow (mpfr_make "3", mpfr_make "5") = mpfr_make "243"
    val- true = powr (mpfr_make "3", mpfr_make "5") = mpfr_make "243"
    val- true = hypot (mpfr_make "8", mpfr_make "15") = mpfr_make "17"

    val- true = abs (atan2 (mpfr_make "5", mpfr_make "4") - mpfr_make "0.8960553845713") < mpfr_make "0.000001"
    val- true = abs (atan2pi (mpfr_make "5", mpfr_make "4") - mpfr_make "0.285223287477") < mpfr_make "0.000001"

    val- true = fma (mpfr_make "5", mpfr_make "4", mpfr_make "3") = mpfr_make "23"
  in
  end

fn
test9 () : void =
  let
    val- true = abs (compoundn (mpfr_make "0.5", g0i2i 10) - mpfr_make "57.665039") < mpfr_make "0.00001"
    val- true = rootn (mpfr_make "1024", g0i2i 10) = mpfr_make "2"
    val- true = rootn (mpfr_make "1024", g0i2i ~10) = mpfr_make "0.5"
    val- true = pown (mpfr_make "2", g0i2i 3) = mpfr_make "8"
    val- true = pown (mpfr_make "2", g0i2i ~3) = mpfr_make "0.125"
  in
  end

fn
test10 () : void =
  let
    val- true = g0float_npow (mpfr_make ("5", QUAD_PREC), 20) = mpfr_make ("95367431640625", QUAD_PREC)
    val- true = mpfr_get_prec (g0float_npow (mpfr_make ("5", OCTUPLE_PREC), 20)) = g0i2i OCTUPLE_PREC

    val- true = g0float_int_pow (mpfr_make ("4", QUAD_PREC), ~3) = mpfr_make ("0.015625", QUAD_PREC)
    val- true = mpfr_get_prec (g0float_int_pow (mpfr_make ("4", SINGLE_PREC), ~3LL)) = g0i2i SINGLE_PREC

    val- true = (mpfr_make "4") ** ~3L = mpfr_make ("0.015625")

    var x = mpfr_make DOUBLE_PREC

    val () = npow_replace (x, mpfr_make ("2", SINGLE_PREC), 16)
    val- true = x = mpfr_make "65536"
    val- true = mpfr_get_prec x = g0i2i DOUBLE_PREC

    val () = int_pow_replace (x, mpfr_make ("2", QUAD_PREC), 10)
    val- true = x = mpfr_make "1024"
    val- true = mpfr_get_prec x = g0i2i DOUBLE_PREC

    val () = int_pow_replace (x, mpfr_make ("2", OCTUPLE_PREC), 11LL)
    val- true = x = mpfr_make "2048"
    val- true = mpfr_get_prec x = g0i2i DOUBLE_PREC
  in
  end

fn
test11 () : void =
  let
    (* Type conversions. *)

    val- true = ((g0i2f 123) : mpfr) = mpfr_make "123"
    val- true = ((g0f2i (mpfr_make "123")) : int) = 123

    val- true = ((g0i2f 123LL) : mpfr) = mpfr_make "123"
    val- true = ((g0f2i (mpfr_make "123")) : llint) = 123LL

    val- true = ((g0f2f (mpfr_make "123")) : mpfr) = mpfr_make "123"

    val- true = ((g0f2f 123.0F) : mpfr) = mpfr_make "123"
    val- true = ((g0f2f (mpfr_make "123")) : float) = 123.0F

    val- true = ((g0f2f 123.0) : mpfr) = mpfr_make "123"
    val- true = ((g0f2f (mpfr_make "123")) : double) = 123.0

    val- true = ((g0f2f 123.0L) : mpfr) = mpfr_make "123"
    val- true = ((g0f2f (mpfr_make "123")) : ldouble) = 123.0L

    val- true = ((g0f2f (g0int2float<intknd,fix32p32knd> 123)) : mpfr) = mpfr_make "123"
    val- true = ((g0f2f (mpfr_make "123")) : fixed32p32) = (g0int2float<intknd,fix32p32knd> 123)

    val- true = ((g0f2f (exrat_make (123, 1))) : mpfr) = mpfr_make "123"
    val- true = ((g0f2f (mpfr_make "123")) : exrat) = exrat_make (123, 1)

    #ifdef HAVE_FLOAT16 #then
      val- true = ((g0f2f ($extval (float16, "123.0f16"))) : mpfr) = mpfr_make "123"
      val- true = ((g0f2f (mpfr_make "123")) : float16) = $extval (float16, "123.0f16")
    #endif

    #ifdef HAVE_FLOAT32 #then
      val- true = ((g0f2f ($extval (float32, "123.0f32"))) : mpfr) = mpfr_make "123"
      val- true = ((g0f2f (mpfr_make "123")) : float32) = $extval (float32, "123.0f32")
    #endif

    #ifdef HAVE_FLOAT64 #then
      val- true = ((g0f2f ($extval (float64, "123.0f64"))) : mpfr) = mpfr_make "123"
      val- true = ((g0f2f (mpfr_make "123")) : float64) = $extval (float64, "123.0f64")
    #endif

    #ifdef HAVE_FLOAT128 #then
      val- true = ((g0f2f ($extval (float128, "123.0f128"))) : mpfr) = mpfr_make "123"
      val- true = ((g0f2f (mpfr_make "123")) : float128) = $extval (float128, "123.0f128")
    #endif

    #ifdef HAVE_FLOAT16X #then
      val- true = ((g0f2f ($extval (float16x, "123.0f16x"))) : mpfr) = mpfr_make "123"
      val- true = ((g0f2f (mpfr_make "123")) : float16x) = $extval (float16x, "123.0f16x")
    #endif

    #ifdef HAVE_FLOAT32X #then
      val- true = ((g0f2f ($extval (float32x, "123.0f32x"))) : mpfr) = mpfr_make "123"
      val- true = ((g0f2f (mpfr_make "123")) : float32x) = $extval (float32x, "123.0f32x")
    #endif

    #ifdef HAVE_FLOAT64X #then
      val- true = ((g0f2f ($extval (float64x, "123.0f64x"))) : mpfr) = mpfr_make "123"
      val- true = ((g0f2f (mpfr_make "123")) : float64x) = $extval (float64x, "123.0f64x")
    #endif

    #ifdef HAVE_DECIMAL32 #then
      val- true = ((g0f2f ($extval (decimal32, "123.0DF"))) : mpfr) = mpfr_make "123"
      val- true = ((g0f2f (mpfr_make "123")) : decimal32) = $extval (decimal32, "123.0DF")
    #endif

    #ifdef HAVE_DECIMAL64 #then
      val- true = ((g0f2f ($extval (decimal64, "123.0DD"))) : mpfr) = mpfr_make "123"
      val- true = ((g0f2f (mpfr_make "123")) : decimal64) = $extval (decimal64, "123.0DD")
    #endif

    #ifdef HAVE_DECIMAL128 #then
      val- true = ((g0f2f ($extval (decimal128, "123.0DL"))) : mpfr) = mpfr_make "123"
      val- true = ((g0f2f (mpfr_make "123")) : decimal128) = $extval (decimal128, "123.0DL")
    #endif

    #ifdef HAVE_DECIMAL64X #then
      val- true = ((g0f2f ($extval (decimal64x, "(_Decimal64x) 123"))) : mpfr) = mpfr_make "123"
      val- true = ((g0f2f (mpfr_make "123")) : decimal64) = $extval (decimal64x, "(_Decimal64x) 123")
    #endif
  in
  end

fn
test12 () : void =
  let
    val- true = strptr2string (g0float_strfrom ("%f", mpfr_make ("123.456", OCTUPLE_PREC))) = "123.456000"
    val- true = strptr2string (g0float_strfrom ("%.3e", mpfr_make ("123.456", OCTUPLE_PREC))) = "1.235e+02"
    val- true = strptr2string (g0float_strfrom ("%.G", mpfr_make ("123.456", OCTUPLE_PREC))) = "1E+02"
    val- true = strptr2string (g0float_strfrom ("%.3g", mpfr_make ("123.456", OCTUPLE_PREC))) = "123"
    val- true = strptr2string (g0float_strfrom ("%A", mpfr_make ("123.456", OCTUPLE_PREC))) = "0X7.B74BC6A7EF9DB22D0E5604189374BC6A7EF9DB22D0E5604189374BC6A8P+4"
    val- true = strptr2string (g0float_strfrom ("%a", mpfr_make ("123.456", SINGLE_PREC))) = "0x7.b74bc8p+4"

    val- true = ((g0float_strto<mpfrknd> ("123.456", i2sz 0)).0) = mpfr_make "123.456"
    val- true = ((g0float_strto<mpfrknd> ("123.456", i2sz 0)).1) = i2sz 7
    val- true = mpfr_get_prec ((g0float_strto<mpfrknd> ("123.456", i2sz 0)).0) = mpfr_get_default_prec ()

    val- true = ((g0float_strto<mpfrknd> ("x = 123456e-3;", i2sz 4)).0) = mpfr_make "123.456"
    val- true = ((g0float_strto<mpfrknd> ("x = 123456e-3;", i2sz 4)).1) = i2sz 13
    val- true = mpfr_get_prec ((g0float_strto<mpfrknd> ("x = 123456e-3;", i2sz 4)).0) = mpfr_get_default_prec ()

    (* Note that, in the following bunch, "123456e-3" will be rounded
       off, and so you need to test equality with another number of
       THE SAME precision. *)
    val- true = ((mpfr_strto_prec ("x = 123456e-3;", i2sz 4, OCTUPLE_PREC)).0) = mpfr_make ("123.456", OCTUPLE_PREC)
    val- true = ((mpfr_strto_prec ("x = 123456e-3;", i2sz 4, OCTUPLE_PREC)).1) = i2sz 13
    val- true = mpfr_get_prec ((mpfr_strto_prec ("x = 123456e-3;", i2sz 4, OCTUPLE_PREC)).0) = g0i2i OCTUPLE_PREC

    (* Testing hexadecimal input. By the way, there is also a binary
       input format, but it is likely not to work with g0float_strto
       when it is converting the numeral to one of the more
       conventional floating point types. *)
    val- true = ((mpfr_strto_prec ("0X7.B74BC6A7EF9DB22D0E5604189374BC6A7EF9DB22D0E5604189374BC6A8P+4", i2sz 0, OCTUPLE_PREC)).0) = mpfr_make ("123.456", OCTUPLE_PREC)
    val- true = ((mpfr_strto_prec ("0x7.b74bc8p+4", i2sz 0, SINGLE_PREC)).0) = mpfr_make ("123.456", SINGLE_PREC)
  in
  end

fn
test13 () : void =
  let
    val- true = gequal_val_val<mpfr> (mpfr_make "123456", mpfr_make "123456")
    val- false = gequal_val_val<mpfr> (mpfr_make "123456", mpfr_make "654321")

    val- 1 = ~gcompare_val_val<mpfr> (mpfr_make "123456", mpfr_make "654321")
    val- 0 = gcompare_val_val<mpfr> (mpfr_make "654321", mpfr_make "654321")
    val- 1 = gcompare_val_val<mpfr> (mpfr_make "654321", mpfr_make "123456")

    val outf = fileref_open_exn ("tests/mpfr-fprint_val.out", file_mode_w)
    val () = fprint_val<mpfr> (outf, mpfr_make "654321")
    val () = fileref_close outf
    val inpf = fileref_open_exn ("tests/mpfr-fprint_val.out", file_mode_r)
    val- true = fileref_getc inpf = char2int0 '6'
    val- true = fileref_getc inpf = char2int0 '5'
    val- true = fileref_getc inpf = char2int0 '4'
    val- true = fileref_getc inpf = char2int0 '3'
    val- true = fileref_getc inpf = char2int0 '2'
    val- true = fileref_getc inpf = char2int0 '1'
    val- true = fileref_getc inpf = char2int0 '.'
    val- true = fileref_getc inpf = char2int0 '0'
    val- true = fileref_getc inpf = char2int0 '0'
    val- true = fileref_getc inpf = char2int0 '0'
    val- true = fileref_getc inpf = char2int0 '0'
    val- true = fileref_getc inpf = char2int0 '0'
    val- true = fileref_getc inpf = char2int0 '0'
    val- true = isltz (fileref_getc inpf)
    val () = fileref_close outf
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
    0
  end

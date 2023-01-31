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
    val- false = isinf x

    val- true = abs (x - mpfr_make ("1.2345", OCTUPLE_PREC)) <= mpfr_make ("0.0000001", QUAD_PREC)
    val- true = abs (x - mpfr_make ("1.2345")) <= mpfr_make ("0.00001")
    val- true = mpfr_make "1234" = mpfr_make "1234.0"

    var v3 = mpfr_make ()

    val- true = isnan v3
    val- false = isnormal v3
    val- false = isfinite v3
    val- false = isinf v3

    val v4 = mpfr_make "1" / mpfr_make "0"

    val- false = isnan v4
    val- false = isnormal v4
    val- false = isfinite v4
    val- true = isinf v4

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
    val- true = isinf (reciprocal (mpfr_make "0"))

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

implement
main () =
  begin
    test1 ();
    test2 ();
    0
  end

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

(* macdef i2ex = g0int2float<intknd,mpfrknd> *)
(* macdef f2ex = g0float2float<fltknd,mpfrknd> *)
(* macdef d2ex = g0float2float<dblknd,mpfrknd> *)

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

    val- true = abs (x - mpfr_make ("1.2345", OCTUPLE_PREC)) <= mpfr_make ("0.0000001", QUAD_PREC)
    val- true = abs (x - mpfr_make ("1.2345")) <= mpfr_make ("0.00001")

    var v3 = mpfr_make ()
    // FIXME: Test that this is a NaN.
    // FIXME: Test that this is a NaN.
    // FIXME: Test that this is a NaN.
  in
  end

fn
test2 () : void =
  let
    var x = mpfr_make OCTUPLE_PREC

val () = replace (x, 8)
val()=println!(~x)
val()=println!(abs (~x))
val()=println!(reciprocal (~x))
val()=println!(sqrt x)
val()=println!(cbrt x)
val()=println!(exp x)
val()=println!(exp2 x)
val()=println!(exp10 x)
val()=println!(expm1 x)
val()=println!(exp2m1 x)
val()=println!(exp10m1 x)
val()=println!(log x)
val()=println!(log2 x)
val()=println!(log10 x)
val()=println!(log1p x)
val()=println!(logp1 x)
val()=println!(log2p1 x)
val()=println!(log10p1 x)

val () = replace (x, 0.125)
val()=println!(sin x)
val()=println!(cos x)
val()=println!(tan x)
val()=println!(asin x)
val()=println!(acos x)
val()=println!(atan x)
val()=println!(sinpi x)
val()=println!(cospi x)
val()=println!(tanpi x)
val()=println!(asinpi x)
val()=println!(acospi x)
val()=println!(atanpi x)

val () = replace (x, 1)
val()=println!(sinh x)
val()=println!(cosh x)
val()=println!(tanh x)
val()=println!(asinh x)
val()=println!(acosh x)
val()=println!(atanh x)

val () = replace (x, 1)
val()=println!(erf x)
val()=println!(erfc x)
val()=println!(lgamma x)
val()=println!(tgamma x)
val()=println!(digamma x)

val () = replace (x, 1)
val()=println!(j0 x)
val()=println!(j1 x)
val()=println!(y0 x)
val()=println!(y1 x)

val () = replace (x, 2)
val()=println!(eint x)
val()=println!(ai x)
val()=println!(li2 x)
val()=println!(zeta x)

val ai = 3
val()=println!(ai)


    (* var x = mpfr_make (256) *)
    (* var y = mpfr_make (256) *)
    (* val () = x <- 1234.5 *)
    (* val () = (print_mpfr(x); println!()) *)
    (* val () = y <- x *)
    (* val () = (print_mpfr(y); println!()) *)
    (* val () = x <- $extval (decimal64, "1234.56789DD") *)
    (* val () = (print_mpfr(x); println!()) *)
    (* val () = y <- $extval (decimal128, "1234.56789DL") *)
    (* val () = (print_mpfr(y); println!()) *)
    (* val () = x <- $extval (float128, "1234.5f128") *)
    (* val () = (print_mpfr(x); println!()) *)
    (* val () = y <- x *)
    (* val () = (print_mpfr(y); println!()) *)
    (* val () = x <- 12345L *)
    (* val () = (print_mpfr(x); println!()) *)
    (* val () = y <- 12345LL *)
    (* val () = (print_mpfr(y); println!()) *)
    (* val () = x <- ((g0f2f 1234.5) : fixed32p32) *)
    (* val () = (print_mpfr(x); println!()) *)
    (* val () = y <- exrat_make (12345, 10) *)
    (* val () = (print_mpfr(y); println!()) *)
    (* val () = negate y *)
    (* val () = (print_mpfr(y); println!()) *)
    (* val () = (print_mpfr(~y); println!()) *)
    (* val () = println! (mpfr_get_default_prec ()) *)
    (* val () = mpfr_set_default_prec QUAD_PREC *)
    (* val () = println! (mpfr_get_default_prec ()) *)
    (* val () = mpfr_set_default_prec (i2sz OCTUPLE_PREC) *)
    (* val () = println! (mpfr_get_default_prec ()) *)

    (* var z = y *)
    (* val () = println! (mpfr_get_prec z) *)
    (* val () = mpfr_set_prec (z, QUAD_PREC) *)
    (* val () = println! (mpfr_get_prec z) *)
    (* val () = println! (mpfr_get_prec y) *)

    (* var u = ((g0f2f 1.23456789) : fixed32p32) *)
    (* val () = println! u *)
    (* var v = mpfr_make OCTUPLE_PREC *)
    (* val () = v <- 1.23456789 *)
    (* val () = u <- v *)
    (* val () = println! u *)
  in
  end

implement
main () =
  begin
    test1 ();
    //test2 ();
    0
  end

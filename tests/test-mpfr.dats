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
#include "xprelude/HATS/symbols.hats"

(* macdef i2ex = g0int2float<intknd,mpfrknd> *)
(* macdef f2ex = g0float2float<fltknd,mpfrknd> *)
(* macdef d2ex = g0float2float<dblknd,mpfrknd> *)

fn
test1 () : void =
  let
    var x = mpfr_make (256)
    var y = mpfr_make (256)
    val () = x <- 1234.5
    val () = (print_mpfr(x); println!())
    val () = y <- x
    val () = (print_mpfr(y); println!())
    val () = x <- $extval (decimal64, "1234.56789DD")
    val () = (print_mpfr(x); println!())
    val () = y <- $extval (decimal128, "1234.56789DL")
    val () = (print_mpfr(y); println!())
    val () = x <- $extval (float128, "1234.5f128")
    val () = (print_mpfr(x); println!())
    val () = y <- x
    val () = (print_mpfr(y); println!())
    val () = x <- 12345L
    val () = (print_mpfr(x); println!())
    val () = y <- 12345UL
    val () = (print_mpfr(y); println!())
    val () = x <- ((g0f2f 1234.5) : fixed32p32)
    val () = (print_mpfr(x); println!())
    val () = y <- exrat_make (12345, 10)
    val () = (print_mpfr(y); println!())
  in
  end

implement
main () =
  begin
    test1 ();
    0
  end

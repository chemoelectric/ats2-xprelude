(*
  Copyright © 2023 Barry Schwartz

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

#define ATS_PACKNAME "ats2-xprelude.arith_prf"

staload "xprelude/SATS/arith_prf.sats"

(*------------------------------------------------------------------*)
(* Verify that CHAR_BIT equals 8. *)

%{

#include <limits.h>
_Static_assert (CHAR_BIT == 8, "CHAR_BIT does not equal 8");

%}

(*------------------------------------------------------------------*)

primplement
eucliddiv_elim {n, d} {q, r} pf =
  let
    prval () = eucliddiv_mul_elim pf
  in
    mul_make {q, d} ()
  end

primplement
eucliddiv_div {n, d} () =
  let
    prval pf1 = eucliddiv_istot {n, d} ()
    prval pf2 = divmod_istot {n, d} ()
    prval () = eucliddiv_divmod (pf1, pf2)
    prval () = eucliddiv_mul_elim pf1
    prval () = divmod_mul_elim pf2
  in
  end

primplement
euclidrem_mod {n, d} () =
  let
    prval pf1 = eucliddiv_istot {n, d} ()
    prval pf2 = divmod_istot {n, d} ()
    prval () = eucliddiv_divmod (pf1, pf2)
    prval () = eucliddiv_mul_elim pf1
    prval () = divmod_mul_elim pf2
  in
  end

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

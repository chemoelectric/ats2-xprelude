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
include(`common-macros.m4')m4_include(`ats2-xprelude-macros.m4')
(*------------------------------------------------------------------*)

#define ATS_DYNLOADFLAG 0

#define ATS_PACKNAME "ats2-xprelude.mpfr"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload "xprelude/SATS/fixed32p32.sats"
staload _ = "xprelude/DATS/fixed32p32.dats"

staload "xprelude/SATS/exrat.sats"
staload _ = "xprelude/DATS/exrat.dats"

staload "xprelude/SATS/mpfr.sats"

(*------------------------------------------------------------------*)
(* Precision. *)

extern fn
mpfr_set_default_prec_uintmax :
  $d2ctype (mpfr_set_default_prec_guint<uintmaxknd>) = "mac#%"

extern fn
mpfr_set_prec_uintmax :
  $d2ctype (mpfr_set_prec_guint<uintmaxknd>) = "mac#%"

implement {tk}
mpfr_set_default_prec_gint prec =
  mpfr_set_default_prec_uintmax (g1int2uint<tk,uintmaxknd> prec)

implement {tk}
mpfr_set_default_prec_guint prec =
  mpfr_set_default_prec_uintmax (g1uint2uint<tk,uintmaxknd> prec)

implement {tk}
mpfr_set_prec_gint (x, prec) =
  mpfr_set_prec_uintmax (x, g1int2uint<tk,uintmaxknd> prec)

implement {tk}
mpfr_set_prec_guint (x, prec) =
  mpfr_set_prec_uintmax (x, g1uint2uint<tk,uintmaxknd> prec)

(*------------------------------------------------------------------*)
(* Creating new mpfr instances of given precision, initialized to
   NaN. *)

extern fn
_mpfr_make_nan_prec_uintmax :
  {prec : pos}
  uintmax prec -<> mpfr = "mac#%"

implement {tk}
mpfr_make_nan_prec_gint prec =
  _mpfr_make_nan_prec_uintmax (g1i2u prec)

implement {tk}
mpfr_make_nan_prec_guint prec =
  _mpfr_make_nan_prec_uintmax (g1u2u prec)

(*------------------------------------------------------------------*)
(* Creating new mpfr instances of given precision, initialized from
   a string. *)

implement {tk}
mpfr_make_string_prec_gint (s, prec) =
  mpfr_make_string_prec_guint<uintmaxknd>
    (s, g1int2uint<tk,uintmaxknd> prec)

implement {tk}
mpfr_make_string_prec_guint (s, prec) =
  let
    macdef bad_arg =
      let
        val msg = "mpfr_make_string_prec:invalid_string"
      in
        $raise IllegalArgExn msg
      end

    val s = g1ofg0 s
    var x = mpfr_make_nan_prec_guint<tk> prec
    var j : size_t
  in
    $effmask_wrt g0float_strto_replace<mpfrknd> (x, j, s, i2sz 0);
    if iseqz j then
      bad_arg
    else if string_isnot_atend (s, j) then
      bad_arg
    else if isspace s[pred j] then
      bad_arg
    else
      x
  end

(*------------------------------------------------------------------*)
(* Creating new mpfr instances of the default precision. *)

implement {}
mpfr_make_nan_defaultprec () =
  g0float_nan_mpfr ()

implement {}
mpfr_make_string_defaultprec s =
  mpfr_make_string_prec_gint<intmaxknd> (s, mpfr_get_default_prec ())

(*------------------------------------------------------------------*)
(* Assorted operations. *)

m4_foreachq(`OP',`isfinite, isnormal, isnan, isinf,
                  lt, lte, gt, gte, eq, neq, compare,
                  isltz, isltez, isgtz, isgtez, iseqz, isneqz,
                  infinity, nan, huge_val,
                  neg, abs, reciprocal, unary_ops,
                  add, sub, mul, div, binary_ops,
                  unsafe_strto',
`implement g0float_`'OP<mpfrknd> = g0float_`'OP`'_mpfr
')dnl

(*------------------------------------------------------------------*)
value_replacement_runtime_for_boxed_types(`mpfr',`floattypes_without_mpfr')
(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:
dnl

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
(* Type conversions. *)

m4_foreachq(`INT',`intbases',
`implement g0int2float<intb2k(INT),floatt2k(mpfr)> = g0int2float_`'INT`_'mpfr
implement g0float2int<floatt2k(mpfr),intb2k(INT)> = g0float2int_mpfr_`'INT
')dnl

implement g0float2float<floatt2k(mpfr),floatt2k(mpfr)> = g0float2float_mpfr_mpfr
m4_foreachq(`FLT1',`floattypes_without_mpfr',
`implement g0float2float<floatt2k(FLT1),floatt2k(mpfr)> = g0float2float_`'FLT1`_'mpfr
implement g0float2float<floatt2k(mpfr),floatt2k(FLT1)> = g0float2float_mpfr_`'FLT1
')dnl

(*------------------------------------------------------------------*)
(* mul_2exp and div_2exp. *)

extern fn
_g0float_mul_2exp_intmax_mpfr :
  $d2ctype (g0float_mul_2exp<mpfrknd><intmaxknd>) = "mac#%"

implement {tki}
g0float_mul_2exp_mpfr (x, n) =
  _g0float_mul_2exp_intmax_mpfr (x, g0int2int<tki,intmaxknd> n)

implement {tki}
g0float_div_2exp_mpfr (x, n) =
  _g0float_mul_2exp_intmax_mpfr (x, ~(g0int2int<tki,intmaxknd> n))

m4_foreachq(`INT',`conventional_intbases',
`implement
g0float_mul_2exp<mpfrknd><intb2k(INT)> =
  g0float_mul_2exp_mpfr<intb2k(INT)>

implement
g0float_div_2exp<mpfrknd><intb2k(INT)> =
  g0float_div_2exp_mpfr<intb2k(INT)>

')dnl
(*------------------------------------------------------------------*)
(* Assorted operations. *)

m4_foreachq(`OP',`isfinite, isnormal, isnan, isinf,
                  lt, lte, gt, gte, eq, neq, compare,
                  isltz, isltez, isgtz, isgtez, iseqz, isneqz,
                  infinity, nan, huge_val,
                  neg, abs, reciprocal, unary_ops,
                  add, sub, mul, div, binary_ops,
                  unsafe_strfrom, unsafe_strto,
                  trinary_ops, floattype_intmax_ops',
`implement g0float_`'OP<mpfrknd> = g0float_`'OP`'_mpfr
')dnl

implement g0float_npow_mpfr<> (x, i) = g0float_pown_mpfr (x, g0i2i i)
implement g0float_npow<mpfrknd> = g0float_npow_mpfr

m4_foreachq(`INT',`intbases',
`implement g0float_int_pow_mpfr<intb2k(INT)> (x, i) = g0float_pown_mpfr (x, g0i2i i)
implement g0float_int_pow<mpfrknd><intb2k(INT)> = g0float_int_pow_mpfr<intb2k(INT)>
')dnl

(*------------------------------------------------------------------*)
(* Mathematical constants. *)

(* Below there is some masking of !ref effects, where the ‘reference’
   is to the default precision. The masking seems necessary, because
   xprelude/SATS/float.sats is not prepared to deal with such
   effects. *)

m4_foreachq(`CONST',`list_of_m4_constant',
`implement
mathconst_`'CONST<mpfrknd> () =
  $effmask_ref mpfr_`'CONST`'_defaultprec<> ()

implement {tk}
mpfr_`'CONST`'_prec_gint prec =
  let
    var z = mpfr_make_nan_prec_gint<tk> prec
    val () = $effmask_wrt mathconst_`'CONST`'_replace<mpfrknd> z
  in
    z
  end

implement {tk}
mpfr_`'CONST`'_prec_guint prec =
  let
    var z = mpfr_make_nan_prec_guint<tk> prec
    val () = $effmask_wrt mathconst_`'CONST`'_replace<mpfrknd> z
  in
    z
  end

implement
mpfr_`'CONST`'_defaultprec<> () =
  $effmask_all
  let
    var z = mpfr_make_nan_defaultprec ()
    val () = $effmask_wrt mathconst_`'CONST`'_replace<mpfrknd> z
  in
    z
  end

')dnl
(*------------------------------------------------------------------*)
(* Value replacement. *)

(*

  SOME WARNINGS:

     — The nextup_replace and nextdown_replace functions for mpfr
       give the next-up or next-down IN THE PRECISION OF THE
       DESTINATION VARIABLE.

*)

value_replacement_runtime_for_boxed_types(`mpfr',`floattypes_without_mpfr')

(*------------------------------------------------------------------*)
(* strto with a precision argument. *)

(*  -    -    -    -    -    -    -    -    -    -    -    -    -   *)
(* General templates. *)

implement {tki}
mpfr_strto_prec_gint (s, i, prec) =
  $effmask_wrt
  let
    var z = mpfr_make prec
    var j : size_t
    val () = g0float_strto_replace<mpfrknd> (z, j, s, i)
  in
    @(z, j)
  end

implement {tki}
mpfr_strto_prec_guint (s, i, prec) =
  $effmask_wrt
  let
    var z = mpfr_make prec
    var j : size_t
    val () = g0float_strto_replace<mpfrknd> (z, j, s, i)
  in
    @(z, j)
  end

(*  -    -    -    -    -    -    -    -    -    -    -    -    -   *)
(* A precompiled library function. This will usually be what is used
   if the precision is given in one of the integer types supported by
   xprelude/SATS/integer.sats *)

extern fn _mpfr_strto_prec_uintmax : $d2ctype (mpfr_strto_prec_guint<uintmaxknd>)

if_COMPILING_IMPLEMENTATIONS(
`implement
_mpfr_strto_prec_uintmax (s, i, prec) =
  $effmask_wrt
  let
    var z = mpfr_make prec
    var j : size_t
    val () = g0float_strto_replace<mpfrknd> (z, j, s, i)
  in
    @(z, j)
  end
')dnl

if_not_COMPILING_IMPLEMENTATIONS(
`m4_foreachq(`INT',`intbases',
`implement mpfr_strto_prec_gint<intb2k(INT)> (s, i, prec) = _mpfr_strto_prec_uintmax (s, i, g1i2u prec)
')dnl
')dnl

if_not_COMPILING_IMPLEMENTATIONS(
`m4_foreachq(`UINT',`uintbases',
`implement mpfr_strto_prec_guint<uintb2k(UINT)> (s, i, prec) = _mpfr_strto_prec_uintmax (s, i, g1u2u prec)
')dnl
')dnl

(*------------------------------------------------------------------*)
(* Generics. *)

implement fprint_val<mpfr> = fprint_mpfr
implement gequal_val_val<mpfr> = g0float_eq<floatt2k(mpfr)>
implement gcompare_val_val<mpfr> = g0float_compare<floatt2k(mpfr)>

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:
dnl

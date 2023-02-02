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

#define ATS_PACKNAME "ats2-xprelude.mpfr"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "xprelude/HATS/xprelude_sats.hats"

staload "xprelude/SATS/fixed32p32.sats"
staload "xprelude/SATS/exrat.sats"

%{#
#include "xprelude/CATS/mpfr.cats"
%}

(*------------------------------------------------------------------*)
(*

  NOTE: Many operations set the result to the greatest precision of
        its inputs.

        Of course, one might really want the least precision, but
        caution was chosen.

        (If one finds an operation that is using the default
        precision but which seems should not be doing so, that is
        likely a bug.)

*)
(*------------------------------------------------------------------*)

(* You can call mpfr_initialize explicitly, to set up things needed
   by the mpfr implementation, or you can let mpfr_initialize be
   called by other functions. *)
fn
mpfr_initialize :
  () -<> void = "mac#my_extern_prefix`'mpfr_one_time_initialization"

(*------------------------------------------------------------------*)

tkindef mpfr_kind = "my_extern_prefix`'mpfr"
stadef mpfrknd = mpfr_kind
typedef mpfr = g0float mpfrknd

(*------------------------------------------------------------------*)

fn fprint_mpfr : fprint_type mpfr = "mac#%"
fn print_mpfr : mpfr -> void = "mac#%"
fn prerr_mpfr : mpfr -> void = "mac#%"
overload fprint with fprint_mpfr
overload print with print_mpfr
overload prerr with prerr_mpfr

(*------------------------------------------------------------------*)
(* Classifications. *)

fn g0float_isfinite_mpfr : mpfr -<> bool = "mac#%"
fn g0float_isnormal_mpfr : mpfr -<> bool = "mac#%"
fn g0float_isnan_mpfr : mpfr -<> bool = "mac#%"
fn g0float_isinf_mpfr : mpfr -<> bool = "mac#%"

(*------------------------------------------------------------------*)
(* Precision. *)

(* Precision settings will be brought to within the C constants
   [MPFR_PREC_MIN,MPFR_PREC_MAX]. If the precision of an existing mpfr
   is altered, the value is set to a NaN.

   Depending on how mpfr was configured, the default precision may or
   may not be thread-local. *)

fn {tk : tkind}
mpfr_set_default_prec_gint :
  {prec : pos}
  g1int (tk, prec) -< !wrt > void

fn {tk : tkind}
mpfr_set_default_prec_guint :
  {prec : pos}
  g1uint (tk, prec) -< !wrt > void

overload mpfr_set_default_prec with mpfr_set_default_prec_gint
overload mpfr_set_default_prec with mpfr_set_default_prec_guint

fn {tk : tkind}
mpfr_set_prec_gint :
  {prec : pos}
  (&mpfr >> _, g1int (tk, prec)) -< !wrt > void

fn {tk : tkind}
mpfr_set_prec_guint :
  {prec : pos}
  (&mpfr >> _, g1uint (tk, prec)) -< !wrt > void

overload mpfr_set_prec with mpfr_set_prec_gint
overload mpfr_set_prec with mpfr_set_prec_guint

fn
mpfr_get_default_prec :
  () -< !ref > [prec : pos] intmax prec = "mac#%"

fn
mpfr_get_prec :
  mpfr -< !ref > [prec : pos] intmax prec = "mac#%"

(*------------------------------------------------------------------*)
(* Create an mpfr of the given precision, initialized to a NaN. *)

(* Precision settings will be brought to within the C constants
   [MPFR_PREC_MIN,MPFR_PREC_MAX]. *)

fn {tk : tkind}
mpfr_make_nan_prec_gint :
  {prec : pos}
  g1int (tk, prec) -<> mpfr

fn {tk : tkind}
mpfr_make_nan_prec_guint :
  {prec : pos}
  g1uint (tk, prec) -<> mpfr

overload mpfr_make_nan_prec with mpfr_make_nan_prec_gint
overload mpfr_make_nan_prec with mpfr_make_nan_prec_guint
overload mpfr_make with mpfr_make_nan_prec

(*------------------------------------------------------------------*)
(* Create an mpfr of the given precision, initialized from a
   string. *)

(* Precision settings will be brought to within the C constants
   [MPFR_PREC_MIN,MPFR_PREC_MAX]. *)

fn {tk : tkind}
mpfr_make_string_prec_gint :
  {prec : pos}
  (string, g1int (tk, prec)) -< !exn > mpfr

fn {tk : tkind}
mpfr_make_string_prec_guint :
  {prec : pos}
  (string, g1uint (tk, prec)) -< !exn > mpfr

overload mpfr_make_string_prec with mpfr_make_string_prec_gint
overload mpfr_make_string_prec with mpfr_make_string_prec_guint
overload mpfr_make with mpfr_make_string_prec

(*------------------------------------------------------------------*)
(* Create an mpfr of the default precision. *)

fn {}
mpfr_make_nan_defaultprec :
  () -< !ref > mpfr

fn {}
mpfr_make_string_defaultprec :
  string -< !exnref > mpfr

overload mpfr_make with mpfr_make_nan_defaultprec
overload mpfr_make with mpfr_make_string_defaultprec

(*------------------------------------------------------------------*)
(* Mathematical constants. *)

(* IMPORTANT NOTE: Some of these constants may be cached by mpfr, but
   others have to be computed each time they are requested. Even those
   that are cached may be cached at higher precision than you need,
   and will require rounding. Thus you should consider saving copies
   of whatever constants you use. *)

m4_foreachq(`CONST',`list_of_m4_constant',
`(* m4_constant_mpfr_comment(CONST) *)
fn {tk : tkind} mpfr_`'CONST`'_prec_gint : {prec : pos} g1int (tk, prec) -<> mpfr
fn {tk : tkind} mpfr_`'CONST`'_prec_guint : {prec : pos} g1uint (tk, prec) -<> mpfr
fn {} mpfr_`'CONST`'_defaultprec : () -< !ref > mpfr
overload mpfr_mathconst_`'CONST with mpfr_`'CONST`'_prec_gint
overload mpfr_mathconst_`'CONST with mpfr_`'CONST`'_prec_guint
overload mpfr_mathconst_`'CONST with mpfr_`'CONST`'_defaultprec
overload mpfr_`'CONST with mpfr_mathconst_`'CONST

')dnl
(*------------------------------------------------------------------*)
(* Comparisons. *)

m4_foreachq(`OP',`comparisons',
`fn g0float_`'OP`'_mpfr : (mpfr, mpfr) -<> bool = "mac#%"
')dnl

fn g0float_compare_mpfr : g0float_compare_type mpfrknd = "mac#%"

m4_foreachq(`OP',`comparisons',
`fn g0float_is`'OP`'z_mpfr : mpfr -<> bool = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Multiplication or division by powers of two. These can be used as
   shift operations. *)

fn {tki : tkind} g0float_mul_2exp_mpfr : (mpfr, g0int tki) -<> mpfr
fn {tki : tkind} g0float_div_2exp_mpfr : (mpfr, g0int tki) -<> mpfr

(*------------------------------------------------------------------*)
(* Assorted operations. *)

m4_foreachq(`OP',`infinity, nan, snan, huge_val',
`fn g0float_`'OP`'_mpfr : () -<> mpfr = "mac#%"
')dnl

m4_foreachq(`OP',`neg, abs, reciprocal, unary_ops',
`fn g0float_`'OP`'_mpfr : mpfr -<> mpfr = "mac#%"
')dnl

m4_foreachq(`OP',`add, sub, mul, div, binary_ops',
`fn g0float_`'OP`'_mpfr : (mpfr, mpfr) -<> mpfr = "mac#%"
')dnl

m4_foreachq(`OP',`trinary_ops',
`fn g0float_`'OP`'_mpfr : (mpfr, mpfr, mpfr) -<> mpfr = "mac#%"
')dnl

fn g0float_unsafe_strto_mpfr : (ptr, ptr) -< !wrt > mpfr = "mac#%"

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

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
mpfr_make_prec_gint :
  {prec : pos}
  g1int (tk, prec) -<> mpfr

fn {tk : tkind}
mpfr_make_prec_guint :
  {prec : pos}
  g1uint (tk, prec) -<> mpfr

overload mpfr_make_prec with mpfr_make_prec_gint
overload mpfr_make_prec with mpfr_make_prec_guint
overload mpfr_make with mpfr_make_prec

(*------------------------------------------------------------------*)
(* Comparisons. *)

fn g0float_eq_mpfr : (mpfr, mpfr) -<> bool = "mac#%"
fn g0float_neq_mpfr : (mpfr, mpfr) -<> bool = "mac#%"
fn g0float_lt_mpfr : (mpfr, mpfr) -<> bool = "mac#%"
fn g0float_lte_mpfr : (mpfr, mpfr) -<> bool = "mac#%"
fn g0float_gt_mpfr : (mpfr, mpfr) -<> bool = "mac#%"
fn g0float_gte_mpfr : (mpfr, mpfr) -<> bool = "mac#%"

fn g0float_compare_mpfr : g0float_compare_type mpfrknd = "mac#%"

(*------------------------------------------------------------------*)
(* Assorted operations. *)

m4_foreachq(`OP',`neg, abs, reciprocal, unary_ops',
`fn g0float_`'OP`'_mpfr : mpfr -<> mpfr = "mac#%"
')dnl

m4_foreachq(`OP',`add, sub, mul, div, binary_ops',
`fn g0float_`'OP`'_mpfr : (mpfr, mpfr) -<> mpfr = "mac#%"
')dnl

fn g0float_unsafe_strto_mpfr : (ptr, ptr) -< !wrt > mpfr = "mac#%"

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

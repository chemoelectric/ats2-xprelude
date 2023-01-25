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
m4_define(`EXRAT',`if_not_ENABLE_EXRAT(``/'`/' ')')
(*------------------------------------------------------------------*)

#define ATS_PACKNAME "ats2-xprelude.mpfr"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "xprelude/HATS/xprelude_sats.hats"
#include "xprelude/HATS/symbols.hats"

staload "xprelude/SATS/fixed32p32.sats"
EXRAT`'staload "xprelude/SATS/exrat.sats"

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

(* Create an mpfr of the given precision, initialized to a NaN. The
   actual precision will be brought to within the C constants
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

typedef mpfr_replace_type (a : t@ype) = (&mpfr >> _, a) -< !wrt > void

m4_foreachq(`INT',`intbases',
`fn mpfr_replace_`'intb2t(INT) : mpfr_replace_type intb2t(INT) = "mac#%"
')dnl

m4_foreachq(`UINT',`uintbases',
`fn mpfr_replace_`'uintb2t(UINT) : mpfr_replace_type uintb2t(UINT) = "mac#%"
')dnl

m4_foreachq(`T',`floattypes',
`m4_if(T,`exrat',EXRAT)`'fn mpfr_replace_`'T : mpfr_replace_type T = "mac#%"
')dnl

m4_foreachq(`INT',`intbases',
`overload <- with mpfr_replace_`'intb2t(INT) of 1
')dnl

m4_foreachq(`UINT',`uintbases',
`overload <- with mpfr_replace_`'uintb2t(UINT) of 1
')dnl

m4_foreachq(`T',`floattypes',
`m4_if(T,`mpfr',,`m4_if(T,`exrat',EXRAT)`'overload <- with mpfr_replace_`'T of 1
')')dnl

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

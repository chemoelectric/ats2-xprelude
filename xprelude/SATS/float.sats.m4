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

#define ATS_PACKNAME "ats2-xprelude.float"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

(******************************************************************
  Some floating-point support that is not included in the Postiats
  prelude.
*******************************************************************)

%{#
#include "xprelude/CATS/float.cats"
%}

staload "xprelude/SATS/integer.sats"

(*------------------------------------------------------------------*)

m4_foreachq(`FLT1',`extended_floattypes',
`tkindef FLT1`'_kind = "my_extern_prefix`'FLT1`'"
typedef FLT1`' = g0float FLT1`'_kind

')dnl
m4_foreachq(`N',`extended_floattypes_suffixes',
`stadef flt`'N`'knd = float`'N`'_kind
')dnl

(*------------------------------------------------------------------*)
(* Printing. *)

(* I give the overloads precedence 1, so they will take precedence
   over overloads of precedence 0 in the prelude. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`fn fprint_`'FLT1 : fprint_type FLT1 = "mac#%"
fn print_`'FLT1 : FLT1 -> void = "mac#%"
fn prerr_`'FLT1 : FLT1 -> void = "mac#%"
overload fprint with fprint_`'FLT1 of 1
overload print with print_`'FLT1 of 1
overload prerr with prerr_`'FLT1 of 1

')dnl
(*------------------------------------------------------------------*)
(* Conversion to a string. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`fn {} tostrptr_`'FLT1 : FLT1 -< !wrt > Strptr1
fn {} tostring_`'FLT1 : FLT1 -<> string

')dnl
(*------------------------------------------------------------------*)
(* g0float_epsilon: the difference between 1 and the least value
   greater than 1.                                                  *)

typedef g0float_epsilon_type (tk : tkind) = () -<> g0float tk

fn {tk : tkind} g0float_epsilon : g0float_epsilon_type tk

m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_epsilon_`'FLT1 : g0float_epsilon_type floatt2k(FLT1) = "mac#%"
')dnl

overload epsilon with g0float_epsilon

(*------------------------------------------------------------------*)
(* g0float_sgn: the sign of the number. *)

typedef g0float_sgn_type (tk : tkind) = g0float tk -<> [s : sgn] int s

fn {tk : tkind} g0float_sgn : g0float_sgn_type tk

m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_sgn_`'FLT1 : g0float_sgn_type floatt2k(FLT1) = "mac#%"
')dnl

overload sgn with g0float_sgn

(*------------------------------------------------------------------*)
(* g0float_abs: the absolute value of the number. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_abs_`'FLT1 : FLT1 -<> FLT1 = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Unary operations. *)

m4_foreachq(`UOP',`unary_ops',
`fn {tk : tkind} g0float_`'UOP : g0float_uop_type tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'UOP`'_`'FLT1 : g0float_uop_type floatt2k(FLT1) = "mac#%"
')dnl
overload UOP with g0float_`'UOP

')dnl
(*------------------------------------------------------------------*)
(* Binary operations. *)

m4_foreachq(`AOP',`binary_ops',
`fn {tk : tkind} g0float_`'AOP : g0float_aop_type tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'AOP`'_`'FLT1 : g0float_aop_type floatt2k(FLT1) = "mac#%"
')dnl
overload AOP with g0float_`'AOP

')dnl
(*------------------------------------------------------------------*)
(* Trinary operations. *)

typedef g0float_top_type (tk : tkind) =
  (g0float tk, g0float tk, g0float tk) -<> g0float tk

m4_foreachq(`TOP',`trinary_ops',
`fn {tk : tkind} g0float_`'TOP : g0float_top_type tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'TOP`'_`'FLT1 : g0float_top_type floatt2k(FLT1) = "mac#%"
')dnl
overload TOP with g0float_`'TOP

')dnl
(*------------------------------------------------------------------*)
(* Some of the following are overlooked in the prelude. (Those that
   *are* already in the prelude might be shadowed.) *)

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0int2float_`'INT`_'FLT1 : intb2t(INT) -<> FLT1 = "mac#%"
')dnl

')dnl
m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float2int_`'FLT1`_'INT : FLT1 -<> intb2t(INT) = "mac#%"
')dnl

')dnl
m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`FLT2',`conventional_floattypes',
`fn g0float2float_`'FLT1`_'FLT2 : FLT1 -<> FLT2 = "mac#%"
')dnl

')dnl
(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

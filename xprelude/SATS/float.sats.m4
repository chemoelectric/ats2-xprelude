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
(* Unary operations. *)

m4_foreachq(uop,`unary_ops',
`fn {tk : tkind} g0float_`'uop : g0float_uop_type tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'uop`'_`'FLT1 : g0float_uop_type floatt2k(FLT1) = "mac#%"
')dnl
overload uop with g0float_`'uop

')dnl
(*------------------------------------------------------------------*)
(* Binary operations. *)

m4_foreachq(aop,`binary_ops',
`fn {tk : tkind} g0float_`'aop : g0float_aop_type tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'aop`'_`'FLT1 : g0float_aop_type floatt2k(FLT1) = "mac#%"
')dnl
overload aop with g0float_`'aop

')dnl
(*------------------------------------------------------------------*)
(* Trinary operations. *)

typedef g0float_top_type (tk : tkind) =
  (g0float tk, g0float tk, g0float tk) -<> g0float tk

m4_foreachq(top,`trinary_ops',
`fn {tk : tkind} g0float_`'top : g0float_top_type tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'top`'_`'FLT1 : g0float_top_type floatt2k(FLT1) = "mac#%"
')dnl
overload top with g0float_`'top

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

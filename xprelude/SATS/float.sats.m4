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
#define ATS_EXTERN_PREFIX "ats2_xprelude_"

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

fn g0float_epsilon_float : g0float_epsilon_type fltknd = "mac#%"
fn g0float_epsilon_double : g0float_epsilon_type dblknd = "mac#%"
fn g0float_epsilon_ldouble : g0float_epsilon_type ldblknd = "mac#%"

overload epsilon with g0float_epsilon

(*------------------------------------------------------------------*)
(* g0float_sgn: the sign of the number. *)

typedef g0float_sgn_type (tk : tkind) = g0float tk -<> [s : sgn] int s

fn {tk : tkind} g0float_sgn : g0float_sgn_type tk

fn g0float_sgn_float : g0float_sgn_type fltknd = "mac#%"
fn g0float_sgn_double : g0float_sgn_type dblknd = "mac#%"
fn g0float_sgn_ldouble : g0float_sgn_type ldblknd = "mac#%"

overload sgn with g0float_sgn

(*------------------------------------------------------------------*)
(* Unary operations.                                                *)

m4_foreachq(uop,`unary_ops',
`
fn {tk : tkind} g0float_`'uop : g0float_uop_type tk
fn g0float_`'uop`'_float : g0float_uop_type fltknd = "mac#%"
fn g0float_`'uop`'_double : g0float_uop_type dblknd = "mac#%"
fn g0float_`'uop`'_ldouble : g0float_uop_type ldblknd = "mac#%"
overload uop with g0float_`'uop
')

(*------------------------------------------------------------------*)
(* Binary operations.                                               *)

m4_foreachq(aop,`binary_ops',
`
fn {tk : tkind} g0float_`'aop : g0float_aop_type tk
fn g0float_`'aop`'_float : g0float_aop_type fltknd = "mac#%"
fn g0float_`'aop`'_double : g0float_aop_type dblknd = "mac#%"
fn g0float_`'aop`'_ldouble : g0float_aop_type ldblknd = "mac#%"
overload aop with g0float_`'aop
')

(*------------------------------------------------------------------*)
(* Trinary operations.                                               *)

typedef g0float_top_type (tk : tkind) =
  (g0float tk, g0float tk, g0float tk) -<> g0float tk

m4_foreachq(top,`trinary_ops',
`
fn {tk : tkind} g0float_`'top : g0float_top_type tk
fn g0float_`'top`'_float : g0float_top_type fltknd = "mac#%"
fn g0float_`'top`'_double : g0float_top_type dblknd = "mac#%"
fn g0float_`'top`'_ldouble : g0float_top_type ldblknd = "mac#%"
overload top with g0float_`'top
')

(*------------------------------------------------------------------*)
(* Some of the following are overlooked in the prelude. (Those that
   *are* already in the prelude might harmlessly be shadowed.) *)

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT',`float,double,ldouble',
`fn g0int2float_`'INT`_'FLT : intb2t(INT) -<> FLT = "mac#%"
')
')dnl

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT',`float,double,ldouble',
`fn g0float2int_`'FLT`_'INT : FLT -<> intb2t(INT) = "mac#%"
')
')dnl

m4_foreachq(`FLT1',`float,double,ldouble',
`m4_foreachq(`FLT2',`float,double,ldouble',
`fn g0float2float_`'FLT1`_'FLT2 : FLT1 -<> FLT2 = "mac#%"
')dnl
')dnl

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

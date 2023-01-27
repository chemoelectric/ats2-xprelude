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

#define ATS_PACKNAME "ats2-xprelude.fixed32p32"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

%{#
#include "xprelude/CATS/fixed32p32.cats"
%}

staload "xprelude/SATS/integer.sats"
staload "xprelude/SATS/float.sats"

(*------------------------------------------------------------------*)

tkindef fixed32p32_kind = "my_extern_prefix`'fixed32p32"
stadef fix32p32knd = fixed32p32_kind
typedef fixed32p32 = g0float fix32p32knd

fn {} fprint_fixed32p32 : fprint_type fixed32p32
fn {} print_fixed32p32 : fixed32p32 -> void
fn {} prerr_fixed32p32 : fixed32p32 -> void
overload fprint with fprint_fixed32p32
overload print with print_fixed32p32
overload prerr with prerr_fixed32p32

fn
tostrptr_fixed32p32_given_decimal_places :
  (fixed32p32, intGte 0) -< !wrt > Strptr1 = "mac#%"

fn
tostring_fixed32p32_given_decimal_places :
  (fixed32p32, intGte 0) -<> string = "mac#%"

fn {}
tostrptr_fixed32p32_assumed_decimal_places :
  fixed32p32 -< !wrt > Strptr1

fn {}
tostring_fixed32p32_assumed_decimal_places :
  fixed32p32 -<> string

fn {}
fixed32p32$decimal_places :
  () -<> intGte 0

overload tostrptr_fixed32p32 with tostrptr_fixed32p32_given_decimal_places
overload tostring_fixed32p32 with tostring_fixed32p32_given_decimal_places
overload tostrptr_fixed32p32 with tostrptr_fixed32p32_assumed_decimal_places
overload tostring_fixed32p32 with tostring_fixed32p32_assumed_decimal_places

(* The difference between 1 and the least value greater than 1. *)
fn g0float_epsilon_fixed32p32 : () -<> fixed32p32 = "mac#%"

m4_foreachq(`INT',`intbases',
`fn g0int2float_`'INT`'_fixed32p32 : m4_g0int(INT) -<> fixed32p32 = "mac#%"
fn g0float2int_fixed32p32_`'INT : fixed32p32 -<> m4_g0int(INT) = "mac#%"
')dnl

m4_foreachq(`FLT',`conventional_floattypes',
`fn g0float2float_`'FLT`'_fixed32p32 : m4_g0float(FLT) -<> fixed32p32 = "mac#%"
fn g0float2float_fixed32p32_`'FLT : fixed32p32 -<> m4_g0float(FLT) = "mac#%"
')dnl
fn g0float2float_fixed32p32_fixed32p32 : fixed32p32 -<> fixed32p32 = "mac#%"

fn g0float_sgn_fixed32p32 : g0float_sgn_type fix32p32knd = "mac#%"

fn g0float_neg_fixed32p32 : fixed32p32 -<> fixed32p32 = "mac#%"
fn g0float_abs_fixed32p32 : fixed32p32 -<> fixed32p32 = "mac#%"
fn g0float_fabs_fixed32p32 : fixed32p32 -<> fixed32p32 = "mac#%"

fn g0float_succ_fixed32p32 : fixed32p32 -<> fixed32p32 = "mac#%"
fn g0float_pred_fixed32p32 : fixed32p32 -<> fixed32p32 = "mac#%"

fn g0float_add_fixed32p32 : (fixed32p32, fixed32p32) -<> fixed32p32 = "mac#%"
fn g0float_sub_fixed32p32 : (fixed32p32, fixed32p32) -<> fixed32p32 = "mac#%"

fn g0float_min_fixed32p32 : (fixed32p32, fixed32p32) -<> fixed32p32 = "mac#%"
fn g0float_max_fixed32p32 : (fixed32p32, fixed32p32) -<> fixed32p32 = "mac#%"

fn g0float_eq_fixed32p32 : (fixed32p32, fixed32p32) -<> bool = "mac#%"
fn g0float_neq_fixed32p32 : (fixed32p32, fixed32p32) -<> bool = "mac#%"
fn g0float_lt_fixed32p32 : (fixed32p32, fixed32p32) -<> bool = "mac#%"
fn g0float_lte_fixed32p32 : (fixed32p32, fixed32p32) -<> bool = "mac#%"
fn g0float_gt_fixed32p32 : (fixed32p32, fixed32p32) -<> bool = "mac#%"
fn g0float_gte_fixed32p32 : (fixed32p32, fixed32p32) -<> bool = "mac#%"

fn g0float_compare_fixed32p32 : g0float_compare_type fix32p32knd = "mac#%"

fn g0float_mul_fixed32p32 : (fixed32p32, fixed32p32) -<> fixed32p32 = "mac#%"
fn g0float_div_fixed32p32 : (fixed32p32, fixed32p32) -<> fixed32p32 = "mac#%"

(* Note that g0float_fma_fixed32p32 may be implemented as separate
   multiplication and addition, rather than as a single ternary
   operation. *)
fn g0float_fma_fixed32p32 : (fixed32p32, fixed32p32, fixed32p32) -<> fixed32p32 = "mac#%"

(* Note that g0float_nearbyint_fixed32p32 and g0float_rint_fixed32p32
   are equivalent, and that neither respects the IEEE rounding
   direction. Neither do they raise an IEEE exception. *)
fn g0float_round_fixed32p32 : fixed32p32 -<> fixed32p32 = "mac#%"
fn g0float_nearbyint_fixed32p32 : fixed32p32 -<> fixed32p32 = "mac#%"
fn g0float_rint_fixed32p32 : fixed32p32 -<> fixed32p32 = "mac#%"
fn g0float_floor_fixed32p32 : fixed32p32 -<> fixed32p32 = "mac#%"
fn g0float_ceil_fixed32p32 : fixed32p32 -<> fixed32p32 = "mac#%"
fn g0float_trunc_fixed32p32 : fixed32p32 -<> fixed32p32 = "mac#%"

fn g0float_sqrt_fixed32p32 : fixed32p32 -<> fixed32p32

(*------------------------------------------------------------------*)

fn {} g0float_npow_fixed32p32 : (fixed32p32, intGte 0) -<> fixed32p32
fn {tki : tkind} g0float_int_pow_fixed32p32 : (fixed32p32, g0int tki) -<> fixed32p32

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

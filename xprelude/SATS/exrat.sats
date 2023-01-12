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

#define ATS_PACKNAME "ats2-xprelude.exrat"
#define ATS_EXTERN_PREFIX "ats2_xprelude_"

%{#
#include "xprelude/CATS/exrat.cats"
%}

#include "xprelude/HATS/xprelude_sats.hats"
staload "xprelude/SATS/fixed32p32.sats"

(* You can call exrat_initialize explicitly, to set up things needed
   by the exrat implementation, or you can let exrat_initialize be
   called by other functions. *)
fn
exrat_initialize :
  () -<> void = "mac#ats2_xprelude_exrat_one_time_initialization"

tkindef exrat_kind = "ats2_xprelude_exrat"
stadef exratknd = exrat_kind
typedef exrat = g0float exratknd

fn fprint_exrat : fprint_type exrat = "mac#%"
fn print_exrat : exrat -> void = "mac#%"
fn prerr_exrat : exrat -> void = "mac#%"
overload fprint with fprint_exrat
overload print with print_exrat
overload prerr with prerr_exrat

(* FIXME: The g0float_exrat_make functions currently cannot handle
          integer values that are outside the range
          [-LONG_MAX,LONG_MAX], or in some cases [LONG_MIN,LONG_MAX]
          or [0,ULONG_MAX]. *)

fn {tk1, tk2 : tkind}
g0float_exrat_make_guint_guint : (g0uint tk1, g0uint tk2) -<> exrat

fn {tk1, tk2 : tkind}
g0float_exrat_make_guint_gint : (g0uint tk1, g0int tk2) -<> exrat

fn {tk1, tk2 : tkind}
g0float_exrat_make_gint_gint : (g0int tk1, g0int tk2) -<> exrat

fn {tk1, tk2 : tkind}
g0float_exrat_make_gint_guint : (g0int tk1, g0uint tk2) -<> exrat

overload g0float_exrat_make with g0float_exrat_make_guint_guint
overload g0float_exrat_make with g0float_exrat_make_guint_gint
overload g0float_exrat_make with g0float_exrat_make_gint_gint
overload g0float_exrat_make with g0float_exrat_make_gint_guint
overload exrat_make with g0float_exrat_make

fn
g0float_exrat_make_string_opt_given_base :
  {base : int | base == 0 || (1 <= base && base <= 62)}
  (string, int base) -<> Option exrat

fn
g0float_exrat_make_string_exn_given_base :
  {base : int | base == 0 || (1 <= base && base <= 62)}
  (string, int base) -< !exn > exrat

fn
g0float_exrat_make_string_opt_base10 :
  string -<> Option exrat

fn
g0float_exrat_make_string_exn_base10 :
  string -< !exn > exrat

overload g0float_exrat_make_string_opt with
  g0float_exrat_make_string_opt_given_base
overload g0float_exrat_make_string_exn with
  g0float_exrat_make_string_exn_given_base
overload g0float_exrat_make_string_opt with
  g0float_exrat_make_string_opt_base10
overload g0float_exrat_make_string_exn with
  g0float_exrat_make_string_exn_base10
overload exrat_make_string_opt with g0float_exrat_make_string_opt
overload exrat_make_string_exn with g0float_exrat_make_string_exn

fn
tostrptr_exrat_given_base :
  {base : int | (~36 <= base && base <= ~2)
                  || (2 <= base && base <= 62)}
  (exrat, int base) -< !wrt > Strptr1 = "mac#%"

fn
tostring_exrat_given_base :
  {base : int | (~36 <= base && base <= ~2)
                  || (2 <= base && base <= 62)}
  (exrat, int base) -<> string = "mac#%"

fn tostrptr_exrat_base10 : exrat -< !wrt > Strptr1 = "mac#%"
fn tostring_exrat_base10 : exrat -<> string = "mac#%"

overload tostrptr_exrat with tostrptr_exrat_given_base
overload tostring_exrat with tostring_exrat_given_base
overload tostrptr_exrat with tostrptr_exrat_base10
overload tostring_exrat with tostring_exrat_base10

fn g0int2float_int8_exrat : int8 -<> exrat = "mac#%"
fn g0int2float_int16_exrat : int16 -<> exrat = "mac#%"
fn g0int2float_int32_exrat : int32 -<> exrat = "mac#%"
fn g0int2float_int64_exrat : int64 -<> exrat = "mac#%"
fn g0int2float_sint_exrat : sint -<> exrat = "mac#%"
fn g0int2float_int_exrat : int -<> exrat = "mac#%"
fn g0int2float_lint_exrat : lint -<> exrat = "mac#%"
fn g0int2float_llint_exrat : llint -<> exrat = "mac#%"
fn g0int2float_ssize_exrat : ssize_t -<> exrat = "mac#%"

fn g0float2int_exrat_int8 : exrat -<> int8 = "mac#%"
fn g0float2int_exrat_int16 : exrat -<> int16 = "mac#%"
fn g0float2int_exrat_int32 : exrat -<> int32 = "mac#%"
fn g0float2int_exrat_int64 : exrat -<> int64 = "mac#%" (* FIXME: On x86, int64 is bigger than lint. This is a bug. *)
fn g0float2int_exrat_sint : exrat -<> sint = "mac#%"
fn g0float2int_exrat_int : exrat -<> int = "mac#%"
fn g0float2int_exrat_lint : exrat -<> lint = "mac#%"
fn g0float2int_exrat_llint : exrat -<> llint = "mac#%" (* FIXME: On x86, llint is bigger than lint. This is a bug. *)
fn g0float2int_exrat_ssize : exrat -<> ssize_t = "mac#%"

fn g0float2float_float_exrat : float -<> exrat = "mac#%"
fn g0float2float_double_exrat : double -<> exrat = "mac#%"
fn g0float2float_ldouble_exrat : ldouble -<> exrat = "mac#%" (* FIXME: The current implementation is quite bad. *)
fn g0float2float_fixed32p32_exrat : fixed32p32 -<> exrat = "mac#%"

fn g0float2float_exrat_float : exrat -<> float = "mac#%"
fn g0float2float_exrat_double : exrat -<> double = "mac#%"
fn g0float2float_exrat_ldouble : exrat -<> ldouble = "mac#%" (* FIXME: The current implementation is quite bad. *)
fn g0float2float_exrat_fixed32p32 : exrat -<> fixed32p32 = "mac#%"

fn g0float2float_exrat_exrat : exrat -<> exrat = "mac#%"

fn g0float_sgn_exrat : g0float_sgn_type exratknd = "mac#%"

fn g0float_neg_exrat : exrat -<> exrat = "mac#%"
fn g0float_abs_exrat : exrat -<> exrat = "mac#%"
fn g0float_fabs_exrat : exrat -<> exrat = "mac#%"

fn g0float_succ_exrat : exrat -<> exrat = "mac#%"
fn g0float_pred_exrat : exrat -<> exrat = "mac#%"

fn g0float_add_exrat : (exrat, exrat) -<> exrat = "mac#%"
fn g0float_sub_exrat : (exrat, exrat) -<> exrat = "mac#%"

fn g0float_min_exrat : (exrat, exrat) -<> exrat = "mac#%"
fn g0float_max_exrat : (exrat, exrat) -<> exrat = "mac#%"

fn g0float_eq_exrat : (exrat, exrat) -<> bool = "mac#%"
fn g0float_neq_exrat : (exrat, exrat) -<> bool = "mac#%"
fn g0float_lt_exrat : (exrat, exrat) -<> bool = "mac#%"
fn g0float_lte_exrat : (exrat, exrat) -<> bool = "mac#%"
fn g0float_gt_exrat : (exrat, exrat) -<> bool = "mac#%"
fn g0float_gte_exrat : (exrat, exrat) -<> bool = "mac#%"

fn g0float_compare_exrat : g0float_compare_type exratknd = "mac#%"

fn g0float_mul_exrat : (exrat, exrat) -<> exrat = "mac#%"
fn g0float_div_exrat : (exrat, exrat) -<> exrat = "mac#%"
fn g0float_fma_exrat : (exrat, exrat, exrat) -<> exrat = "mac#%"

(* Note that g0float_nearbyint_exrat and g0float_rint_exrat are
   equivalent, and that neither respects the IEEE rounding
   direction. Neither do they raise an IEEE exception. *)
fn g0float_round_exrat : exrat -<> exrat = "mac#%"
fn g0float_nearbyint_exrat : exrat -<> exrat = "mac#%"
fn g0float_rint_exrat : exrat -<> exrat = "mac#%"
fn g0float_floor_exrat : exrat -<> exrat = "mac#%"
fn g0float_ceil_exrat : exrat -<> exrat = "mac#%"
fn g0float_trunc_exrat : exrat -<> exrat = "mac#%"

fn g0float_npow_exrat : (exrat, intGte 0) -<> exrat = "mac#%"

(*------------------------------------------------------------------*)
(* Get either the numerator or denominator of an exrat. The result is
   returned as an exrat with denominator 1. *)

fn exrat_numerator : exrat -<> exrat = "mac#%"
fn exrat_denominator : exrat -<> exrat = "mac#%"

(*------------------------------------------------------------------*)
(* Multiplication or division by powers of two. These can be used as
   shift operations. *)

fn exrat_mul_exp2 : (exrat, ulint) -<> exrat = "mac#%"
fn exrat_div_exp2 : (exrat, ulint) -<> exrat = "mac#%"

(*------------------------------------------------------------------*)
(* Aids in using exrat as integers. *)

fn exrat_is_integer : exrat -<> bool = "mac#%"

(* Even and odd tests. These return false if the number is not an
   integer. *)
fn exrat_is_even : exrat -<> bool = "mac#%"
fn exrat_is_odd : exrat -<> bool = "mac#%"

(* Like the POSIX "ffs" function, but for the numerator of an
   exrat. *)
fn exrat_ffs : exrat -<> ulint = "mac#%"

(*------------------------------------------------------------------*)
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

#define ATS_PACKNAME "ats2-xprelude.exrat"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

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
  () -<> void = "mac#my_extern_prefix`'exrat_one_time_initialization"

tkindef exrat_kind = "my_extern_prefix`'exrat"
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

(* FIXME: On x86 and some other platforms, int64, llint, and intmax
          are bigger than lint. This makes the current conversions
          from exrat to those types buggy--the conversion will
          overflow if the value exceeds the limits of a lint. *)
m4_foreachq(`INT',`intbases',
`fn g0int2float_`'INT`'_exrat : m4_g0int(INT) -<> exrat = "mac#%"
fn g0float2int_exrat_`'INT : exrat -<> m4_g0int(INT) = "mac#%"
')dnl

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
fn {tki : tkind} g0float_g0int_pow_exrat : (exrat, g0int tki) -<> exrat

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
dnl
dnl local variables:
dnl mode: ATS
dnl end:

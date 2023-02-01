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

(******************************************************************
  Some floating-point support that is not included in the Postiats
  prelude.
*******************************************************************)

(*------------------------------------------------------------------*)

#define ATS_PACKNAME "ats2-xprelude.float"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

%{#
#include "xprelude/CATS/float.cats"
%}

staload "xprelude/SATS/integer.sats"

(*------------------------------------------------------------------*)

m4_foreachq(`FLT1',`extended_floattypes',
`tkindef FLT1`'_kind = "my_extern_prefix`'FLT1`'"
stadef floatt2pfx(FLT1)`'knd = FLT1`'_kind
typedef FLT1`' = g0float floatt2k(FLT1)

')dnl
(*------------------------------------------------------------------*)
(* Printing. *)

(* I give the overloads precedence 1, so they will take precedence
   over overloads of precedence 0 in the prelude. *)

m4_foreachq(`FLT1',`regular_floattypes',
`fn fprint_`'FLT1 : fprint_type FLT1 = "mac#%"
fn print_`'FLT1 : FLT1 -> void = "mac#%"
fn prerr_`'FLT1 : FLT1 -> void = "mac#%"
overload fprint with fprint_`'FLT1 of 1
overload print with print_`'FLT1 of 1
overload prerr with prerr_`'FLT1 of 1

')dnl
m4_foreachq(`FLT1',`extended_floattypes',
`fn {} fprint_`'FLT1 : fprint_type FLT1
fn {} print_`'FLT1 : FLT1 -> void
fn {} prerr_`'FLT1 : FLT1 -> void
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
(* Type conversions. *)

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
(* g0float_epsilon: the difference between 1 and the least value
   greater than 1.                                                  *)

fn {tk : tkind} g0float_epsilon : () -<> g0float tk

m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_epsilon_`'FLT1 : () -<> g0float floatt2k(FLT1) = "mac#%"
')dnl

overload epsilon with g0float_epsilon

(*------------------------------------------------------------------*)
(* g0float_radix: the radix of the exponent. *)

fn {tk : tkind} g0float_radix : () -<> intGte 2

m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_radix_`'FLT1 : () -<> intGte 2 = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Miscellaneous other floating point parameters. *)

(* HUGE_VAL, etc. *)
fn {tk : tkind} g0float_huge_val : () -<> g0float tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_huge_val_`'FLT1 : $d2ctype (g0float_huge_val<floatt2k(FLT1)>) = "mac#%"
')dnl

overload huge_val with g0float_huge_val

(* FLT_MANT_DIG, etc. *)
fn {tk : tkind} g0float_mant_dig : () -<> intGte 1
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_mant_dig_`'FLT1 : $d2ctype (g0float_mant_dig<floatt2k(FLT1)>) = "mac#%"
')dnl

(* FLT_DECIMAL_DIG, etc. *)
fn {tk : tkind} g0float_decimal_dig : () -<> intGte 1
m4_foreachq(`FLT1',`regular_floattypes, extended_binary_floattypes',
`fn g0float_decimal_dig_`'FLT1 : $d2ctype (g0float_decimal_dig<floatt2k(FLT1)>) = "mac#%"
')dnl

(* FLT_DIG, etc. *)
fn {tk : tkind} g0float_dig : () -<> intGte 1
m4_foreachq(`FLT1',`regular_floattypes, extended_binary_floattypes',
`fn g0float_dig_`'FLT1 : $d2ctype (g0float_dig<floatt2k(FLT1)>) = "mac#%"
')dnl

(* FLT_MIN_EXP, etc. *)
fn {tk : tkind} g0float_min_exp : () -<> int
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_min_exp_`'FLT1 : $d2ctype (g0float_min_exp<floatt2k(FLT1)>) = "mac#%"
')dnl

(* FLT_MIN_10_EXP, etc. *)
fn {tk : tkind} g0float_min_10_exp : () -<> int
m4_foreachq(`FLT1',`regular_floattypes, extended_binary_floattypes',
`fn g0float_min_10_exp_`'FLT1 : $d2ctype (g0float_min_10_exp<floatt2k(FLT1)>) = "mac#%"
')dnl

(* FLT_MAX_EXP, etc. *)
fn {tk : tkind} g0float_max_exp : () -<> int
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_max_exp_`'FLT1 : $d2ctype (g0float_max_exp<floatt2k(FLT1)>) = "mac#%"
')dnl

(* FLT_MAX_10_EXP, etc. *)
fn {tk : tkind} g0float_max_10_exp : () -<> int
m4_foreachq(`FLT1',`regular_floattypes, extended_binary_floattypes',
`fn g0float_max_10_exp_`'FLT1 : $d2ctype (g0float_max_10_exp<floatt2k(FLT1)>) = "mac#%"
')dnl

(* FLT_MAX, etc. *)
fn {tk : tkind} g0float_max_value : () -<> g0float tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_max_value_`'FLT1 : $d2ctype (g0float_max_value<floatt2k(FLT1)>) = "mac#%"
')dnl

(* FLT_MIN, etc. *)
fn {tk : tkind} g0float_min_value : () -<> g0float tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_min_value_`'FLT1 : $d2ctype (g0float_min_value<floatt2k(FLT1)>) = "mac#%"
')dnl

(* FLT_TRUE_MIN, etc. *)
fn {tk : tkind} g0float_true_min_value : () -<> g0float tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_true_min_value_`'FLT1 : $d2ctype (g0float_true_min_value<floatt2k(FLT1)>) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Infinity and NaN. *)

(* Positive infinity. *)
fn {tk : tkind} g0float_infinity : () -<> g0float tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_infinity_`'FLT1 : () -<> FLT1 = "mac#%"
')dnl

overload infinity with g0float_infinity

(* Quiet NaN. *)
fn {tk : tkind} g0float_nan : () -<> g0float tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_nan_`'FLT1 : () -<> FLT1 = "mac#%"
')dnl

(* Signaling NaN. *)
fn {tk : tkind} g0float_snan : () -<> g0float tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_snan_`'FLT1 : () -<> FLT1 = "mac#%"
')dnl

(* Classifications. *)

fn {tk : tkind} g0float_isfinite : g0float tk -<> bool
fn {tk : tkind} g0float_isnormal : g0float tk -<> bool
fn {tk : tkind} g0float_isnan : g0float tk -<> bool
fn {tk : tkind} g0float_isinf : g0float tk -<> bool

m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_isfinite_`'FLT1 : FLT1 -<> bool = "mac#%"
fn g0float_isnormal_`'FLT1 : FLT1 -<> bool = "mac#%"
fn g0float_isnan_`'FLT1 : FLT1 -<> bool = "mac#%"
fn g0float_isinf_`'FLT1 : FLT1 -<> bool = "mac#%"

')dnl
overload isfinite with g0float_isfinite
overload isnormal with g0float_isnormal
overload isnan with g0float_isnan
overload isinf with g0float_isinf

(*------------------------------------------------------------------*)
(* g0float_sgn: the sign of the number. *)

typedef g0float_sgn_type (tk : tkind) = g0float tk -<> [s : sgn] int s

fn {tk : tkind} g0float_sgn : g0float_sgn_type tk

m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_sgn_`'FLT1 : g0float_sgn_type floatt2k(FLT1) = "mac#%"
')dnl

overload sgn with g0float_sgn

(*------------------------------------------------------------------*)
(* g0float_abs: the absolute value of a number. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_abs_`'FLT1 : FLT1 -<> FLT1 = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* g0float_neg: the additive inverse of a number. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_neg_`'FLT1 : FLT1 -<> FLT1 = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* g0float_reciprocal: the multiplicative inverse of a number. *)

(* Inclusion of a multiplicative inverse function is motivated by the
   existence, in GMP, of such a function for exact rationals. *)

fn {tk : tkind}
g0float_reciprocal :
  g0float tk -<> g0float tk

m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_reciprocal_`'FLT1 : FLT1 -<> FLT1 = "mac#%"
')dnl

overload reciprocal with g0float_reciprocal

(*------------------------------------------------------------------*)
(* Unary operations. *)

m4_foreachq(`OP',`unary_ops',
`fn {tk : tkind} g0float_`'OP : g0float_uop_type tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'OP`'_`'FLT1 : g0float_uop_type floatt2k(FLT1) = "mac#%"
')dnl
overload OP with g0float_`'OP

')dnl
(*------------------------------------------------------------------*)
(* Binary operations. *)

m4_foreachq(`OP',`binary_ops',
`fn {tk : tkind} g0float_`'OP : (g0float tk, g0float tk) -<> g0float tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'OP`'_`'FLT1 : (FLT1, FLT1) -<> FLT1 = "mac#%"
')dnl
overload OP with g0float_`'OP

')dnl
overload ** with g0float_pow

(*------------------------------------------------------------------*)
(* Trinary operations. *)

m4_foreachq(`OP',`trinary_ops',
`fn {tk : tkind} g0float_`'OP : (g0float tk, g0float tk, g0float tk) -<> g0float tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'OP`'_`'FLT1 : $d2ctype (g0float_`'OP<floatt2k(FLT1)>) = "mac#%"
')dnl
overload OP with g0float_`'OP

')dnl
(*------------------------------------------------------------------*)
(* (floating point, intmax) operations. *)

m4_foreachq(`OP',`floattype_intmax_ops',
`fn {tk : tkind} g0float_`'OP : (g0float tk, intmax) -<> g0float tk
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'OP`'_`'FLT1 : (FLT1, intmax) -<> FLT1 = "mac#%"
')dnl
overload OP with g0float_`'OP

')dnl
(*------------------------------------------------------------------*)
(* Various other operations. *)

fn {tk : tkind} g0float_scalbn : (g0float tk, int) -<> g0float tk
fn {tk : tkind} g0float_scalbln : (g0float tk, lint) -<> g0float tk
fn {tk : tkind} g0float_ilogb : g0float tk -<> int
fn {tk : tkind} g0float_frexp : (g0float tk, &int? >> int) -< !wrt > g0float tk
fn {tk : tkind} g0float_modf : (g0float tk, &g0float tk? >> g0float tk) -< !wrt > g0float tk
fn {tk : tkind} g0float_unsafe_strfrom : {n : int} (&array (byte?, n) >> array (byte, n), size_t n, string, g0float tk) -< !wrt > int
fn {tk : tkind} g0float_unsafe_strto : (ptr, ptr) -< !wrt > g0float tk

(* A safer interface to strfromd(3) and its relatives. *)
fn {tk : tkind}
g0float_strfrom :
  (string, g0float tk) -< !exnwrt > Strptr1

(* A safer interface to strtod(3) and its relatives. *)
fn {tk : tkind}
g0float_strto :
  {n : int}
  {i : nat | i <= n}
  (string n, size_t i) -<>
    [j : nat | j <= n]
    @(g0float tk, size_t j)

m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_scalbn_`'FLT1 : $d2ctype (g0float_scalbn<floatt2k(FLT1)>) = "mac#%"
fn g0float_scalbln_`'FLT1 : $d2ctype (g0float_scalbln<floatt2k(FLT1)>) = "mac#%"
fn g0float_ilogb_`'FLT1 : $d2ctype (g0float_ilogb<floatt2k(FLT1)>) = "mac#%"
fn g0float_frexp_`'FLT1 : $d2ctype (g0float_frexp<floatt2k(FLT1)>) = "mac#%"
fn g0float_modf_`'FLT1 : $d2ctype (g0float_modf<floatt2k(FLT1)>) = "mac#%"
fn g0float_unsafe_strfrom_`'FLT1 : $d2ctype (g0float_unsafe_strfrom<floatt2k(FLT1)>) = "mac#%"
fn g0float_unsafe_strto_`'FLT1 : $d2ctype (g0float_unsafe_strto<floatt2k(FLT1)>) = "mac#%"

')dnl
(*------------------------------------------------------------------*)
(* Comparisons. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`OP',`lt,lte,gt,gte,eq,neq',
`fn g0float_`'OP`'_`'FLT1 : (FLT1, FLT1) -<> bool = "mac#%"
')
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`OP',`lt,lte,gt,gte,eq,neq',
`fn g0float_is`'OP`'z_`'FLT1 : FLT1 -<> bool = "mac#%"
')
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_compare_`'FLT1 : g0float_compare_type floatt2k(FLT1) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Miscellaneous arithmetic. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`OP',`succ,pred',
`fn g0float_`'OP`'_`'FLT1 : FLT1 -<> FLT1 = "mac#%"
')
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`OP',`min,max,add,sub,mul,div,mod',
`fn g0float_`'OP`'_`'FLT1 : (FLT1, FLT1) -<> FLT1 = "mac#%"
')
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`OP',`npow',
`fn {} g0float_`'OP`'_`'FLT1 : $d2ctype (g0float_`'OP<floatt2k(FLT1)>)
')dnl
')dnl

fn {tk  : tkind}
   {tki : tkind}
g0float_int_pow :
  (g0float tk, g0int tki) -<> g0float tk

m4_foreachq(`FLT1',`conventional_floattypes',
`fn {tki : tkind} g0float_int_pow_`'FLT1 : (FLT1, g0int tki) -<> FLT1
')dnl

(* Overload ** with g0float_int_pow, overriding the overload of
   g0float_npow. The former template function is more general. *)
overload ** with g0float_int_pow of 1

(*------------------------------------------------------------------*)
(* Multiplication or division by powers of two. These can be used as
   binary shift operations, and are motivated by the existence of
   such functions in GMP and MPFR.

   I do allow negative exponents. *)

fn {tk  : tkind}
   {tki : tkind}
g0float_mul_2exp :
  (g0float tk, g0int tki) -<> g0float tk

fn {tk  : tkind}
   {tki : tkind}
g0float_div_2exp :
  (g0float tk, g0int tki) -<> g0float tk

overload mul_2exp with g0float_mul_2exp
overload div_2exp with g0float_div_2exp

(*------------------------------------------------------------------*)
(* Floating point constants. *)

(* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - *)
(* Generic interface. *)

m4_foreachq(`CONST',`list_of_m4_constant',
`(* m4_constant_comment(CONST) *)
fn {tk : tkind} mathconst_`'CONST : () -<> g0float tk

')dnl
(* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - *)
(* GNU-style constant names (see glibc’s /usr/include/math.h). We
   include decimal floating point versions, using the ISO/IEC TS
   18661-3 numeric-literal suffix notation ‘d32’, ‘d64’, ‘d128’. *)

m4_foreachq(`CONST',`list_of_m4_constant',
`(* m4_constant_comment(CONST) *)
m4_foreachq(`FLT1',`conventional_floattypes',
`macdef M_`'CONST`'floatt2sfx(FLT1) = floating_point_constant(FLT1, m4_constant(CONST))
')dnl

')dnl
(*------------------------------------------------------------------*)
(* Value-replacement. *)

(* For ‘unboxed’ types, ‘value-replacement’ merely replaces the
   contents of a variable, array element, etc. For ‘boxed’ types such
   as exrat and mpfr, it instead replaces the value inside the
   ‘box’. *)

(*  -    -    -    -    -    -    -    -    -    -    -    -    -   *)
(* Simple replacement, with potential type conversion. *)

typedef g0float_replace_type (tk : tkind, a : t@ype) =
  (&g0float tk >> _, a) -< !wrt > void

fn {tk1 : tkind}
   {tk2 : tkind}
g0float_float_replace :
  g0float_replace_type (tk1, g0float tk2)

fn {tk1 : tkind}
   {tk2 : tkind}
g0float_int_replace :
  g0float_replace_type (tk1, g0int tk2)

overload g0float_replace with g0float_float_replace
overload g0float_replace with g0float_int_replace
overload replace with g0float_replace

(*  -    -    -    -    -    -    -    -    -    -    -    -    -   *)
(* Value exchange. *)

typedef g0float_exchange_type (tk : tkind) =
  (&g0float tk >> _, &g0float tk >> _) -< !refwrt > void

fn {tk : tkind} g0float_exchange : g0float_exchange_type tk

overload exchange with g0float_exchange

(*  -    -    -    -    -    -    -    -    -    -    -    -    -   *)
(* Assorted operations. *)

m4_foreachq(`OP',`infinity, nan, snan, huge_val',
`fn {tk : tkind} g0float_`'OP`'_replace : (&g0float tk >> _) -< !wrt > void
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'OP`'_replace_`'FLT1 : (&FLT1 >> _) -< !wrt > void
')dnl
overload OP`'_replace with g0float_`'OP`'_replace

')dnl
m4_foreachq(`OP',`abs, neg, reciprocal, succ, pred, unary_ops',
`fn {tk : tkind} g0float_`'OP`'_replace : (&g0float tk >> _, g0float tk) -< !wrt > void
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'OP`'_replace_`'FLT1 : (&FLT1 >> _, FLT1) -< !wrt > void
')dnl
overload OP`'_replace with g0float_`'OP`'_replace

')dnl
m4_foreachq(`OP',`min, max, add, sub, mul, div, mod, binary_ops',
`fn {tk : tkind} g0float_`'OP`'_replace : (&g0float tk >> _, g0float tk, g0float tk) -< !wrt > void
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'OP`'_replace_`'FLT1 : (&FLT1 >> _, FLT1, FLT1) -< !wrt > void
')dnl
overload OP`'_replace with g0float_`'OP`'_replace

')dnl
m4_foreachq(`OP',`trinary_ops',
`fn {tk : tkind} g0float_`'OP`'_replace : (&g0float tk >> _, g0float tk, g0float tk, g0float tk) -< !wrt > void
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'OP`'_replace_`'FLT1 : (&FLT1 >> _, FLT1, FLT1, FLT1) -< !wrt > void
')dnl
overload OP`'_replace with g0float_`'OP`'_replace

')dnl
m4_foreachq(`OP',`floattype_intmax_ops',
`fn {tk : tkind} g0float_`'OP`'_replace : (&g0float tk >> _, g0float tk, intmax) -< !wrt > void
m4_foreachq(`FLT1',`conventional_floattypes',
`fn g0float_`'OP`'_replace_`'FLT1 : (&FLT1 >> _, FLT1, intmax) -< !wrt > void
')dnl
overload OP`'_replace with g0float_`'OP`'_replace

')dnl
fn {tk : tkind}
g0float_npow_replace :
  (&g0float tk >> _, g0float tk, intGte 0) -< !wrt > void
overload npow_replace with g0float_npow_replace

fn {tk  : tkind}
   {tki : tkind}
g0float_int_pow_replace :
  (&g0float tk >> _, g0float tk, g0int tki) -< !wrt > void
overload int_pow_replace with g0float_int_pow_replace

fn {tk  : tkind}
   {tki : tkind}
g0float_mul_2exp_replace :
  (&g0float tk >> _, g0float tk, g0int tki) -< !wrt > void
overload mul_2exp_replace with g0float_mul_2exp_replace

fn {tk  : tkind}
   {tki : tkind}
g0float_div_2exp_replace :
  (&g0float tk >> _, g0float tk, g0int tki) -< !wrt > void
overload div_2exp_replace with g0float_div_2exp_replace

fn {tk : tkind}
g0float_unsafe_strto_replace :
  (&g0float tk >> _, ptr, ptr) -< !wrt > void

fn {tk : tkind}
g0float_strto_replace :
  {n : int}
  {i : nat | i <= n}
  (&g0float tk >> _, &size_t? >> size_t j, string n, size_t i) -< !wrt >
    #[j : nat | j <= n]
    void

m4_foreachq(`CONST',`list_of_m4_constant',
`fn {tk : tkind} mathconst_`'CONST`'_replace : (&g0float tk >> _) -< !wrt > void
')dnl

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

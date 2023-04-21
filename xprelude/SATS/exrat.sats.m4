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

(* You can use this if you do not want to replace the memory
   management for GMP. An example would be if you are using libguile
   and have already initialized that. You may wish to leave GMP as
   libguile had set it. *)
fn
leave_gmp_memory_management_alone :
  () -> void = "mac#my_extern_prefix`'mark_gmp_initialized"

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

(*------------------------------------------------------------------*)

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

fn g0float_reciprocal_exrat : exrat -<> exrat = "mac#%"

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
fn {tki : tkind} g0float_int_pow_exrat : (exrat, g0int tki) -<> exrat

(*------------------------------------------------------------------*)
(* Multiplication or division by powers of two. These can be used as
   shift operations. *)

fn {tki : tkind} g0float_mul_2exp_exrat : (exrat, g0int tki) -<> exrat
fn {tki : tkind} g0float_div_2exp_exrat : (exrat, g0int tki) -<> exrat

(*------------------------------------------------------------------*)
(* Get either the numerator or denominator of an exrat. The result is
   returned as an exrat with denominator equal to 1. *)

fn exrat_numerator : exrat -<> exrat = "mac#%"
fn exrat_denominator : exrat -<> exrat = "mac#%"

(*------------------------------------------------------------------*)
(* Aids in using exrat as integers. *)

fn exrat_is_integer : exrat -<> bool = "mac#%"

(*  -    -    -    -    -    -    -    -    -    -    -    -    -   *)
(* Operations on the numerators of exrats. These operations ignore the
   denominators. Integer values are returned as exrat with denominator
   equal to 1. *)

fn exrat_numerator_is_even : exrat -<> bool = "mac#%"
fn exrat_numerator_is_odd : exrat -<> bool = "mac#%"
fn exrat_numerator_is_perfect_power : exrat -<> bool = "mac#%"
fn exrat_numerator_is_perfect_square : exrat -<> bool = "mac#%"

(* ‘Find first set’: like the POSIX "ffs" function. *)
fn exrat_numerator_ffs : exrat -<> uintmax = "mac#%"

(* Bitwise logical operations. *)
fn exrat_numerator_land : (exrat, exrat) -<> exrat = "mac#%"
fn exrat_numerator_lor : (exrat, exrat) -<> exrat = "mac#%"
fn exrat_numerator_lxor : (exrat, exrat) -<> exrat = "mac#%"
fn exrat_numerator_lnot : exrat -<> exrat = "mac#%"

(* Bit access by index (index = 0 for the least significant bit). *)
fn exrat_numerator_bit_ltest : (exrat, uintmax) -<> natLte 1 = "mac#%"
fn exrat_numerator_bit_lset : (exrat, uintmax, natLte 1) -<> exrat = "mac#%"
fn exrat_numerator_bit_lnot : (exrat, uintmax) -<> exrat = "mac#%"

(* Population count and Hamming distance. A very large integer will be
   returned, if the count/distance is actually infinite. *)
fn exrat_numerator_popcount : exrat -<> uintmax = "mac#%"
fn exrat_numerator_hamming_distance : (exrat, exrat) -<> uintmax = "mac#%"

(* Integer nth root. *)
fn exrat_numerator_root : (exrat, ulint) -<> exrat = "mac#%"
fn exrat_numerator_rootrem : (exrat, ulint) -<> @(exrat, exrat)

(* Integer square root. *)
fn exrat_numerator_sqrt : exrat -<> exrat = "mac#%"
fn exrat_numerator_sqrtrem : exrat -<> @(exrat, exrat)

(* Greatest common divisor and least common multiple. *)
fn exrat_numerator_gcd : (exrat, exrat) -<> exrat = "mac#%"
fn exrat_numerator_lcm : (exrat, exrat) -<> exrat = "mac#%"

(* Find the greatest common divisor and find a solution of its Bézout
   identity. *)
fn exrat_numerator_gcd_bezout : (exrat, exrat) -<> (exrat, exrat, exrat)

(* Legendre, Jacobi, Kronecker symbols. *)
fn exrat_numerator_legendre_symbol : (exrat, exrat) -<> int = "mac#%"
fn exrat_numerator_jacobi_symbol : (exrat, exrat) -<> int = "mac#%"
fn exrat_numerator_kronecker_symbol : (exrat, exrat) -<> int = "mac#%"

(* Remove all occurrences of a factor (the second argument) from the
   first argument, and return also the multiplicity of the factor. *)
fn exrat_numerator_remove_factor : (exrat, exrat) -<> @(exrat, uintmax)

(* The ordinary single factorial. *)
fn exrat_factorial : ulint -<> exrat = "mac#%"

(* Double factorial: the product of integers having the same parity
   (odd or even) as the argument. *)
fn exrat_double_factorial : ulint -<> exrat = "mac#%"

(* The multiple factorial: the product of integers separated from each
   other by a given amount. *)
fn exrat_multifactorial : (ulint, ulint) -<> exrat = "mac#%"

(* Primorial: the product of prime numbers no greater than the
   argument. *)
fn exrat_primorial : ulint -<> exrat = "mac#%"

(* Binomial coefficients. The first form accepts negative values of
   the first argument: C(n,k) = (-1)**k * C(-n+k-1,k), for n<0. *)
fn exrat_numerator_bincoef : (exrat, ulint) -<> exrat = "mac#%"
fn exrat_bincoef : (ulint, ulint) -<> exrat = "mac#%"

(* Calculation of a Fibonacci or Lucas number. *)
fn exrat_fibonacci_number : ulint -<> exrat = "mac#%"
fn exrat_lucas_number : ulint -<> exrat = "mac#%"

(* Calculation of two adjacent Fibonacci or Lucas numbers. You can
   use these two numbers as the start of a Fibonacci sequence. *)
fn exrat_two_fibonacci_numbers : ulint -<> @(exrat, exrat)
fn exrat_two_lucas_numbers : ulint -<> @(exrat, exrat)

(*  -    -    -    -    -    -    -    -    -    -    -    -    -   *)
(* Integer division. The ‘euclid’ versions are for division with a
   remainder that is never negative. *)

m4_foreachq(`ROUND',`euclid, floor, ceil, trunc',
`fn exrat_numerator_`'ROUND`'_quotient : (exrat, exrat) -<> exrat = "mac#%"
fn exrat_numerator_`'ROUND`'_remainder : (exrat, exrat) -<> exrat = "mac#%"
fn exrat_numerator_`'ROUND`'_division : (exrat, exrat) -<> @(exrat, exrat)
')dnl

(* Division by a power of two. *)
m4_foreachq(`ROUND',`euclid, floor, ceil, trunc',
`fn exrat_numerator_`'ROUND`'_quotient_2exp : (exrat, uintmax) -<> exrat = "mac#%"
fn exrat_numerator_`'ROUND`'_remainder_2exp : (exrat, uintmax) -<> exrat = "mac#%"
')dnl

(*  -    -    -    -    -    -    -    -    -    -    -    -    -   *)
(* Modular operations. *)

(* Modular congruence. *)
fn exrat_numerator_congruent : (exrat, exrat, exrat) -<> bool = "mac#%"

(* Congruence modulo a power of two. *)
fn exrat_numerator_congruent_2exp : (exrat, exrat, uintmax) -<> bool = "mac#%"

(* Invert the numerator of the first argument modulo the numerator of
   the second argument. *)
fn exrat_numerator_modular_inverse : (exrat, exrat) -<> Option exrat

(* Modular powers. *)
fn exrat_numerator_modular_pow : (exrat, exrat, exrat) -<> exrat = "mac#%"

(*  -    -    -    -    -    -    -    -    -    -    -    -    -   *)
(* Probabilistic algorithms regarding prime numbers. *)

datatype prime_test_result =
  | definitely_not_prime
  | probably_prime
  | definitely_prime
fn exrat_numerator_prime_test :
  (exrat, (* repetitions *) intGte 1) -<> prime_test_result

fn exrat_numerator_probable_next_prime : exrat -<> exrat = "mac#%"

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

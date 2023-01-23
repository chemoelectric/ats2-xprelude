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

#define ATS_DYNLOADFLAG 0

#define ATS_PACKNAME "ats2-xprelude.fixed32p32"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload "xprelude/SATS/fixed32p32.sats"

(*------------------------------------------------------------------*)

implement {}
fprint_fixed32p32 (outf, x) =
  fileref_puts (outf, tostring_fixed32p32 x)

implement {}
print_fixed32p32 x =
  fprint_fixed32p32 (stdout_ref, x)

implement {}
prerr_fixed32p32 x =
  fprint_fixed32p32 (stderr_ref, x)

implement fprint_val<fixed32p32> = fprint_fixed32p32

implement {} fixed32p32$decimal_places () = 6

implement {}
tostrptr_fixed32p32_assumed_decimal_places x =
  let
    val decimal_places = fixed32p32$decimal_places<> ()
  in
    tostrptr_fixed32p32_given_decimal_places (x, decimal_places)
  end

implement {}
tostring_fixed32p32_assumed_decimal_places x =
  let
    val decimal_places = fixed32p32$decimal_places<> ()
  in
    tostring_fixed32p32_given_decimal_places (x, decimal_places)
  end

implement g0float_epsilon<fix32p32knd> = g0float_epsilon_fixed32p32

m4_foreachq(`INT',`intbases',
`implement g0int2float<intb2k(INT),fix32p32knd> = g0int2float_`'INT`'_fixed32p32
implement g0float2int<fix32p32knd,intb2k(INT)> = g0float2int_fixed32p32_`'INT
')dnl

m4_foreachq(`FLT',`conventional_floattypes',
`implement g0float2float<floatt2k(FLT),fix32p32knd> = g0float2float_`'FLT`'_fixed32p32
implement g0float2float<fix32p32knd,floatt2k(FLT)> = g0float2float_fixed32p32_`'FLT
')dnl
implement g0float2float<fix32p32knd,fix32p32knd> = g0float2float_fixed32p32_fixed32p32

implement g0float_sgn<fix32p32knd> = g0float_sgn_fixed32p32

implement g0float_neg<fix32p32knd> = g0float_neg_fixed32p32
implement g0float_abs<fix32p32knd> = g0float_abs_fixed32p32
implement g0float_fabs<fix32p32knd> = g0float_fabs_fixed32p32

implement g0float_succ<fix32p32knd> = g0float_succ_fixed32p32
implement g0float_pred<fix32p32knd> = g0float_pred_fixed32p32

implement g0float_add<fix32p32knd> = g0float_add_fixed32p32
implement g0float_sub<fix32p32knd> = g0float_sub_fixed32p32

implement g0float_min<fix32p32knd> = g0float_min_fixed32p32
implement g0float_max<fix32p32knd> = g0float_max_fixed32p32

implement g0float_eq<fix32p32knd> = g0float_eq_fixed32p32
implement g0float_neq<fix32p32knd> = g0float_neq_fixed32p32
implement g0float_lt<fix32p32knd> = g0float_lt_fixed32p32
implement g0float_lte<fix32p32knd> = g0float_lte_fixed32p32
implement g0float_gt<fix32p32knd> = g0float_gt_fixed32p32
implement g0float_gte<fix32p32knd> = g0float_gte_fixed32p32

implement g0float_compare<fix32p32knd> = g0float_compare_fixed32p32

implement gequal_val_val<fixed32p32> = g0float_eq<fix32p32knd>
implement gcompare_val_val<fixed32p32> = g0float_compare<fix32p32knd>

implement g0float_mul<fix32p32knd> = g0float_mul_fixed32p32
implement g0float_div<fix32p32knd> = g0float_div_fixed32p32

implement g0float_fma<fix32p32knd> = g0float_fma_fixed32p32

implement g0float_round<fix32p32knd> = g0float_round_fixed32p32
implement g0float_nearbyint<fix32p32knd> = g0float_nearbyint_fixed32p32
implement g0float_rint<fix32p32knd> = g0float_rint_fixed32p32
implement g0float_floor<fix32p32knd> = g0float_floor_fixed32p32
implement g0float_ceil<fix32p32knd> = g0float_ceil_fixed32p32
implement g0float_trunc<fix32p32knd> = g0float_trunc_fixed32p32

implement g0float_sqrt<fix32p32knd> = g0float_sqrt_fixed32p32

(*------------------------------------------------------------------*)
(* g0float_npow *)

extern fn _g0float_npow_fixed32p32 : $d2ctype (g0float_npow<fix32p32knd>)
dnl
if_COMPILING_IMPLEMENTATIONS(
`implement _g0float_npow_fixed32p32 (x, n) = g0float_npow<fix32p32knd> (x, n)
')dnl

if_not_COMPILING_IMPLEMENTATIONS(
`implement {} g0float_npow_fixed32p32 (x, n) = _g0float_npow_fixed32p32 (x, n)
implement g0float_npow<fix32p32knd> = g0float_npow_fixed32p32<>
')dnl

(*------------------------------------------------------------------*)
(* g0float_g0int_pow *)

extern fn
_g0float_intmax_pow_fixed32p32 :
  $d2ctype (g0float_g0int_pow<fix32p32knd><intmaxknd>)
dnl
if_COMPILING_IMPLEMENTATIONS(
`implement
_g0float_intmax_pow_fixed32p32 (x, n) =
  g0float_g0int_pow<fix32p32knd><intmaxknd> (x, n)
')dnl

if_not_COMPILING_IMPLEMENTATIONS(
`m4_foreachq(`INT',`conventional_intbases',
`implement
g0float_g0int_pow_fixed32p32<intb2k(INT)> (x, n) =
  _g0float_intmax_pow_fixed32p32
    (x, g0int2int<intb2k(INT),intmaxknd> n)

implement
g0float_g0int_pow<fix32p32knd><intb2k(INT)> =
  g0float_g0int_pow_fixed32p32<intb2k(INT)>
')dnl
')dnl

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

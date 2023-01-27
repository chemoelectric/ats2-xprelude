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
#include "prelude/lmacrodef.hats"
#include "xprelude/HATS/xprelude.hats"

staload "xprelude/SATS/fixed32p32.sats"

(*------------------------------------------------------------------*)
(* Printing. *)

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

(*------------------------------------------------------------------*)
(* Conversion to string. *)

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

(*------------------------------------------------------------------*)
(* Value-replacement. *)

(* It is safer to have only type-specific implementations of
   these. Otherwise the implementation may easily be incorrect for
   ‘boxed’ types such as exrat and mpfr. *)

m4_foreachq(`FLT1',`fixed32p32',
`m4_foreachq(`FLT2',`conventional_floattypes',
`implement g0float_float_replace<floatt2k(FLT1)><floatt2k(FLT2)> (x, y) = x := g0f2f y
implement g0float_float_replace<floatt2k(FLT2)><floatt2k(FLT1)> (x, y) = x := g0f2f y
')dnl
')dnl

m4_foreachq(`FLT1',`fixed32p32',
`m4_foreachq(`INT',`intbases',
`implement g0float_int_replace<floatt2k(FLT1)><intb2k(INT)> (x, y) = x := g0i2f y
')dnl
')dnl

m4_foreachq(`FLT1',`fixed32p32',
`implement g0float_exchange<floatt2k(FLT1)> (x, y) = x :=: y
')dnl

(*------------------------------------------------------------------*)
(* Epsilon. *)

implement g0float_epsilon<fix32p32knd> = g0float_epsilon_fixed32p32

(*------------------------------------------------------------------*)
(* Type conversions. *)

m4_foreachq(`INT',`intbases',
`implement g0int2float<intb2k(INT),fix32p32knd> = g0int2float_`'INT`'_fixed32p32
implement g0float2int<fix32p32knd,intb2k(INT)> = g0float2int_fixed32p32_`'INT
')dnl

m4_foreachq(`FLT',`conventional_floattypes',
`implement g0float2float<floatt2k(FLT),fix32p32knd> = g0float2float_`'FLT`'_fixed32p32
implement g0float2float<fix32p32knd,floatt2k(FLT)> = g0float2float_fixed32p32_`'FLT
')dnl
implement g0float2float<fix32p32knd,fix32p32knd> = g0float2float_fixed32p32_fixed32p32

(*------------------------------------------------------------------*)
(* Various operations and functions. *)

m4_foreachq(`FUNC',`sgn, neg, abs, fabs, succ, pred,
                    add, sub, mul, div, fma,
                    min, max,
                    lt, lte, gt, gte, eq, neq, compare,
                    round, nearbyint, rint, floor, ceil, trunc,
                    sqrt',
`implement g0float_`'FUNC<fix32p32knd> = g0float_`'FUNC`'_fixed32p32
')dnl

(*------------------------------------------------------------------*)
(* Generic operations. *)

implement gequal_val_val<fixed32p32> = g0float_eq<fix32p32knd>
implement gcompare_val_val<fixed32p32> = g0float_compare<fix32p32knd>

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
(* g0float_int_pow *)

extern fn
_g0float_intmax_pow_fixed32p32 :
  $d2ctype (g0float_int_pow<fix32p32knd><intmaxknd>)
dnl
if_COMPILING_IMPLEMENTATIONS(
`implement
_g0float_intmax_pow_fixed32p32 (x, n) =
  g0float_int_pow<fix32p32knd><intmaxknd> (x, n)
')dnl

if_not_COMPILING_IMPLEMENTATIONS(
`m4_foreachq(`INT',`conventional_intbases',
`implement
g0float_int_pow_fixed32p32<intb2k(INT)> (x, n) =
  _g0float_intmax_pow_fixed32p32
    (x, g0int2int<intb2k(INT),intmaxknd> n)

implement
g0float_int_pow<fix32p32knd><intb2k(INT)> =
  g0float_int_pow_fixed32p32<intb2k(INT)>
')dnl
')dnl

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

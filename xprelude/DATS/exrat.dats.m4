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

#define ATS_PACKNAME "ats2-xprelude.exrat"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload "xprelude/SATS/fixed32p32.sats"
staload "xprelude/SATS/exrat.sats"

implement fprint_val<exrat> = fprint_exrat

implement {tk1, tk2}
g0float_exrat_make_guint_guint (n, d) =
  let
    extern fn
    g0float_exrat_make_ulint_ulint :
      (ulint, ulint) -<> exrat = "mac#%"
  in
    g0float_exrat_make_ulint_ulint (g0u2u n, g0u2u d)
  end

implement {tk1, tk2}
g0float_exrat_make_gint_guint (n, d) =
  let
    extern fn
    g0float_exrat_make_lint_ulint :
      (lint, ulint) -<> exrat = "mac#%"
  in
    g0float_exrat_make_lint_ulint (g0i2i n, g0u2u d)
  end

implement {tk1, tk2}
g0float_exrat_make_guint_gint (n, d) =
  if d < g0i2i 0 then
    ~g0float_exrat_make_guint_guint<ulintknd,ulintknd>
      (g0u2u n, g0i2u ~((g0i2i d) : lint))
  else
    g0float_exrat_make_guint_guint<ulintknd,ulintknd>
      (g0u2u n, g0i2u d)

implement {tk1, tk2}
g0float_exrat_make_gint_gint (n, d) =
  if d < g0i2i 0 then
    ~g0float_exrat_make_gint_guint<lintknd,ulintknd>
      (g0i2i n, g0i2u ~((g0i2i d) : lint))
  else
    g0float_exrat_make_gint_guint<lintknd,ulintknd>
      (g0i2i n, g0i2u d)

implement tostrptr_val<exrat> = tostrptr_exrat_base10
implement tostring_val<exrat> = tostring_exrat_base10

m4_foreachq(`INT',`intbases',
`implement g0int2float<intb2k(INT),exratknd> = g0int2float_`'INT`'_exrat
implement g0float2int<exratknd,intb2k(INT)> = g0float2int_exrat_`'INT
')dnl

implement g0float2float<fltknd,exratknd> = g0float2float_float_exrat
implement g0float2float<dblknd,exratknd> = g0float2float_double_exrat
implement g0float2float<ldblknd,exratknd> = g0float2float_ldouble_exrat
implement g0float2float<fix32p32knd,exratknd> = g0float2float_fixed32p32_exrat

implement g0float2float<exratknd,fltknd> = g0float2float_exrat_float
implement g0float2float<exratknd,dblknd> = g0float2float_exrat_double
implement g0float2float<exratknd,ldblknd> = g0float2float_exrat_ldouble
implement g0float2float<exratknd,fix32p32knd> = g0float2float_exrat_fixed32p32

implement g0float2float<exratknd,exratknd> = g0float2float_exrat_exrat

m4_foreachq(`OP',`sgn, neg, reciprocal, abs, fabs,
                  succ, pred,
                  add, sub, mul, div, fma, npow,
                  min, max,
                  lt, lte, gt, gte, eq, neq, compare,
                  round, nearbyint, rint, floor, ceil, trunc',
`implement g0float_`'OP<exratknd> = g0float_`'OP`'_exrat
')dnl

implement gequal_val_val<exrat> = g0float_eq<exratknd>
implement gcompare_val_val<exrat> = g0float_compare<exratknd>

(* Optimized comparisons with zero. *)
implement g0float_isltz<exratknd> x = (g0float_sgn_exrat x < 0)
implement g0float_isltez<exratknd> x = (g0float_sgn_exrat x <= 0)
implement g0float_isgtz<exratknd> x = (g0float_sgn_exrat x > 0)
implement g0float_isgtez<exratknd> x = (g0float_sgn_exrat x >= 0)
implement g0float_iseqz<exratknd> x = (g0float_sgn_exrat x = 0)
implement g0float_isneqz<exratknd> x = (g0float_sgn_exrat x <> 0)

(*------------------------------------------------------------------*)

extern fn
_g0float_intmax_pow_exrat :
  $d2ctype (g0float_int_pow<exratknd><intmaxknd>) = "mac#%"

implement {tki}
g0float_int_pow_exrat (x, n) =
  _g0float_intmax_pow_exrat (x, g0int2int<tki,intmaxknd> n)

m4_foreachq(`INT',`conventional_intbases',
`implement
g0float_int_pow<exratknd><intb2k(INT)> =
  g0float_int_pow_exrat<intb2k(INT)>

')dnl
(*------------------------------------------------------------------*)
(* mul_2exp and div_2exp. *)

extern fn
_g0float_mul_2exp_intmax_exrat :
  $d2ctype (g0float_mul_2exp<exratknd><intmaxknd>) = "mac#%"

implement {tki}
g0float_mul_2exp_exrat (x, n) =
  _g0float_mul_2exp_intmax_exrat (x, g0int2int<tki,intmaxknd> n)

implement {tki}
g0float_div_2exp_exrat (x, n) =
  _g0float_mul_2exp_intmax_exrat (x, ~(g0int2int<tki,intmaxknd> n))

m4_foreachq(`INT',`conventional_intbases',
`implement
g0float_mul_2exp<exratknd><intb2k(INT)> =
  g0float_mul_2exp_exrat<intb2k(INT)>

implement
g0float_div_2exp<exratknd><intb2k(INT)> =
  g0float_div_2exp_exrat<intb2k(INT)>

')dnl
(*------------------------------------------------------------------*)
(* Integer operations. *)

implement {}
exrat_numerator_rootrem (x, n) =
  let
    extern fn
    _exrat_numerator_rootrem :
      (&exrat >> _, &exrat >> _, exrat, ulint) -< !wrt > void = "mac#%"

    var q : exrat = g0i2f 0
    var r : exrat = g0i2f 0
  in
    $effmask_wrt _exrat_numerator_rootrem (q, r, x, n);
    @(q, r)
  end

implement {}
exrat_numerator_sqrtrem x =
  let
    extern fn
    _exrat_numerator_sqrtrem :
      (&exrat >> _, &exrat >> _, exrat) -< !wrt > void = "mac#%"

    var q : exrat = g0i2f 0
    var r : exrat = g0i2f 0
  in
    $effmask_wrt _exrat_numerator_sqrtrem (q, r, x);
    @(q, r)
  end

implement {}
exrat_numerator_gcdext (a, b) =
  let
    extern fn
    _exrat_numerator_gcdext :
      (&exrat >> _, &exrat >> _, &exrat >> _, exrat, exrat) -< !wrt > void = "mac#%"

    var g : exrat = g0i2f 0
    var s : exrat = g0i2f 0
    var t : exrat = g0i2f 0
  in
    $effmask_wrt _exrat_numerator_gcdext (g, s, t, a, b);
    @(g, s, t)
  end

implement {}
exrat_numerator_modular_inverse (x, y) =
  let
    extern fn
    _exrat_numerator_modular_inverse :
      (&bool? >> bool, &exrat >> _, exrat, exrat) -< !wrt > void = "mac#%"

    var success : bool
    var z : exrat = g0i2f 0
  in
    $effmask_wrt _exrat_numerator_modular_inverse (success, z, x, y);
    if success then
      Some z
    else
      None ()
  end

(*------------------------------------------------------------------*)
(* Value replacement. *)

value_replacement_runtime_for_boxed_types(`exrat',`floattypes_without_exrat')
(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:
dnl

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

#define ATS_DYNLOADFLAG 0

#define ATS_PACKNAME "ats2-xprelude.exrat"
#define ATS_EXTERN_PREFIX "ats2_xprelude_"

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

implement g0int2float<int8knd,exratknd> = g0int2float_int8_exrat
implement g0int2float<int16knd,exratknd> = g0int2float_int16_exrat
implement g0int2float<int32knd,exratknd> = g0int2float_int32_exrat
implement g0int2float<int64knd,exratknd> = g0int2float_int64_exrat
implement g0int2float<sintknd,exratknd> = g0int2float_sint_exrat
implement g0int2float<intknd,exratknd> = g0int2float_int_exrat
implement g0int2float<lintknd,exratknd> = g0int2float_lint_exrat
implement g0int2float<llintknd,exratknd> = g0int2float_llint_exrat
implement g0int2float<ssizeknd,exratknd> = g0int2float_ssize_exrat

implement g0float2int<exratknd,int8knd> = g0float2int_exrat_int8
implement g0float2int<exratknd,int16knd> = g0float2int_exrat_int16
implement g0float2int<exratknd,int32knd> = g0float2int_exrat_int32
implement g0float2int<exratknd,int64knd> = g0float2int_exrat_int64
implement g0float2int<exratknd,sintknd> = g0float2int_exrat_sint
implement g0float2int<exratknd,intknd> = g0float2int_exrat_int
implement g0float2int<exratknd,lintknd> = g0float2int_exrat_lint
implement g0float2int<exratknd,llintknd> = g0float2int_exrat_llint
implement g0float2int<exratknd,ssizeknd> = g0float2int_exrat_ssize

implement g0float2float<fltknd,exratknd> = g0float2float_float_exrat
implement g0float2float<dblknd,exratknd> = g0float2float_double_exrat
implement g0float2float<ldblknd,exratknd> = g0float2float_ldouble_exrat
implement g0float2float<fix32p32knd,exratknd> = g0float2float_fixed32p32_exrat

implement g0float2float<exratknd,fltknd> = g0float2float_exrat_float
implement g0float2float<exratknd,dblknd> = g0float2float_exrat_double
implement g0float2float<exratknd,ldblknd> = g0float2float_exrat_ldouble
implement g0float2float<exratknd,fix32p32knd> = g0float2float_exrat_fixed32p32

implement g0float2float<exratknd,exratknd> = g0float2float_exrat_exrat

implement g0float_sgn<exratknd> = g0float_sgn_exrat

implement g0float_neg<exratknd> = g0float_neg_exrat
implement g0float_abs<exratknd> = g0float_abs_exrat
implement g0float_fabs<exratknd> = g0float_fabs_exrat

implement g0float_succ<exratknd> = g0float_succ_exrat
implement g0float_pred<exratknd> = g0float_pred_exrat

implement g0float_add<exratknd> = g0float_add_exrat
implement g0float_sub<exratknd> = g0float_sub_exrat

implement g0float_min<exratknd> = g0float_min_exrat
implement g0float_max<exratknd> = g0float_max_exrat

implement g0float_eq<exratknd> = g0float_eq_exrat
implement g0float_neq<exratknd> = g0float_neq_exrat
implement g0float_lt<exratknd> = g0float_lt_exrat
implement g0float_lte<exratknd> = g0float_lte_exrat
implement g0float_gt<exratknd> = g0float_gt_exrat
implement g0float_gte<exratknd> = g0float_gte_exrat

implement gequal_val_val<exrat> (x, y) = g0float_eq<exratknd> (x, y)

implement g0float_compare<exratknd> = g0float_compare_exrat

implement g0float_mul<exratknd> = g0float_mul_exrat
implement g0float_div<exratknd> = g0float_div_exrat
implement g0float_fma<exratknd> = g0float_fma_exrat

implement g0float_round<exratknd> = g0float_round_exrat
implement g0float_nearbyint<exratknd> = g0float_nearbyint_exrat
implement g0float_rint<exratknd> = g0float_rint_exrat
implement g0float_floor<exratknd> = g0float_floor_exrat
implement g0float_ceil<exratknd> = g0float_ceil_exrat
implement g0float_trunc<exratknd> = g0float_trunc_exrat

implement g0float_npow<exratknd> = g0float_npow_exrat

(* Optimized comparisons with zero. *)
implement g0float_isltz<exratknd> x = (g0float_sgn_exrat x < 0)
implement g0float_isltez<exratknd> x = (g0float_sgn_exrat x <= 0)
implement g0float_isgtz<exratknd> x = (g0float_sgn_exrat x > 0)
implement g0float_isgtez<exratknd> x = (g0float_sgn_exrat x >= 0)
implement g0float_iseqz<exratknd> x = (g0float_sgn_exrat x = 0)
implement g0float_isneqz<exratknd> x = (g0float_sgn_exrat x <> 0)

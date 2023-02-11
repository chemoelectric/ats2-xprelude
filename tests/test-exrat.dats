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

#define ATS_EXTERN_PREFIX "ats2_xprelude_"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload UN = "prelude/SATS/unsafe.sats"

staload "xprelude/SATS/fixed32p32.sats"
staload _ = "xprelude/DATS/fixed32p32.dats"

staload "xprelude/SATS/exrat.sats"
staload _ = "xprelude/DATS/exrat.dats"

macdef i2ex = g0int2float<intknd,exratknd>
macdef f2ex = g0float2float<fltknd,exratknd>
macdef d2ex = g0float2float<dblknd,exratknd>

(* Code coverage for 32-bit support, even on platforms where it is not
   used. *)
macdef int64_to_exrat_32bit (x) =
  $extfcall (exrat,
             "ats2_xprelude_g0int2float_int64_exrat_32bit",
             ,(x))
macdef llint_to_exrat_32bit (x) =
  $extfcall (exrat,
             "ats2_xprelude_g0int2float_llint_exrat_32bit",
             ,(x))
macdef intmax_to_exrat_32bit (x) =
  $extfcall (exrat,
             "ats2_xprelude_g0int2float_intmax_exrat_32bit",
             ,(x))
macdef fixed2exrat_32bit (x) =
  $extfcall (exrat,
             "ats2_xprelude_g0float2float_fixed32p32_exrat_32bit",
             ,(x))
macdef exrat2fixed_32bit (x) =
  $extfcall (fixed32p32,
             "ats2_xprelude_g0float2float_exrat_fixed32p32_32bit",
             ,(x))

fn
test0 () : void =
  let
    val x : exrat = g0i2f 12345

    val- true = f2ex 1234.5F * i2ex 2 = i2ex 2469
    val- true = d2ex 1234.5 * i2ex 2 = i2ex 2469

    val- true = ~x = i2ex ~12345
    val- true = ~(~x) = x

    val- true = reciprocal x = exrat_make (1, 12345)
    val- true = reciprocal (exrat_make (~1, 12345)) = ~x

    val- true = abs (~x) = x
    val- true = abs x = x
    val- true = fabs x = x

    val- true = succ x = i2ex 12346
    val- true = pred x = i2ex 12344

    val- true = x + i2ex 111 = i2ex 12456
    val- true = x - i2ex 111 = i2ex 12234

    val- true = min (x, i2ex 12344) = i2ex 12344
    val- true = min (x, i2ex 12345) = i2ex 12345
    val- true = min (x, i2ex 12346) = i2ex 12345

    val- true = max (x, i2ex 12344) = i2ex 12345
    val- true = max (x, i2ex 12345) = i2ex 12345
    val- true = max (x, i2ex 12346) = i2ex 12346

    val- true = x * i2ex 2 = i2ex 24690
    val- true = i2ex 2 * (x / i2ex 2) = i2ex 12345
    val- true = x * (i2ex 2 / x) = i2ex 2
    val- true = fma (x, i2ex 2, i2ex 111) = i2ex 24801

    val- false = gequal_val_val<exrat> (x, i2ex 12344)
    val- true = gequal_val_val<exrat> (x, i2ex 12345)
    val- false = gequal_val_val<exrat> (x, i2ex 12346)

    val- false = x = i2ex 12344
    val- true = x = i2ex 12345
    val- false = x = i2ex 12346

    val- true = x <> i2ex 12344
    val- false = x <> i2ex 12345
    val- true = x <> i2ex 12346

    val- false = x < i2ex 12344
    val- false = x < i2ex 12345
    val- true = x < i2ex 12346

    val- false = x <= i2ex 12344
    val- true = x <= i2ex 12345
    val- true = x <= i2ex 12346

    val- true = x > i2ex 12344
    val- false = x > i2ex 12345
    val- false = x > i2ex 12346

    val- true = x >= i2ex 12344
    val- true = x >= i2ex 12345
    val- false = x >= i2ex 12346

    val- true = compare (x, i2ex 12344) > 0
    val- true = compare (x, i2ex 12345) = 0
    val- true = compare (x, i2ex 12346) < 0

    val- true = gcompare_val_val<exrat> (x, i2ex 12344) > 0
    val- true = gcompare_val_val<exrat> (x, i2ex 12345) = 0
    val- true = gcompare_val_val<exrat> (x, i2ex 12346) < 0

    val- true = g0float_npow ((i2ex 3), 0) = i2ex 1
    val- true = g0float_npow ((i2ex 3), 1) = i2ex 3
    val- true = g0float_npow ((i2ex 3), 2) = i2ex 9
    val- true = g0float_npow ((i2ex 3), 3) = i2ex 27
    val- true = g0float_npow ((i2ex 3), 4) = i2ex 81
    val- true = g0float_npow ((i2ex 3), 5) = i2ex 243

    val- true = g0float_npow ((i2ex ~3), 0) = i2ex 1
    val- true = g0float_npow ((i2ex ~3), 1) = i2ex ~3
    val- true = g0float_npow ((i2ex ~3), 2) = i2ex 9
    val- true = g0float_npow ((i2ex ~3), 3) = i2ex ~27
    val- true = g0float_npow ((i2ex ~3), 4) = i2ex 81
    val- true = g0float_npow ((i2ex ~3), 5) = i2ex ~243

    val- true = g0float_int_pow ((i2ex 3), 0) = i2ex 1
    val- true = g0float_int_pow ((i2ex 3), 1) = i2ex 3
    val- true = g0float_int_pow ((i2ex 3), 2) = i2ex 9
    val- true = g0float_int_pow ((i2ex 3), 3) = i2ex 27
    val- true = g0float_int_pow ((i2ex 3), 4) = i2ex 81
    val- true = g0float_int_pow ((i2ex 3), 5) = i2ex 243

    val- true = g0float_int_pow ((i2ex ~3), 0) = i2ex 1
    val- true = g0float_int_pow ((i2ex ~3), 1) = i2ex ~3
    val- true = g0float_int_pow ((i2ex ~3), 2) = i2ex 9
    val- true = g0float_int_pow ((i2ex ~3), 3) = i2ex ~27
    val- true = g0float_int_pow ((i2ex ~3), 4) = i2ex 81
    val- true = g0float_int_pow ((i2ex ~3), 5) = i2ex ~243

    val- true = g0float_int_pow ((i2ex ~2), ~4L) = exrat_make (1, 2**4)
    val- true = g0float_int_pow ((i2ex ~5), ~7L) = exrat_make (1, ~(5**7))

    val- true = (i2ex 3) ** 0 = i2ex 1
    val- true = (i2ex 3) ** 1 = i2ex 3
    val- true = (i2ex 3) ** 2 = i2ex 9
    val- true = (i2ex 3) ** 3 = i2ex 27
    val- true = (i2ex 3) ** 4 = i2ex 81
    val- true = (i2ex 3) ** 5 = i2ex 243

    val- true = (i2ex ~3) ** 0 = i2ex 1
    val- true = (i2ex ~3) ** 1 = i2ex ~3
    val- true = (i2ex ~3) ** 2 = i2ex 9
    val- true = (i2ex ~3) ** 3 = i2ex ~27
    val- true = (i2ex ~3) ** 4 = i2ex 81
    val- true = (i2ex ~3) ** 5 = i2ex ~243

    val- true = (i2ex ~2) ** ~4L = exrat_make (1, 2**4)
    val- true = (i2ex ~5) ** ~7L = exrat_make (1, ~(5**7))

    val- true = ((g0f2i (d2ex 1234.4)) : int) = 1234
    val- true = ((g0f2i (d2ex 1234.5)) : int) = 1234
    val- true = ((g0f2i (d2ex 1234.6)) : int) = 1234
    val- true = ((g0f2i (d2ex ~1234.4)) : int) = ~1234
    val- true = ((g0f2i (d2ex ~1234.5)) : int) = ~1234
    val- true = ((g0f2i (d2ex ~1234.6)) : int) = ~1234

    val- true = ((g0f2i (d2ex 1234.6)) : lint) = 1234L
    val- true = ((g0f2i (d2ex ~1234.6)) : lint) = ~1234L

    val- true = ((g0f2f (d2ex 1234.5)) : double) = 1234.5
    val- true = ((g0f2f (d2ex 1234.5)) : float) = 1234.5F

    val- true = i2ex 2 * ((g0f2f ((g0f2f 1234.5) : fixed32p32)) : exrat) = i2ex 2469
    val- true = i2ex 2 * ((g0f2f ((g0f2f ~1234.5) : fixed32p32)) : exrat) = i2ex ~2469
    val- true = i2ex 2 * fixed2exrat_32bit ((g0f2f 1234.5) : fixed32p32) = i2ex 2469
    val- true = i2ex 2 * fixed2exrat_32bit ((g0f2f ~1234.5) : fixed32p32) = i2ex ~2469

    val- true = ((g0f2f ((g0f2f 1234.5) : exrat)) : fixed32p32) = g0f2f 1234.5
    val- true = ((g0f2f ((g0f2f ~1234.5) : exrat)) : fixed32p32) = g0f2f ~1234.5
    val- true = exrat2fixed_32bit ((g0f2f 1234.5) : exrat) = g0f2f 1234.5
    val- true = exrat2fixed_32bit ((g0f2f ~1234.5) : exrat) = g0f2f ~1234.5

    val- true = round (d2ex 1234.4) = i2ex 1234
    val- true = round (d2ex 1234.5) = i2ex 1235
    val- true = round (d2ex 1234.6) = i2ex 1235
    val- true = round (d2ex ~1234.4) = i2ex ~1234
    val- true = round (d2ex ~1234.5) = i2ex ~1235
    val- true = round (d2ex ~1234.6) = i2ex ~1235

    val- true = nearbyint (d2ex 1234.4) = i2ex 1234
    val- true = nearbyint (d2ex 1234.5) = i2ex 1234
    val- true = nearbyint (d2ex 1234.6) = i2ex 1235
    val- true = nearbyint (d2ex ~1234.4) = i2ex ~1234
    val- true = nearbyint (d2ex ~1234.5) = i2ex ~1234
    val- true = nearbyint (d2ex ~1234.6) = i2ex ~1235

    val- true = rint (d2ex 1234.4) = i2ex 1234
    val- true = rint (d2ex 1234.5) = i2ex 1234
    val- true = rint (d2ex 1234.6) = i2ex 1235
    val- true = rint (d2ex ~1234.4) = i2ex ~1234
    val- true = rint (d2ex ~1234.5) = i2ex ~1234
    val- true = rint (d2ex ~1234.6) = i2ex ~1235

    val- true = floor (d2ex 1234.4) = i2ex 1234
    val- true = floor (d2ex 1234.5) = i2ex 1234
    val- true = floor (d2ex 1234.6) = i2ex 1234
    val- true = floor (d2ex ~1234.4) = i2ex ~1235
    val- true = floor (d2ex ~1234.5) = i2ex ~1235
    val- true = floor (d2ex ~1234.6) = i2ex ~1235

    val- true = ceil (d2ex 1234.4) = i2ex 1235
    val- true = ceil (d2ex 1234.5) = i2ex 1235
    val- true = ceil (d2ex 1234.6) = i2ex 1235
    val- true = ceil (d2ex ~1234.4) = i2ex ~1234
    val- true = ceil (d2ex ~1234.5) = i2ex ~1234
    val- true = ceil (d2ex ~1234.6) = i2ex ~1234

    val- true = trunc (d2ex 1234.4) = i2ex 1234
    val- true = trunc (d2ex 1234.5) = i2ex 1234
    val- true = trunc (d2ex 1234.6) = i2ex 1234
    val- true = trunc (d2ex ~1234.4) = i2ex ~1234
    val- true = trunc (d2ex ~1234.5) = i2ex ~1234
    val- true = trunc (d2ex ~1234.6) = i2ex ~1234

    val- true = exrat_make (20, 10U) = i2ex 2
    val- true = exrat_make (20UL, 10U) = i2ex 2
    val- true = exrat_make (20UL, 10) = i2ex 2
    val- true = exrat_make (20, 10L) = i2ex 2
    val- true = exrat_make (20U, ~10) = i2ex ~2
    val- true = exrat_make (~20L, ~10) = i2ex 2
    val- true = exrat_make (20L, ~10) = i2ex ~2

    val- true = option_unsome_exn (exrat_make_string_opt "-20/10") = i2ex ~2
    val- true = exrat_make_string_exn "20/10" = i2ex 2
    val- true = option_unsome_exn (exrat_make_string_opt ("100/10", 16)) = i2ex 16
    val- true = exrat_make_string_exn ("-100/10", 16) = i2ex ~16
    val- true = option_unsome_exn (exrat_make_string_opt ("0x100 / 020", 0)) = i2ex 16
    val- true = exrat_make_string_exn ("-0x100/0b10000", 0) = i2ex ~16
    val- None () = exrat_make_string_opt "not valid"

    val- "34/5" = tostring_val<exrat> (exrat_make (34, 5))
    val- "34/5" = tostring_exrat (exrat_make (34, 5))
    val- "f/d" = tostring_exrat (exrat_make (15, 13), 16)
    val- "F/D" = tostring_exrat (exrat_make (15, 13), ~16)
    val- "34/5" = strptr2string (tostrptr_val<exrat> (exrat_make (34, 5)))
    val- "34/5" = strptr2string (tostrptr_exrat (exrat_make (34, 5)))
    val- "f/d" = strptr2string (tostrptr_exrat (exrat_make (15, 13), 16))
    val- "F/D" = strptr2string (tostrptr_exrat (exrat_make (15, 13), ~16))

    val int64_min = $extval (int64, "((int64_t) UINT64_C(0x8000000000000000))")
    val int64_min_plus_one = $extval (int64, "((int64_t) UINT64_C(0x8000000000000001))")
    val minus_int64_min_plus_one = ~$extval (int64, "((int64_t) UINT64_C(0x8000000000000001))")
    val- "-9223372036854775808" = tostring_exrat (int64_to_exrat_32bit int64_min)
    val- "-9223372036854775808" = tostring_exrat (g0int2float<int64knd,exratknd> int64_min)
    val- "-9223372036854775807" = tostring_exrat (int64_to_exrat_32bit int64_min_plus_one)
    val- "-9223372036854775807" = tostring_exrat (g0int2float<int64knd,exratknd> int64_min_plus_one)
    val- "9223372036854775807" = tostring_exrat (int64_to_exrat_32bit minus_int64_min_plus_one)
    val- "9223372036854775807" = tostring_exrat (g0int2float<int64knd,exratknd> minus_int64_min_plus_one)

    val llint_bitsize = $extval (Size_t, "(CHAR_BIT * sizeof (atstype_llint))")
    val () = assertloc (llint_bitsize >= i2sz 1)
    val llint_min_expected = ~((i2ex 2) ** sz2i (pred llint_bitsize))
    val llint_min = $extval (llint, "LLONG_MIN")
    val llint_min_plus_one = succ llint_min
    val minus_llint_min_plus_one = ~llint_min_plus_one
    val- true = llint_to_exrat_32bit llint_min = llint_min_expected
    val- true = g0int2float<llintknd,exratknd> llint_min = llint_min_expected
    val- true = llint_to_exrat_32bit llint_min_plus_one = succ llint_min_expected
    val- true = g0int2float<llintknd,exratknd> llint_min_plus_one = succ llint_min_expected
    val- true = llint_to_exrat_32bit minus_llint_min_plus_one = ~(succ llint_min_expected)
    val- true = g0int2float<llintknd,exratknd> minus_llint_min_plus_one = ~(succ llint_min_expected)

    val intmax_bitsize = $extval (Size_t, "(CHAR_BIT * sizeof (ats2_xprelude_intmax))")
    val () = assertloc (intmax_bitsize >= i2sz 1)
    val intmax_min_expected = ~((i2ex 2) ** sz2i (pred intmax_bitsize))
    val intmax_min = $extval (intmax, "INTMAX_MIN")
    val intmax_min_plus_one = succ intmax_min
    val minus_intmax_min_plus_one = ~intmax_min_plus_one
    val- true = intmax_to_exrat_32bit intmax_min = intmax_min_expected
    val- true = g0int2float<intmaxknd,exratknd> intmax_min = intmax_min_expected
    val- true = intmax_to_exrat_32bit intmax_min_plus_one = succ intmax_min_expected
    val- true = g0int2float<intmaxknd,exratknd> intmax_min_plus_one = succ intmax_min_expected
    val- true = intmax_to_exrat_32bit minus_intmax_min_plus_one = ~(succ intmax_min_expected)
    val- true = g0int2float<intmaxknd,exratknd> minus_intmax_min_plus_one = ~(succ intmax_min_expected)

    val- true = sgn (exrat_make (~123, 456)) = ~1
    val- true = sgn (exrat_make (0, 1)) = 0
    val- true = sgn (exrat_make (123, 456)) = 1

    val- true = isltz (exrat_make (~123, 456))
    val- false = isltz (exrat_make (0, 456))
    val- false = isltz (exrat_make (123, 456))

    val- true = isltez (exrat_make (~123, 456))
    val- true = isltez (exrat_make (0, 456))
    val- false = isltez (exrat_make (123, 456))

    val- false = isgtz (exrat_make (~123, 456))
    val- false = isgtz (exrat_make (0, 456))
    val- true = isgtz (exrat_make (123, 456))

    val- false = isgtez (exrat_make (~123, 456))
    val- true = isgtez (exrat_make (0, 456))
    val- true = isgtez (exrat_make (123, 456))

    val- false = iseqz (exrat_make (~123, 456))
    val- true = iseqz (exrat_make (0, 456))
    val- false = iseqz (exrat_make (123, 456))

    val- true = isneqz (exrat_make (~123, 456))
    val- false = isneqz (exrat_make (0, 456))
    val- true = isneqz (exrat_make (123, 456))

    val- true = mul_2exp (exrat_make (1, 1), 0) = exrat_make (1, 1)
    val- true = mul_2exp (exrat_make (1, 1), 1) = exrat_make (2, 1)
    val- true = mul_2exp (exrat_make (1, 1), 2) = exrat_make (4, 1)
    val- true = mul_2exp (exrat_make (1, 1), 3) = exrat_make (8, 1)

    val- true = div_2exp (exrat_make (1, 1), 0L) = exrat_make (1, 1)
    val- true = div_2exp (exrat_make (1, 1), ~1L) = exrat_make (2, 1)
    val- true = div_2exp (exrat_make (1, 1), ~2LL) = exrat_make (4, 1)
    val- true = div_2exp (exrat_make (1, 1), ~3) = exrat_make (8, 1)

    val- true = div_2exp (exrat_make (1, 1), 0) = exrat_make (1, 1)
    val- true = div_2exp (exrat_make (2, 1), 1) = exrat_make (1, 1)
    val- true = div_2exp (exrat_make (4, 1), 2) = exrat_make (1, 1)
    val- true = div_2exp (exrat_make (8, 1), 3) = exrat_make (1, 1)

    val- true = mul_2exp (exrat_make (1, 1), ~0) = exrat_make (1, 1)
    val- true = mul_2exp (exrat_make (2, 1), ~1L) = exrat_make (1, 1)
    val- true = mul_2exp (exrat_make (4, 1), ~2LL) = exrat_make (1, 1)
    val- true = mul_2exp (exrat_make (8, 1), ~3) = exrat_make (1, 1)

    val- true = exrat_numerator (exrat_make (37, 101)) = exrat_make (37, 1)
    val- true = exrat_denominator (exrat_make (37, 101)) = exrat_make (101, 1)
    val- true = exrat_numerator (exrat_make (8, 2)) = exrat_make (4, 1)
    val- true = exrat_denominator (exrat_make (8, 2)) = exrat_make (1, 1)

    val- true = exrat_is_integer (exrat_make (~4, 2))
    val- true = exrat_is_integer (exrat_make (0, 2))
    val- true = exrat_is_integer (exrat_make (8, 2))
    val- false = exrat_is_integer (exrat_make (~4, 3))
    val- false = exrat_is_integer (exrat_make (8, 3))

    val- true = exrat_numerator_ffs (exrat_make (0, 1)) = 0UL
    val- true = exrat_numerator_ffs (exrat_make (1, 1)) = 1UL
    val- true = exrat_numerator_ffs (exrat_make (2, 1)) = 2UL
    val- true = exrat_numerator_ffs (exrat_make (3, 1)) = 1UL
    val- true = exrat_numerator_ffs (exrat_make (4, 1)) = 3UL
    val- true = exrat_numerator_ffs (exrat_make (5, 1)) = 1UL
    val- true = exrat_numerator_ffs (exrat_make (6, 1)) = 2UL
    val- true = exrat_numerator_ffs (exrat_make (7, 1)) = 1UL
    val- true = exrat_numerator_ffs (exrat_make (8, 1)) = 4UL

    val- true = abs (g0float2float<ldblknd,exratknd> 0.25L - exrat_make (1, 4)) < g0f2f 0.0000001
    val- true = abs (g0float2float<ldblknd,exratknd> ~0.25L + exrat_make (1, 4)) < g0f2f 0.0000001
    val- true = abs (g0float2float<ldblknd,exratknd> 4.0L - exrat_make (4, 1)) < g0f2f 0.0000001
    val- true = abs (g0float2float<ldblknd,exratknd> ~4.0L + exrat_make (4, 1)) < g0f2f 0.0000001
    val- true = abs (g0float2float<ldblknd,exratknd> 1234.0e-5L - exrat_make (1234, 100000)) < g0f2f 0.0000001
    val- true = abs (g0float2float<ldblknd,exratknd> 1234.0e5L - exrat_make (123400000, 1)) < g0f2f 0.0000001
    val- true = abs (g0float2float<ldblknd,exratknd> 1234.0e-56L - g0f2f 1234.0e-56) < g0f2f 1e-63
    val- true = abs (g0float2float<ldblknd,exratknd> 1234.0e56L - g0f2f 1234.0e56) < g0f2f 1e49
    val- true = g0float2float<ldblknd,exratknd> 0.0L = g0i2f 0

    val- true = abs (g0float2float<exratknd,ldblknd> (exrat_make (1, 4)) - 0.25L) < 0.0000001L
    val- true = abs (g0float2float<exratknd,ldblknd> (exrat_make (~1, 4)) + 0.25L) < 0.0000001L
    val- true = abs (g0float2float<exratknd,ldblknd> (g0float2float<dblknd,exratknd> (1.234e-56)) - 1.234e-56L) < 1e-63L
    val- true = abs (g0float2float<exratknd,ldblknd> (g0float2float<dblknd,exratknd> (1.234e56)) - 1.234e56L) < 1e49L
    val- true = g0float2float<exratknd,ldblknd> (g0float2float<dblknd,exratknd> (0.0)) = 0.0L
  in
  end

fn
test1 () : void =
  let
    var x : exrat = exrat_make (11, 5)
    val- true = x = exrat_make (11, 5)
    val () = replace (x, 7)
    val- true = x = exrat_make (7, 1)

    var y : exrat = exrat_make (1, 234)
    val- true = y = exrat_make (1, 234)
    val () = replace (y, x)
    val- true = y = exrat_make (7, 1)

    var z : exrat = exrat_make (123, 4)
    val- true = z = exrat_make (123, 4)
    val () = replace (z, 6.5)
    val- true = z = exrat_make (65, 10)
    val () = neg_replace (z, z)
    val- true = z = exrat_make (~65, 10)

    val () = exchange (y, z)
    val- true = y = exrat_make (~65, 10)
    val- true = z = exrat_make (7, 1)

    val () = reciprocal_replace (z, exrat_make (8, 1))
    val- true = z = exrat_make (1, 8)
    val () = reciprocal_replace (z, z)
    val- true = z = exrat_make (8, 1)
  in
  end

fn
test2 () : void =
  let
    var x : float = 5.0F
    val () = replace (x, exrat_make (1, 8))
    val- true = x = 0.125F

    var x : double = 5.0
    val () = replace (x, exrat_make (1, 8))
    val- true = x = 0.125
  in
  end

fn
test3 () : void =
  let
    var x = i2ex 0

    val () = neg_replace (x, i2ex 4)
    val- true = x = i2ex ~4

    val () = neg_replace (x, i2ex ~4)
    val- true = x = i2ex 4

    val () = succ_replace (x, i2ex 4)
    val- true = x = i2ex 5

    val () = pred_replace (x, i2ex 4)
    val- true = x = i2ex 3

    val () = abs_replace (x, i2ex 4)
    val- true = x = i2ex 4

    val () = abs_replace (x, i2ex ~4)
    val- true = x = i2ex 4

    val () = fabs_replace (x, i2ex 4)
    val- true = x = i2ex 4

    val () = fabs_replace (x, i2ex ~4)
    val- true = x = i2ex 4

    val () = add_replace (x, i2ex 4, i2ex 6)
    val- true = x = i2ex 10

    val () = sub_replace (x, i2ex 4, i2ex 6)
    val- true = x = i2ex ~2

    val () = mul_replace (x, i2ex 4, i2ex 6)
    val- true = x = i2ex 24

    val () = div_replace (x, i2ex 4, i2ex 6)
    val- true = x = exrat_make (4, 6)

    val () = min_replace (x, i2ex 4, i2ex 6)
    val- true = x = i2ex 4

    val () = min_replace (x, i2ex 6, i2ex 4)
    val- true = x = i2ex 4

    val () = max_replace (x, i2ex 4, i2ex 6)
    val- true = x = i2ex 6

    val () = max_replace (x, i2ex 6, i2ex 4)
    val- true = x = i2ex 6

    val () = fma_replace (x, i2ex 6, i2ex 4, i2ex 11)
    val- true = x = i2ex 35
  in
  end

fn
test4 () : void =
  let
    var x = i2ex 0

    val () = round_replace (x, exrat_make (3, 2))
    val- true = x = i2ex 2
    val () = round_replace (x, exrat_make (5, 2))
    val- true = x = i2ex 3
    val () = round_replace (x, exrat_make (7, 2))
    val- true = x = i2ex 4

    val () = round_replace (x, exrat_make (~3, 2))
    val- true = x = i2ex ~2
    val () = round_replace (x, exrat_make (~5, 2))
    val- true = x = i2ex ~3
    val () = round_replace (x, exrat_make (~7, 2))
    val- true = x = i2ex ~4

    val () = nearbyint_replace (x, exrat_make (3, 2))
    val- true = x = i2ex 2
    val () = nearbyint_replace (x, exrat_make (5, 2))
    val- true = x = i2ex 2
    val () = nearbyint_replace (x, exrat_make (7, 2))
    val- true = x = i2ex 4

    val () = nearbyint_replace (x, exrat_make (~3, 2))
    val- true = x = i2ex ~2
    val () = nearbyint_replace (x, exrat_make (~5, 2))
    val- true = x = i2ex ~2
    val () = nearbyint_replace (x, exrat_make (~7, 2))
    val- true = x = i2ex ~4

    val () = rint_replace (x, exrat_make (3, 2))
    val- true = x = i2ex 2
    val () = rint_replace (x, exrat_make (5, 2))
    val- true = x = i2ex 2
    val () = rint_replace (x, exrat_make (7, 2))
    val- true = x = i2ex 4

    val () = rint_replace (x, exrat_make (~3, 2))
    val- true = x = i2ex ~2
    val () = rint_replace (x, exrat_make (~5, 2))
    val- true = x = i2ex ~2
    val () = rint_replace (x, exrat_make (~7, 2))
    val- true = x = i2ex ~4

    val () = floor_replace (x, exrat_make (3, 2))
    val- true = x = i2ex 1
    val () = floor_replace (x, exrat_make (5, 2))
    val- true = x = i2ex 2
    val () = floor_replace (x, exrat_make (7, 2))
    val- true = x = i2ex 3

    val () = floor_replace (x, exrat_make (~3, 2))
    val- true = x = i2ex ~2
    val () = floor_replace (x, exrat_make (~5, 2))
    val- true = x = i2ex ~3
    val () = floor_replace (x, exrat_make (~7, 2))
    val- true = x = i2ex ~4

    val () = ceil_replace (x, exrat_make (3, 2))
    val- true = x = i2ex 2
    val () = ceil_replace (x, exrat_make (5, 2))
    val- true = x = i2ex 3
    val () = ceil_replace (x, exrat_make (7, 2))
    val- true = x = i2ex 4

    val () = ceil_replace (x, exrat_make (~3, 2))
    val- true = x = i2ex ~1
    val () = ceil_replace (x, exrat_make (~5, 2))
    val- true = x = i2ex ~2
    val () = ceil_replace (x, exrat_make (~7, 2))
    val- true = x = i2ex ~3

    val () = trunc_replace (x, exrat_make (3, 2))
    val- true = x = i2ex 1
    val () = trunc_replace (x, exrat_make (5, 2))
    val- true = x = i2ex 2
    val () = trunc_replace (x, exrat_make (7, 2))
    val- true = x = i2ex 3

    val () = trunc_replace (x, exrat_make (~3, 2))
    val- true = x = i2ex ~1
    val () = trunc_replace (x, exrat_make (~5, 2))
    val- true = x = i2ex ~2
    val () = trunc_replace (x, exrat_make (~7, 2))
    val- true = x = i2ex ~3
  in
  end

fn
test5 () : void =
  let
    var x = i2ex 0

    val () = npow_replace (x, i2ex 2, 10)
    val- true = x = i2ex 1024

    val () = int_pow_replace (x, i2ex 2, 10L)
    val- true = x = i2ex 1024

    val () = int_pow_replace (x, i2ex 2, ~10L)
    val- true = x = exrat_make (1, 1024)

    val () = mul_2exp_replace (x, i2ex 10, 10L)
    val- true = x = i2ex 10240

    val () = mul_2exp_replace (x, x, ~10L)
    val- true = x = i2ex 10

    val () = div_2exp_replace (x, x, ~10LL)
    val- true = x = i2ex 10240

    val () = div_2exp_replace (x, x, 10)
    val- true = x = i2ex 10
  in
  end

fn
test6 () : void =
  let
    val- true = exrat_numerator_is_even (exrat_make (~4, 2))
    val- true = exrat_numerator_is_even (exrat_make (0, 2))
    val- true = exrat_numerator_is_even (exrat_make (8, 2))
    val- true = exrat_numerator_is_even (exrat_make (~4, 3))
    val- false = exrat_numerator_is_even (exrat_make (9, 3))
    val- false = exrat_numerator_is_even (exrat_make (~11, 2))
    val- false = exrat_numerator_is_even (exrat_make (5, 1))

    val- false = exrat_numerator_is_odd (exrat_make (~4, 2))
    val- false = exrat_numerator_is_odd (exrat_make (0, 2))
    val- false = exrat_numerator_is_odd (exrat_make (8, 2))
    val- false = exrat_numerator_is_odd (exrat_make (~4, 3))
    val- true = exrat_numerator_is_odd (exrat_make (9, 3))
    val- true = exrat_numerator_is_odd (exrat_make (~11, 2))
    val- true = exrat_numerator_is_odd (exrat_make (5, 1))

    val- true = exrat_numerator_is_perfect_power (exrat_make (125, 1))
    val- false = exrat_numerator_is_perfect_power (exrat_make (126, 1))

    val- true = exrat_numerator_is_perfect_square (exrat_make (25, 1))
    val- false = exrat_numerator_is_perfect_square (exrat_make (125, 1))

    val- true = exrat_numerator_root (exrat_make (125, 1), 3UL) = exrat_make (5, 1)
    val- true = exrat_numerator_sqrt (exrat_make (25, 1)) = exrat_make (5, 1)

    val @(q, r) = exrat_numerator_rootrem (exrat_make (127, 1), 3UL)
    val- true = q = exrat_make (5, 1)
    val- true = r = exrat_make (2, 1)

    val @(q, r) = exrat_numerator_sqrtrem (exrat_make (29, 1))
    val- true = q = exrat_make (5, 1)
    val- true = r = exrat_make (4, 1)

    val- true = exrat_numerator_gcd (i2ex 36, i2ex 24) = i2ex 12
    val- true = exrat_numerator_lcm (i2ex 36, i2ex 24) = (i2ex 36 * i2ex 24) / exrat_numerator_gcd (i2ex 36, i2ex 24)
    val @(d, p, q) = exrat_numerator_gcdext (i2ex 36, i2ex 24)
    val- true = d = i2ex 12
    val- true = (p * i2ex 36) + (q * i2ex 24) = d

    val- Some z = exrat_numerator_modular_inverse (i2ex 7, i2ex 9)
    val- true = z = i2ex 4
    val- Some z = exrat_numerator_modular_inverse (i2ex 4, i2ex 9)
    val- true = z = i2ex 7
    val- Some z = exrat_numerator_modular_inverse (i2ex 13, i2ex 16)
    val- true = z = i2ex 5
    val- Some z = exrat_numerator_modular_inverse (i2ex 5, i2ex 16)
    val- true = z = i2ex 13
    val- None () = exrat_numerator_modular_inverse (i2ex 5, i2ex 10)
    val- None () = exrat_numerator_modular_inverse (i2ex 13, i2ex 13)
    val- None () = exrat_numerator_modular_inverse (i2ex 13, i2ex 0)

    val- true = exrat_numerator_legendre_symbol (i2ex 14, i2ex 31) = 1
    val- true = exrat_numerator_legendre_symbol (i2ex 14, i2ex 33) = ~1
    val- true = exrat_numerator_jacobi_symbol (i2ex 14, i2ex 31) = 1
    val- true = exrat_numerator_jacobi_symbol (i2ex 14, i2ex 33) = ~1
    val- true = exrat_numerator_kronecker_symbol (i2ex 17, i2ex 10) = ~1
    val- true = exrat_numerator_kronecker_symbol (i2ex 26, i2ex 2) = 0
  in
  end

implement
main () =
  begin
    test0 ();
    test1 ();
    test2 ();
    test3 ();
    test4 ();
    test5 ();
    test6 ();
    0
  end

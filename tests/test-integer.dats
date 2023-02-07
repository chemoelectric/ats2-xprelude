(*
  Copyright © 2023 Barry Schwartz

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

staload "xprelude/SATS/arith_prf.sats"

staload UN = "prelude/SATS/unsafe.sats"

%{^
#include <limits.h>
%}

(*------------------------------------------------------------------*)

val INT8_MAX = $extval (int, "INT8_MAX")
val INT_MAX = $extval (int, "INT_MAX")
val LINT_MAX = $extval (lint, "LONG_MAX")
val LLINT_MAX = $extval (llint, "LLONG_MAX")

(*------------------------------------------------------------------*)
(* A simple linear congruential generator. *)

(* The multiplier lcg_a comes from Steele, Guy; Vigna, Sebastiano (28
   September 2021). "Computationally easy, spectrally good multipliers
   for congruential pseudorandom number generators".
   arXiv:2001.05304v3 [cs.DS] *)
macdef lcg_a = $UN.cast{uint64} 0xf1357aea2e62a9c5LLU

(* lcg_c must be odd. *)
macdef lcg_c = $UN.cast{uint64} 0xbaceba11beefbeadLLU

var seed : uint64 = $UN.cast 0
val p_seed = addr@ seed

fn
random_double () :<!wrt> double =
  let
    val (pf, fpf | p_seed) = $UN.ptr0_vtake{uint64} p_seed
    val old_seed = ptr_get<uint64> (pf | p_seed)

    (* IEEE "binary64" or "double" has 52 bits of precision. We will
       take the high 48 bits of the seed and divide it by 2**48, to
       get a number 0.0 <= randnum < 1.0 *)
    val high_48_bits = $UN.cast{double} (old_seed >> 16)
    val divisor = $UN.cast{double} (1LLU << 48)
    val randnum = high_48_bits / divisor

    (* The following operation is modulo 2**64, by virtue of standard
       C behavior for uint64_t. *)
    val new_seed = (lcg_a * old_seed) + lcg_c

    val () = ptr_set<uint64> (pf | p_seed, new_seed)
    prval () = fpf pf
  in
    randnum
  end

(*------------------------------------------------------------------*)

fn {tk : tkind}
brute_force_popcount_gint
          (n : g0int tk)
    : int =
  let
    fun
    loop (i     : size_t,
          m     : g0int tk,
          accum : int)
        : int =
      if i = 8 * sizeof<g0int tk> then
        accum
      else if m mod (g0i2i 2) = g0i2i 1 then
        loop (succ i, m / (g0i2i 2), succ accum)
      else
        loop (succ i, m / (g0i2i 2), accum)
  in
    loop (i2sz 0, n, 0)
  end

fn {tk : tkind}
brute_force_popcount_guint
          (n : g0uint tk)
    : int =
  let
    fun
    loop (i     : size_t,
          m     : g0uint tk,
          accum : int)
        : int =
      if i = 8 * sizeof<g0uint tk> then
        accum
      else if m mod (g0i2u 2) = g0i2u 1 then
        loop (succ i, m / (g0i2u 2), succ accum)
      else
        loop (succ i, m / (g0i2u 2), accum)
  in
    loop (i2sz 0, n, 0)
  end

overload brute_force_popcount with brute_force_popcount_gint
overload brute_force_popcount with brute_force_popcount_guint

(*------------------------------------------------------------------*)

fn
test1 () : void =
  let
    val- true = g0int2int<lintknd,intknd> 123L = 123
    val- true = g0i2i 123 = 123L
    val- true = g0i2i (120L + g0i2i 3) = 123LL
    val- true = g0i2i 123 = g0int2int<intknd,intmaxknd> 123

    val- true = g0int2uint<lintknd,uintknd> 123L = 123U
    val- true = g0i2u 123 = 123UL
    val- true = g0i2u (120L + g0i2i 3) = 123ULL
    val- true = g0i2u 123 = g0int2uint<intknd,uintmaxknd> 123

    val- true = g0uint2int<ulintknd,intknd> 123UL = 123
    val- true = g0u2i 123U = 123L
    val- true = g0u2i (120UL + g0i2u 3) = 123LL
    val- true = g0u2i 123U = g0int2int<intknd,intmaxknd> 123

    val- true = g0int2uint<intknd,uint8knd> 123 = g0i2u 123
    val- true = g0u2u 123U = 123UL
    val- true = g0u2u (120UL + g0u2u 3U) = 123ULL
    val- true = g0u2u 123U = i2sz 123

    val- true = g0int2int<intknd,intmaxknd> 123 = ((g0i2i 123) : g0int intmaxknd)
    val- true = g0int2uint<intknd,uintmaxknd> 123 = ((g0i2u 123) : g0uint uintmaxknd)
  in
  end

fn
test2 () : void =
  let
    val- true = g1int2int<lintknd,intknd> 123L = 123
    val- true = g1i2i 123 = 123L
    val- true = g1i2i (120L + g1i2i 3) = 123LL
    val- true = g1i2i 123 = g1int2int<intknd,intmaxknd> 123

    val- true = g1int2uint<lintknd,uintknd> 123L = 123U
    val- true = g1i2u 123 = 123UL
    val- true = g1i2u (120L + g1i2i 3) = 123ULL
    val- true = g1i2u 123 = g1int2uint<intknd,uintmaxknd> 123

    val- true = g1uint2int<ulintknd,intknd> 123UL = 123
    val- true = g1u2i 123U = 123L
    val- true = g1u2i (120UL + g1i2u 3) = 123LL
    val- true = g1u2i 123U = g1int2int<intknd,intmaxknd> 123

    val- true = g1int2uint<intknd,uint8knd> 123 = g1i2u 123
    val- true = g1u2u 123U = 123UL
    val- true = g1u2u (120UL + g1u2u 3U) = 123ULL
    val- true = g1u2u 123U = i2sz 123

    val- true = g1int2int<intknd,intmaxknd> 123 = ((g1i2i 123) : g1int intmaxknd)
    val- true = g1int2uint<intknd,uintmaxknd> 123 = ((g1i2u 123) : g1uint uintmaxknd)
  in
  end

fn
test3 () : void =
  let
    val- true : Bool = 3 < 4
    val- false : bool = 3L < 3L
    val- false : bool = 4LL < 3LL
    val- true : Bool = 3U < 4U
    val- false : bool = 3UL < 3UL
    val- false : bool = 4ULL < 3ULL

    val- true : Bool = 3 <= 4
    val- true : Bool = 3L <= 3L
    val- false : bool = 4LL <= 3LL
    val- true : Bool = 3U <= 4U
    val- true : Bool = 3UL <= 3UL
    val- false : bool = 4ULL <= 3ULL

    val- false : bool = 3 > 4
    val- false : bool = 3L > 3L
    val- true : Bool = 4LL > 3LL
    val- false : bool = 3U > 4U
    val- false : bool = 3UL > 3UL
    val- true : Bool = 4ULL > 3ULL

    val- false : bool = 3 >= 4
    val- true : Bool = 3L >= 3L
    val- true : Bool = 4LL >= 3LL
    val- false : bool = 3U >= 4U
    val- true : Bool = 3UL >= 3UL
    val- true : Bool = 4ULL >= 3ULL

    val- false : bool = 3 = 4
    val- true : Bool = 3L = 3L
    val- false : bool = 4LL = 3LL
    val- false : bool = 3U = 4U
    val- true : Bool = 3UL = 3UL
    val- false : bool = 4ULL = 3ULL

    val- true : Bool = 3 <> 4
    val- false : bool = 3L <> 3L
    val- true : Bool = 4LL <> 3LL
    val- true : Bool = 3U <> 4U
    val- false : bool = 3UL <> 3UL
    val- true : Bool = 4ULL <> 3ULL

    val- true : Bool = 3 != 4
    val- false : bool = 3L != 3L
    val- true : Bool = 4LL != 3LL
    val- true : Bool = 3U != 4U
    val- false : bool = 3UL != 3UL
    val- true : Bool = 4ULL != 3ULL

    val- true = compare (3, 4) = ((~1) : g0int intknd)
    val- true = compare (3L, 3L) = (0 : g1int intknd)
    val- true = compare (4LL, 3LL) = 1
    val- true = compare (3U, 4U) = ((~1) : g0int intknd)
    val- true = compare (3UL, 3UL) = (0 : g1int intknd)
    val- true = compare (4ULL, 3ULL) = 1
  in
  end

fn
test4 () : void =
  let
    val- false : Bool = isltz 0L
    val- true : bool = isltez 0LL
    val- false = isgtz 0
    val- true = isgtez 0
    val- true = iseqz ((g0i2i 0) : intmax)
    val- false = isneqz ((g1i2i 0) : Intmax)

    val- true : Bool = isltz ~123
    val- true : bool = isltez ~123
    val- false = isgtz ~123L
    val- false = isgtez ~123LL
    val- false = iseqz ~123
    val- true = isneqz ~123

    val- false : Bool = isltz 123
    val- false : bool = isltez 123
    val- true = isgtz 123
    val- true = isgtez 123L
    val- false = iseqz 123LL
    val- true = isneqz 123

    val- true : Bool = isgtz 123U
    val- false : bool = iseqz 123UL
    val- true = isneqz 123ULL
    val- true = isneqz ((g0i2u 123) : uintmax)
    val- true = isneqz ((g1i2u 123) : uIntmax)
  in
  end

fn
test5 () : void =
  let
    val- true = 0 = ~0
    val- true = ~(~123) = (123 : Int)
    val- true = ~(~(~123LL)) = (~123LL : g1int llintknd)
    val- true = 123L + (~123L) = 0L
    val- true = 123L - (~123L) = 246L

    val- true = 0 = abs 0
    val- true = abs 123 = 123
    val- true = abs (~123) = (123 : Int)
    val- true = ~(abs (~123LL)) = (~123LL : g1int llintknd)
    val- true = 123L + abs (~123L) = 246L
    val- true = 123L - abs (~123L) = 0L
    val- true = 123L + abs (123L) = 246L
    val- true = 123L - abs (123L) = 0L
  in
  end

fn
test6 () : void =
  let
    val- true = succ 123 = 124
    val- true = succ 123U = 124U
    val- true = pred 123L = 122L
    val- true = pred 123ULL = 122ULL
  in
  end

fn
test7 () : void =
  let
    val- true = half 123 = 61
    val- true = half 124L = 62L

    val- true = half ~123 = ~61
    val- true = half ~124L = ~62L

    val- true = half 123U = 61U
    val- true = half 124UL = 62UL
  in
  end

fn
test8 () : void =
  let
    val- true = 1 + 2 + 3 + 4 = 10
    val- true = 1 - 2 - 3 - 4 = ~8
    val- true = 1 * 2 * 3 * 4 = 24
    val- true = 23 / 3 = 7
    val- true = 23L mod 3L = 2L
    val- true = 23LL % 3LL = 2LL

    val- true : Bool = (23L \nmod 3L) = 2L
    val- true = nmod ((g1i2i 23) : [n : nat] intmax n, 3) = 2

    val n : intmax 23 = g1i2i 23
    val @(pf | r) = nmod2_g1int_int1 (n, 3)
    prval [r : int] EQINT () = eqint_make_gint r
    prval () = divmod_mul_elim pf
    prval () = prop_verify {r == 2} ()
    val- true = r = 2

    val- true = 1U + 2U + 3U + 4U = 10
    val- true : Bool = 10U - 2U - 3U - 4U = 1U
    val- true = 1U * 2U * 3U * 4U = 24
    val- true = 23U / 3U = 7U
    val- true = 23UL mod 3UL = 2UL
    val- true = 23ULL % 3ULL = 2ULL
  in
  end

fn
test9 () : void =
  let
    #define MAXVAL 100

    infixl ( / ) div rem divrem
    macdef div = g0int_eucliddiv
    macdef rem = g0int_euclidrem
    macdef divrem = g0int_eucliddivrem

    var n : int
  in
    for (n := ~MAXVAL; n <= MAXVAL; n := succ n)
      let
        var d : int
      in
        for (d := ~MAXVAL; d <= MAXVAL;
             d := (if d = ~1 then 1 else succ d))
          let
            val q1 = n div d
            and r1 = n rem d
            and @(q2, r2) = n divrem d
            val- true = q1 = q2
            val- true = r1 = r2
            val- true = isgtez r1
            val- true = r1 < abs d
            val- true = n = r1 + (q1 * d)
          in
          end
      end
  end

fn
test10 () : void =
  let
    #define MAXVAL 100

    infixl ( / ) div rem divrem
    macdef div = g1int_eucliddiv
    macdef rem = g1int_euclidrem
    macdef divrem = g1int_eucliddivrem

    var n : Int
  in
    for (n := ~MAXVAL; n <= MAXVAL; n := succ n)
      let
        var d : Int
      in
        for (d := ~MAXVAL; d <= MAXVAL;
             d := (if d = ~1 then 1 else succ d))
          let
            val () = assertloc (isneqz d)
            val q1 = n div d
            and r1 = n rem d
            and @(q2, r2) = n divrem d
            val- true = q1 = q2
            val- true = r1 = r2
            val- true = isgtez r1
            val- true = r1 < abs d
            val- true = n = r1 + (q1 * d)
          in
          end
      end
  end

fn
test11 () : void =
  let
    val- true : Bool = min (3, 4) = 3
    val- true : bool = min (3L, 3L) = 3L
    val- true : bool = min (4LL, 3LL) = 3LL

    val- true : Bool = max (3U, 4U) = 4U
    val- true : bool = max (4UL, 4UL) = 4UL
    val- true : bool = max (4ULL, 3ULL) = 4ULL
  in
  end

fn
test12 () : void =
  let
    var x = g0int2int<intknd,sintknd> ~123
    val- true = tostring_val<sint> x = "-123"
    val- true = tostring_ref<sint> x = "-123"

    var x = g0int2uint<intknd,usintknd> 123
    val- true = tostring_val<usint> x = "123"
    val- true = tostring_ref<usint> x = "123"

    var x = g0int2int<intknd,intmaxknd> ~123
    val- true = tostring_val<intmax> x = "-123"
    val- true = tostring_ref<intmax> x = "-123"

    var x = g0int2uint<intknd,uintmaxknd> 123
    val- true = tostring_val<uintmax> x = "123"
    val- true = tostring_ref<uintmax> x = "123"
  in
  end

fn
test13 () : void =
  let
    val- true : bool = ((0x12345U) \g0uint_lsl 0) = 0x012345U
    val- true : bool = ((0x12345U) \g0uint_lsl 4) = 0x0123450U
    val- true : bool = ((0x12345U) \g0uint_lsl 8) = 0x01234500U
    val- true : bool = ((0x12345U) \g0uint_lsl sz2i (i2sz 8 * sizeof<uint>)) = 0U

    val- true : bool = ((0x12345U) << 0) = 0x012345U
    val- true : bool = ((0x12345U) << 4) = 0x0123450U
    val- true : bool = ((0x12345U) << 8) = 0x01234500U
    val- true : bool = ((0x12345U) << sz2i (i2sz 8 * sizeof<uint>)) = 0U

    val- true : Bool = ((0x12345U) \g1uint_lsl 0) = 0x012345U
    val- true : Bool = ((0x12345U) \g1uint_lsl 4) = 0x0123450U
    val- true : Bool = ((0x12345U) \g1uint_lsl 8) = 0x01234500U
    val- true : Bool = ((0x12345U) \g1uint_lsl sz2i (i2sz 8 * sizeof<uint>)) = 0U

    val- true : Bool = ((0x12345U) << 0) = 0x012345U
    val- true : Bool = ((0x12345U) << 4) = 0x0123450U
    val- true : Bool = ((0x12345U) << 8) = 0x01234500U
    val- true : Bool = ((0x12345U) << sz2i (i2sz 8 * sizeof<uint>)) = 0U

    val- true : bool = ((0x12345U) \g0uint_lsr 0) = 0x012345U
    val- true : bool = ((0x12345U) \g0uint_lsr 4) = 0x01234U
    val- true : bool = ((0x12345U) \g0uint_lsr 8) = 0x0123U
    val- true : bool = ((0x12345U) \g0uint_lsr sz2i (i2sz 8 * sizeof<uint>)) = 0U

    val- true : bool = ((0x12345U) >> 0) = 0x012345U
    val- true : bool = ((0x12345U) >> 4) = 0x01234U
    val- true : bool = ((0x12345U) >> 8) = 0x0123U
    val- true : bool = ((0x12345U) >> sz2i (i2sz 8 * sizeof<uint>)) = 0U

    val- true : Bool = ((0x12345U) \g1uint_lsr 0) = 0x012345U
    val- true : Bool = ((0x12345U) \g1uint_lsr 4) = 0x01234U
    val- true : Bool = ((0x12345U) \g1uint_lsr 8) = 0x0123U
    val- true : Bool = ((0x12345U) \g1uint_lsr sz2i (i2sz 8 * sizeof<uint>)) = 0U

    val- true : Bool = ((0x12345U) >> 0) = 0x012345U
    val- true : Bool = ((0x12345U) >> 4) = 0x01234U
    val- true : Bool = ((0x12345U) >> 8) = 0x0123U
    val- true : Bool = ((0x12345U) >> sz2i (i2sz 8 * sizeof<uint>)) = 0U
  in
  end

fn
test14 () : void =
  let
    val- true : bool = (0x12345 \g0int_asl 0) = 0x12345
    val- true : bool = (0x12345 \g0int_asl 4) = 0x123450
    val- true : bool = (0x12345 \g0int_asl 8) = 0x1234500
    val- true : bool = (0x12345 \g0int_asl sz2i (i2sz 8 * sizeof<int>)) = 0
    val i = sz2i (i2sz 8 * sizeof<int>)
    val () = assertloc (0 < i)
    val- true : bool = (0x12345 \g0int_asl pred i) = $extval (int, "INT_MIN")

    val- true : bool = (0x12345 << 0) = 0x12345
    val- true : bool = (0x12345 << 4) = 0x123450
    val- true : bool = (0x12345 << 8) = 0x1234500
    val- true : bool = (0x12345 << sz2i (i2sz 8 * sizeof<int>)) = 0
    val i = sz2i (i2sz 8 * sizeof<int>)
    val () = assertloc (0 < i)
    val- true : bool = (0x12345 << pred i) = $extval (int, "INT_MIN")

    val- true : Bool = (0x12345 \g1int_asl 0) = 0x12345
    val- true : Bool = (0x12345 \g1int_asl 4) = 0x123450
    val- true : Bool = (0x12345 \g1int_asl 8) = 0x1234500
    val- true : Bool = (0x12345 \g1int_asl sz2i (i2sz 8 * sizeof<int>)) = 0
    val i = sz2i (i2sz 8 * sizeof<int>)
    val () = assertloc (0 < i)
    val- true : Bool = (0x12345 \g1int_asl pred i) = $extval (Int, "INT_MIN")

    val- true : Bool = (0x12345 << 0) = 0x12345
    val- true : Bool = (0x12345 << 4) = 0x123450
    val- true : Bool = (0x12345 << 8) = 0x1234500
    val- true : Bool = (0x12345 << sz2i (i2sz 8 * sizeof<int>)) = 0
    val i = sz2i (i2sz 8 * sizeof<int>)
    val () = assertloc (0 < i)
    val- true : Bool = (0x12345 << pred i) = $extval (Int, "INT_MIN")

    val- true : bool = (0x12345 \g0int_asr 0) = 0x12345
    val- true : bool = (0x12345 \g0int_asr 4) = 0x1234
    val- true : bool = (0x12345 \g0int_asr 8) = 0x123
    val i = sz2i (i2sz 8 * sizeof<int>)
    val () = assertloc (0 < i)
    val- true : bool = (0x12345 \g0int_asr i) = 0
    val- true : bool = ($extval (int, "INT_MIN") \g0int_asr pred i) = ~1
    val- true : bool = ($extval (int, "INT_MIN") \g0int_asr i) = ~1
    val- true : bool = ($extval (int, "INT_MIN") \g0int_asr succ i) = ~1

    val- true : bool = (0x12345 >> 0) = 0x12345
    val- true : bool = (0x12345 >> 4) = 0x1234
    val- true : bool = (0x12345 >> 8) = 0x123
    val i = sz2i (i2sz 8 * sizeof<int>)
    val () = assertloc (0 < i)
    val- true : bool = (0x12345 >> i) = 0
    val- true : bool = ($extval (int, "INT_MIN") >> pred i) = ~1
    val- true : bool = ($extval (int, "INT_MIN") >> i) = ~1
    val- true : bool = ($extval (int, "INT_MIN") >> succ i) = ~1

    val- true : Bool = (0x12345 \g1int_asr 0) = 0x12345
    val- true : Bool = (0x12345 \g1int_asr 4) = 0x1234
    val- true : Bool = (0x12345 \g1int_asr 8) = 0x123
    val i = sz2i (i2sz 8 * sizeof<int>)
    val () = assertloc (0 < i)
    val- true : Bool = (0x12345 \g1int_asr i) = 0
    val- true : Bool = ($extval (Int, "INT_MIN") \g1int_asr pred i) = ~1
    val- true : Bool = ($extval (Int, "INT_MIN") \g1int_asr i) = ~1
    val- true : Bool = ($extval (Int, "INT_MIN") \g1int_asr succ i) = ~1

    val- true : Bool = (0x12345 >> 0) = 0x12345
    val- true : Bool = (0x12345 >> 4) = 0x1234
    val- true : Bool = (0x12345 >> 8) = 0x123
    val i = sz2i (i2sz 8 * sizeof<int>)
    val () = assertloc (0 < i)
    val- true : Bool = (0x12345 >> i) = 0
    val- true : Bool = ($extval (Int, "INT_MIN") >> pred i) = ~1
    val- true : Bool = ($extval (Int, "INT_MIN") >> i) = ~1
    val- true : Bool = ($extval (Int, "INT_MIN") >> succ i) = ~1
  in
  end

fn
test15 () : void =
  let
    val- true : bool = (g0int_lnot 1) = ~2
    val- true : bool = (6 \g0int_land 3) = 2
    val- true : bool = (6 \g0int_lor 3) = 7
    val- true : bool = (6 \g0int_lxor 3) = 5
    val- true : bool = (lnot 1) = ~2
    val- true : bool = (6 land 3) = 2
    val- true : bool = (6 lor 3) = 7
    val- true : bool = (6 lxor 3) = 5

    val- true : Bool = (g1int_lnot 1) = ~2
    val- true : Bool = (6 \g1int_land 3) = 2
    val- true : Bool = (6 \g1int_lor 3) = 7
    val- true : Bool = (6 \g1int_lxor 3) = 5
    val- true : Bool = (lnot 1) = ~2
    val- true : Bool = (6 land 3) = 2
    val- true : Bool = (6 lor 3) = 7
    val- true : Bool = (6 lxor 3) = 5

    val- true : bool = (g0uint_lnot 1U) = $extval (uint, "UINT_MAX - 1")
    val- true : bool = (6U \g0uint_land 3U) = 2
    val- true : bool = (6U \g0uint_lor 3U) = 7
    val- true : bool = (6U \g0uint_lxor 3U) = 5
    val- true : bool = (lnot 1U) = $extval (uint, "UINT_MAX - 1")
    val- true : bool = (6U land 3U) = 2
    val- true : bool = (6U lor 3U) = 7
    val- true : bool = (6U lxor 3U) = 5

    val- true : Bool = (g1uint_lnot 1U) = $extval (uInt, "UINT_MAX - 1")
    val- true : Bool = (6U \g1uint_land 3U) = 2U
    val- true : Bool = (6U \g1uint_lor 3U) = 7U
    val- true : Bool = (6U \g1uint_lxor 3U) = 5U
    val- true : Bool = (lnot 1U) = $extval (uInt, "UINT_MAX - 1")
    val- true : Bool = (6U land 3U) = 2U
    val- true : Bool = (6U lor 3U) = 7U
    val- true : Bool = (6U lxor 3U) = 5U
  in
  end

fn
test16 () : void =
  let
    val- true : bool = g0int_ctz 1 = 0
    val- true : bool = g0int_ctz 2 = 1
    val- true : bool = g0int_ctz 3 = 0
    val- true : bool = g0int_ctz 4 = 2
    val- true : bool = g0int_ctz 5 = 0
    val- true : bool = g0int_ctz 6 = 1
    val- true : bool = g0int_ctz 7L = 0
    val- true : bool = g0int_ctz 8LL = 3

    val- true : bool = ctz 1 = 0
    val- true : bool = ctz 2 = 1
    val- true : bool = ctz 3 = 0
    val- true : bool = ctz 4 = 2
    val- true : bool = ctz 5 = 0
    val- true : bool = ctz 6 = 1
    val- true : bool = ctz 7L = 0
    val- true : bool = ctz 8LL = 3

    val- true : Bool = g1int_ctz 1 = 0
    val- true : Bool = g1int_ctz 2L = 1
    val- true : Bool = g1int_ctz 3LL = 0
    val- true : Bool = g1int_ctz 4LL = 2
    val- true : Bool = g1int_ctz 5LL = 0
    val- true : Bool = g1int_ctz 6LL = 1
    val- true : Bool = g1int_ctz 7LL = 0
    val- true : Bool = g1int_ctz 8LL = 3

    val- true : Bool = ctz 1 = 0
    val- true : Bool = ctz 2L = 1
    val- true : Bool = ctz 3LL = 0
    val- true : Bool = ctz 4LL = 2
    val- true : Bool = ctz 5LL = 0
    val- true : Bool = ctz 6LL = 1
    val- true : Bool = ctz 7LL = 0
    val- true : Bool = ctz 8LL = 3

    val- true : bool = g0uint_ctz 1U = 0
    val- true : bool = g0uint_ctz 2U = 1
    val- true : bool = g0uint_ctz 3U = 0
    val- true : bool = g0uint_ctz 4U = 2
    val- true : bool = g0uint_ctz 5U = 0
    val- true : bool = g0uint_ctz 6U = 1
    val- true : bool = g0uint_ctz 7UL = 0
    val- true : bool = g0uint_ctz 8ULL = 3

    val- true : bool = ctz 1U = 0
    val- true : bool = ctz 2U = 1
    val- true : bool = ctz 3U = 0
    val- true : bool = ctz 4U = 2
    val- true : bool = ctz 5U = 0
    val- true : bool = ctz 6U = 1
    val- true : bool = ctz 7UL = 0
    val- true : bool = ctz 8ULL = 3

    val- true : Bool = g1uint_ctz 1U = 0
    val- true : Bool = g1uint_ctz 2UL = 1
    val- true : Bool = g1uint_ctz 3ULL = 0
    val- true : Bool = g1uint_ctz 4ULL = 2
    val- true : Bool = g1uint_ctz 5ULL = 0
    val- true : Bool = g1uint_ctz 6ULL = 1
    val- true : Bool = g1uint_ctz 7ULL = 0
    val- true : Bool = g1uint_ctz 8ULL = 3

    val- true : Bool = ctz 1U = 0
    val- true : Bool = ctz 2UL = 1
    val- true : Bool = ctz 3ULL = 0
    val- true : Bool = ctz 4ULL = 2
    val- true : Bool = ctz 5ULL = 0
    val- true : Bool = ctz 6ULL = 1
    val- true : Bool = ctz 7ULL = 0
    val- true : Bool = ctz 8ULL = 3

    (* Test lookup tables. *)
    val- true : bool = g0int_ctz (g0int2int<intknd,int8knd> 1) = 0
    val- true : bool = g0int_ctz (g0int2int<intknd,int8knd> 2) = 1
    val- true : bool = g0int_ctz (g0int2int<intknd,int8knd> 3) = 0
    val- true : bool = g0int_ctz (g0int2int<intknd,int8knd> 4) = 2
    val- true : bool = g0int_ctz (g0int2int<intknd,int8knd> 5) = 0
    val- true : bool = g0int_ctz (g0int2int<intknd,int8knd> 6) = 1
    val- true : bool = g0int_ctz (g0int2int<intknd,int8knd> 7) = 0
    val- true : bool = g0int_ctz (g0int2int<intknd,int8knd> 8) = 3
    val- true : bool = ctz (g0int2int<intknd,int8knd> 124) = 2
    val- true : bool = ctz (g0int2int<intknd,int8knd> 125) = 0
    val- true : bool = ctz (g0int2int<intknd,int8knd> 126) = 1
    val- true : bool = ctz (g0int2int<intknd,int8knd> 127) = 0
    val- true : bool = g0uint_ctz (g0int2uint<intknd,uint8knd> 1) = 0
    val- true : bool = g0uint_ctz (g0int2uint<intknd,uint8knd> 2) = 1
    val- true : bool = g0uint_ctz (g0int2uint<intknd,uint8knd> 3) = 0
    val- true : bool = g0uint_ctz (g0int2uint<intknd,uint8knd> 4) = 2
    val- true : bool = g0uint_ctz (g0int2uint<intknd,uint8knd> 5) = 0
    val- true : bool = g0uint_ctz (g0int2uint<intknd,uint8knd> 6) = 1
    val- true : bool = g0uint_ctz (g0int2uint<intknd,uint8knd> 7) = 0
    val- true : bool = g0uint_ctz (g0int2uint<intknd,uint8knd> 8) = 3
    val- true : bool = ctz (g0int2uint<intknd,uint8knd> 124) = 2
    val- true : bool = ctz (g0int2uint<intknd,uint8knd> 125) = 0
    val- true : bool = ctz (g0int2uint<intknd,uint8knd> 126) = 1
    val- true : bool = ctz (g0int2uint<intknd,uint8knd> 127) = 0
    val- true : bool = ctz (g0int2uint<intknd,uint8knd> 252) = 2
    val- true : bool = ctz (g0int2uint<intknd,uint8knd> 253) = 0
    val- true : bool = ctz (g0int2uint<intknd,uint8knd> 254) = 1
    val- true : bool = ctz (g0int2uint<intknd,uint8knd> 255) = 0
    val- true : Bool = g1int_ctz (g1int2int<intknd,int8knd> 8) = 3
    val- true : Bool = g1uint_ctz (g1int2uint<intknd,uint8knd> 8) = 3

    (* Test fallback implementations. *)
    val- true = $extfcall (int, "ats2_xprelude__ctz_intmax_fallback", g0int2int<intknd,intmaxknd> 1) = 0
    val- true = $extfcall (int, "ats2_xprelude__ctz_intmax_fallback", g0int2int<intknd,intmaxknd> 2) = 1
    val- true = $extfcall (int, "ats2_xprelude__ctz_intmax_fallback", g0int2int<intknd,intmaxknd> 3) = 0
    val- true = $extfcall (int, "ats2_xprelude__ctz_intmax_fallback", g0int2int<intknd,intmaxknd> 4) = 2
    val- true = $extfcall (int, "ats2_xprelude__ctz_intmax_fallback", g0int2int<intknd,intmaxknd> 5) = 0
    val- true = $extfcall (int, "ats2_xprelude__ctz_intmax_fallback", g0int2int<intknd,intmaxknd> 6) = 1
    val- true = $extfcall (int, "ats2_xprelude__ctz_intmax_fallback", g0int2int<intknd,intmaxknd> 7) = 0
    val- true = $extfcall (int, "ats2_xprelude__ctz_intmax_fallback", g0int2int<intknd,intmaxknd> 8) = 3
    val- true = $extfcall (int, "ats2_xprelude__ctz_intmax_fallback", g0int2int<intknd,intmaxknd> 16) = 4
    val- true = $extfcall (int, "ats2_xprelude__ctz_intmax_fallback", g0int2int<intknd,intmaxknd> 32) = 5
    val- true = $extfcall (int, "ats2_xprelude__ctz_intmax_fallback", g0int2int<intknd,intmaxknd> 64) = 6
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint32_fallback", g0int2uint<intknd,uint32knd> 1) = 0
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint32_fallback", g0int2uint<intknd,uint32knd> 2) = 1
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint32_fallback", g0int2uint<intknd,uint32knd> 3) = 0
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint32_fallback", g0int2uint<intknd,uint32knd> 4) = 2
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint32_fallback", g0int2uint<intknd,uint32knd> 5) = 0
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint32_fallback", g0int2uint<intknd,uint32knd> 6) = 1
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint32_fallback", g0int2uint<intknd,uint32knd> 7) = 0
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint32_fallback", g0int2uint<intknd,uint32knd> 8) = 3
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint32_fallback", g0int2uint<intknd,uint32knd> 16) = 4
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint32_fallback", g0int2uint<intknd,uint32knd> 32) = 5
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint32_fallback", g0int2uint<intknd,uint32knd> 64) = 6
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint64_fallback", g0int2uint<intknd,uint64knd> 1) = 0
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint64_fallback", g0int2uint<intknd,uint64knd> 2) = 1
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint64_fallback", g0int2uint<intknd,uint64knd> 3) = 0
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint64_fallback", g0int2uint<intknd,uint64knd> 4) = 2
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint64_fallback", g0int2uint<intknd,uint64knd> 5) = 0
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint64_fallback", g0int2uint<intknd,uint64knd> 6) = 1
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint64_fallback", g0int2uint<intknd,uint64knd> 7) = 0
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint64_fallback", g0int2uint<intknd,uint64knd> 8) = 3
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint64_fallback", g0int2uint<intknd,uint64knd> 16) = 4
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint64_fallback", g0int2uint<intknd,uint64knd> 32) = 5
    val- true = $extfcall (int, "ats2_xprelude__ctz_uint64_fallback", g0int2uint<intknd,uint64knd> 64) = 6
  in
  end

fn
test17 () : void =
  let
    val- true : bool = g0int_gcd (0, 0) = 0
    val- true : bool = g0int_gcd (5, 5) = 5
    val- true : bool = g0int_gcd (0, 5) = 5
    val- true : bool = g0int_gcd (5, 0) = 5
    val- true : bool = g0int_gcd (24, 36) = 12
    val- true : bool = g0int_gcd (36, 24) = 12
    val- true : bool = g0int_gcd (~36, 24) = 12
    val- true : bool = g0int_gcd (36, ~24) = 12
    val- true : bool = g0int_gcd (~36, ~24) = 12

    val- true : bool = g0uint_gcd (0U, 0U) = 0U
    val- true : bool = g0uint_gcd (5U, 5U) = 5U
    val- true : bool = g0uint_gcd (0U, 5U) = 5U
    val- true : bool = g0uint_gcd (5U, 0U) = 5U
    val- true : bool = g0uint_gcd (24U, 36U) = 12U
    val- true : bool = g0uint_gcd (36U, 24U) = 12U

    val- true : Bool = g1int_gcd (0, 0) = 0
    val- true : Bool = g1int_gcd (5, 5) = 5
    val- true : Bool = g1int_gcd (0, 5) = 5
    val- true : Bool = g1int_gcd (5, 0) = 5
    val- true : Bool = g1int_gcd (24, 36) = 12
    val- true : Bool = g1int_gcd (36, 24) = 12
    val- true : Bool = g1int_gcd (~36, 24) = 12
    val- true : Bool = g1int_gcd (36, ~24) = 12
    val- true : Bool = g1int_gcd (~36, ~24) = 12

    val- true : Bool = g1uint_gcd (0U, 0U) = 0U
    val- true : Bool = g1uint_gcd (5U, 5U) = 5U
    val- true : Bool = g1uint_gcd (0U, 5U) = 5U
    val- true : Bool = g1uint_gcd (5U, 0U) = 5U
    val- true : Bool = g1uint_gcd (24U, 36U) = 12U
    val- true : Bool = g1uint_gcd (36U, 24U) = 12U
  in
  end

fn
test18 () : void =
  let
    val- true : bool = g0int_ffs 0 = 0
    val- true : bool = g0int_ffs 1 = 1
    val- true : bool = g0int_ffs 2 = 2
    val- true : bool = g0int_ffs 3 = 1
    val- true : bool = g0int_ffs 4 = 3
    val- true : bool = g0int_ffs 5 = 1
    val- true : bool = g0int_ffs 6 = 2
    val- true : bool = g0int_ffs 7L = 1
    val- true : bool = g0int_ffs 8LL = 4

    val- true : bool = ffs 0 = 0
    val- true : bool = ffs 1 = 1
    val- true : bool = ffs 2 = 2
    val- true : bool = ffs 3 = 1
    val- true : bool = ffs 4 = 3
    val- true : bool = ffs 5 = 1
    val- true : bool = ffs 6 = 2
    val- true : bool = ffs 7L = 1
    val- true : bool = ffs 8LL = 4

    val- true : Bool = g1int_ffs 0 = 0
    val- true : Bool = g1int_ffs 1 = 1
    val- true : Bool = g1int_ffs 2L = 2
    val- true : Bool = g1int_ffs 3LL = 1
    val- true : Bool = g1int_ffs 4LL = 3
    val- true : Bool = g1int_ffs 5LL = 1
    val- true : Bool = g1int_ffs 6LL = 2
    val- true : Bool = g1int_ffs 7LL = 1
    val- true : Bool = g1int_ffs 8LL = 4

    val- true : Bool = ffs 0 = 0
    val- true : Bool = ffs 1 = 1
    val- true : Bool = ffs 2L = 2
    val- true : Bool = ffs 3LL = 1
    val- true : Bool = ffs 4LL = 3
    val- true : Bool = ffs 5LL = 1
    val- true : Bool = ffs 6LL = 2
    val- true : Bool = ffs 7LL = 1
    val- true : Bool = ffs 8LL = 4

    val- true : bool = g0uint_ffs 0U = 0
    val- true : bool = g0uint_ffs 1U = 1
    val- true : bool = g0uint_ffs 2U = 2
    val- true : bool = g0uint_ffs 3U = 1
    val- true : bool = g0uint_ffs 4U = 3
    val- true : bool = g0uint_ffs 5U = 1
    val- true : bool = g0uint_ffs 6U = 2
    val- true : bool = g0uint_ffs 7UL = 1
    val- true : bool = g0uint_ffs 8ULL = 4

    val- true : bool = ffs 0U = 0
    val- true : bool = ffs 1U = 1
    val- true : bool = ffs 2U = 2
    val- true : bool = ffs 3U = 1
    val- true : bool = ffs 4U = 3
    val- true : bool = ffs 5U = 1
    val- true : bool = ffs 6U = 2
    val- true : bool = ffs 7UL = 1
    val- true : bool = ffs 8ULL = 4

    val- true : Bool = g1uint_ffs 0U = 0
    val- true : Bool = g1uint_ffs 1U = 1
    val- true : Bool = g1uint_ffs 2UL = 2
    val- true : Bool = g1uint_ffs 3ULL = 1
    val- true : Bool = g1uint_ffs 4ULL = 3
    val- true : Bool = g1uint_ffs 5ULL = 1
    val- true : Bool = g1uint_ffs 6ULL = 2
    val- true : Bool = g1uint_ffs 7ULL = 1
    val- true : Bool = g1uint_ffs 8ULL = 4

    val- true : Bool = ffs 0U = 0
    val- true : Bool = ffs 1U = 1
    val- true : Bool = ffs 2UL = 2
    val- true : Bool = ffs 3ULL = 1
    val- true : Bool = ffs 4ULL = 3
    val- true : Bool = ffs 5ULL = 1
    val- true : Bool = ffs 6ULL = 2
    val- true : Bool = ffs 7ULL = 1
    val- true : Bool = ffs 8ULL = 4
  in
  end

fn
test19 () : void =
  let
    val- true : bool = g0int_fls 0 = 0
    val- true : bool = g0int_fls 1 = 1
    val- true : bool = g0int_fls 2 = 2
    val- true : bool = g0int_fls 3 = 2
    val- true : bool = g0int_fls 4 = 3
    val- true : bool = g0int_fls 5 = 3
    val- true : bool = g0int_fls 6 = 3
    val- true : bool = g0int_fls 7 = 3
    val- true : bool = g0int_fls 8 = 4
    val- true : bool = g0int_fls 16 = 5
    val- true : bool = g0int_fls 17 = 5
    val- true : bool = g0int_fls 31 = 5
    val- true : bool = g0int_fls 32 = 6
    val- true : bool = g0int_fls 33 = 6
    val- true : bool = g0int_fls 63 = 6
    val- true : bool = g0int_fls 64 = 7

    val- true : bool = fls 0 = 0
    val- true : bool = fls 1 = 1
    val- true : bool = fls 2 = 2
    val- true : bool = fls 3 = 2
    val- true : bool = fls 4 = 3
    val- true : bool = fls 5 = 3
    val- true : bool = fls 6 = 3
    val- true : bool = fls 7 = 3
    val- true : bool = fls 8 = 4
    val- true : bool = fls 16 = 5
    val- true : bool = fls 17 = 5
    val- true : bool = fls 31 = 5
    val- true : bool = fls 32 = 6
    val- true : bool = fls 33 = 6
    val- true : bool = fls 63 = 6
    val- true : bool = fls 64 = 7

    val- true : Bool = g1int_fls 0 = 0
    val- true : Bool = g1int_fls 1 = 1
    val- true : Bool = g1int_fls 2 = 2
    val- true : Bool = g1int_fls 3 = 2
    val- true : Bool = g1int_fls 4 = 3
    val- true : Bool = g1int_fls 5 = 3
    val- true : Bool = g1int_fls 6 = 3
    val- true : Bool = g1int_fls 7 = 3
    val- true : Bool = g1int_fls 8 = 4
    val- true : Bool = g1int_fls 16 = 5
    val- true : Bool = g1int_fls 17 = 5
    val- true : Bool = g1int_fls 31 = 5
    val- true : Bool = g1int_fls 32 = 6
    val- true : Bool = g1int_fls 33 = 6
    val- true : Bool = g1int_fls 63 = 6
    val- true : Bool = g1int_fls 64 = 7

    val- true : Bool = fls 0 = 0
    val- true : Bool = fls 1 = 1
    val- true : Bool = fls 2 = 2
    val- true : Bool = fls 3 = 2
    val- true : Bool = fls 4 = 3
    val- true : Bool = fls 5 = 3
    val- true : Bool = fls 6 = 3
    val- true : Bool = fls 7 = 3
    val- true : Bool = fls 8 = 4
    val- true : Bool = fls 16 = 5
    val- true : Bool = fls 17 = 5
    val- true : Bool = fls 31 = 5
    val- true : Bool = fls 32 = 6
    val- true : Bool = fls 33 = 6
    val- true : Bool = fls 63 = 6
    val- true : Bool = fls 64 = 7

    val- true : bool = g0uint_fls 0U = 0
    val- true : bool = g0uint_fls 1U = 1
    val- true : bool = g0uint_fls 2U = 2
    val- true : bool = g0uint_fls 3U = 2
    val- true : bool = g0uint_fls 4U = 3
    val- true : bool = g0uint_fls 5U = 3
    val- true : bool = g0uint_fls 6U = 3
    val- true : bool = g0uint_fls 7U = 3
    val- true : bool = g0uint_fls 8U = 4
    val- true : bool = g0uint_fls 16U = 5
    val- true : bool = g0uint_fls 17U = 5
    val- true : bool = g0uint_fls 31U = 5
    val- true : bool = g0uint_fls 32U = 6
    val- true : bool = g0uint_fls 33U = 6
    val- true : bool = g0uint_fls 63U = 6
    val- true : bool = g0uint_fls 64U = 7

    val- true : bool = fls 0U = 0
    val- true : bool = fls 1U = 1
    val- true : bool = fls 2U = 2
    val- true : bool = fls 3U = 2
    val- true : bool = fls 4U = 3
    val- true : bool = fls 5U = 3
    val- true : bool = fls 6U = 3
    val- true : bool = fls 7U = 3
    val- true : bool = fls 8U = 4
    val- true : bool = fls 16U = 5
    val- true : bool = fls 17U = 5
    val- true : bool = fls 31U = 5
    val- true : bool = fls 32U = 6
    val- true : bool = fls 33U = 6
    val- true : bool = fls 63U = 6
    val- true : bool = fls 64U = 7

    val- true : Bool = g1uint_fls 0U = 0
    val- true : Bool = g1uint_fls 1U = 1
    val- true : Bool = g1uint_fls 2U = 2
    val- true : Bool = g1uint_fls 3U = 2
    val- true : Bool = g1uint_fls 4U = 3
    val- true : Bool = g1uint_fls 5U = 3
    val- true : Bool = g1uint_fls 6U = 3
    val- true : Bool = g1uint_fls 7U = 3
    val- true : Bool = g1uint_fls 8U = 4
    val- true : Bool = g1uint_fls 16U = 5
    val- true : Bool = g1uint_fls 17U = 5
    val- true : Bool = g1uint_fls 31U = 5
    val- true : Bool = g1uint_fls 32U = 6
    val- true : Bool = g1uint_fls 33U = 6
    val- true : Bool = g1uint_fls 63U = 6
    val- true : Bool = g1uint_fls 64U = 7

    val- true : Bool = fls 0U = 0
    val- true : Bool = fls 1U = 1
    val- true : Bool = fls 2U = 2
    val- true : Bool = fls 3U = 2
    val- true : Bool = fls 4U = 3
    val- true : Bool = fls 5U = 3
    val- true : Bool = fls 6U = 3
    val- true : Bool = fls 7U = 3
    val- true : Bool = fls 8U = 4
    val- true : Bool = fls 16U = 5
    val- true : Bool = fls 17U = 5
    val- true : Bool = fls 31U = 5
    val- true : Bool = fls 32U = 6
    val- true : Bool = fls 33U = 6
    val- true : Bool = fls 63U = 6
    val- true : Bool = fls 64U = 7

    (* Test table-lookup for one-byte integers. *)
    val- true : bool = fls ((g0i2i 0) : int8) = 0
    val- true : bool = fls ((g0i2i 1) : int8) = 1
    val- true : bool = fls ((g0i2i 2) : int8) = 2
    val- true : bool = fls ((g0i2i 3) : int8) = 2
    val- true : bool = fls ((g0i2i 4) : int8) = 3
    val- true : bool = fls ((g0i2i 5) : int8) = 3
    val- true : bool = fls ((g0i2i 6) : int8) = 3
    val- true : bool = fls ((g0i2i 7) : int8) = 3
    val- true : bool = fls ((g0i2i 8) : int8) = 4
    val- true : bool = fls ((g0i2i 15) : int8) = 4
    val- true : bool = fls ((g0i2i 16) : int8) = 5
    val- true : bool = fls ((g0i2i 31) : int8) = 5
    val- true : bool = fls ((g0i2i 32) : int8) = 6
    val- true : bool = fls ((g0i2i 63) : int8) = 6
    val- true : bool = fls ((g0i2i 64) : int8) = 7
    val- true : bool = fls ((g0i2i 127) : int8) = 7
    val- true : Bool = fls ((g1i2i 0) : [i : nat] int8 i) = 0
    val- true : Bool = fls ((g1i2i 1) : [i : nat] int8 i) = 1
    val- true : Bool = fls ((g1i2i 2) : [i : nat] int8 i) = 2
    val- true : Bool = fls ((g1i2i 3) : [i : nat] int8 i) = 2
    val- true : Bool = fls ((g1i2i 4) : [i : nat] int8 i) = 3
    val- true : Bool = fls ((g1i2i 5) : [i : nat] int8 i) = 3
    val- true : Bool = fls ((g1i2i 6) : [i : nat] int8 i) = 3
    val- true : Bool = fls ((g1i2i 7) : [i : nat] int8 i) = 3
    val- true : Bool = fls ((g1i2i 8) : [i : nat] int8 i) = 4
    val- true : Bool = fls ((g1i2i 15) : [i : nat] int8 i) = 4
    val- true : Bool = fls ((g1i2i 16) : [i : nat] int8 i) = 5
    val- true : Bool = fls ((g1i2i 31) : [i : nat] int8 i) = 5
    val- true : Bool = fls ((g1i2i 32) : [i : nat] int8 i) = 6
    val- true : Bool = fls ((g1i2i 63) : [i : nat] int8 i) = 6
    val- true : Bool = fls ((g1i2i 64) : [i : nat] int8 i) = 7
    val- true : Bool = fls ((g1i2i 127) : [i : nat] int8 i) = 7
    val- true : bool = fls ((g0i2u 0) : uint8) = 0
    val- true : bool = fls ((g0i2u 1) : uint8) = 1
    val- true : bool = fls ((g0i2u 2) : uint8) = 2
    val- true : bool = fls ((g0i2u 3) : uint8) = 2
    val- true : bool = fls ((g0i2u 4) : uint8) = 3
    val- true : bool = fls ((g0i2u 5) : uint8) = 3
    val- true : bool = fls ((g0i2u 6) : uint8) = 3
    val- true : bool = fls ((g0i2u 7) : uint8) = 3
    val- true : bool = fls ((g0i2u 8) : uint8) = 4
    val- true : bool = fls ((g0i2u 15) : uint8) = 4
    val- true : bool = fls ((g0i2u 16) : uint8) = 5
    val- true : bool = fls ((g0i2u 31) : uint8) = 5
    val- true : bool = fls ((g0i2u 32) : uint8) = 6
    val- true : bool = fls ((g0i2u 63) : uint8) = 6
    val- true : bool = fls ((g0i2u 64) : uint8) = 7
    val- true : bool = fls ((g0i2u 127) : uint8) = 7
    val- true : bool = fls ((g0i2u 128) : uint8) = 8
    val- true : bool = fls ((g0i2u 255) : uint8) = 8
    val- true : Bool = fls ((g1i2u 0) : [i : nat] uint8 i) = 0
    val- true : Bool = fls ((g1i2u 1) : [i : nat] uint8 i) = 1
    val- true : Bool = fls ((g1i2u 2) : [i : nat] uint8 i) = 2
    val- true : Bool = fls ((g1i2u 3) : [i : nat] uint8 i) = 2
    val- true : Bool = fls ((g1i2u 4) : [i : nat] uint8 i) = 3
    val- true : Bool = fls ((g1i2u 5) : [i : nat] uint8 i) = 3
    val- true : Bool = fls ((g1i2u 6) : [i : nat] uint8 i) = 3
    val- true : Bool = fls ((g1i2u 7) : [i : nat] uint8 i) = 3
    val- true : Bool = fls ((g1i2u 8) : [i : nat] uint8 i) = 4
    val- true : Bool = fls ((g1i2u 15) : [i : nat] uint8 i) = 4
    val- true : Bool = fls ((g1i2u 16) : [i : nat] uint8 i) = 5
    val- true : Bool = fls ((g1i2u 31) : [i : nat] uint8 i) = 5
    val- true : Bool = fls ((g1i2u 32) : [i : nat] uint8 i) = 6
    val- true : Bool = fls ((g1i2u 63) : [i : nat] uint8 i) = 6
    val- true : Bool = fls ((g1i2u 64) : [i : nat] uint8 i) = 7
    val- true : Bool = fls ((g1i2u 127) : [i : nat] uint8 i) = 7
    val- true : Bool = fls ((g1i2u 128) : [i : nat] uint8 i) = 8
    val- true : Bool = fls ((g1i2u 255) : [i : nat] uint8 i) = 8

    (* Test the fallback implementation. *)
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 0) = 0
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 1) = 1
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 2) = 2
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 3) = 2
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 4) = 3
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 5) = 3
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 6) = 3
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 7) = 3
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 8) = 4
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 16) = 5
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 31) = 5
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 32) = 6
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 63) = 6
    val- true = $extfcall (int, "ats2_xprelude__fls_int16_fallback", g0int2int<intknd,int16knd> 64) = 7
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 0) = 0
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 1) = 1
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 2) = 2
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 3) = 2
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 4) = 3
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 5) = 3
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 6) = 3
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 7) = 3
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 8) = 4
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 16) = 5
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 31) = 5
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 32) = 6
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 63) = 6
    val- true = $extfcall (int, "ats2_xprelude__fls_uintmax_fallback", g0int2uint<intknd,uintmaxknd> 64) = 7
  in
  end

fn
test20 () : void =
  let
    val num_trials = 100
    var i : int
  in
    for (i := 0; i != num_trials; i := succ i)
      let
        val r = random_double ()

        val n1 = (g0f2i (min (floor (r * succ (g0i2f INT_MAX)), g0i2f INT_MAX))) : int
        val n2 = (g0f2i (min (floor (r * succ (g0i2f LINT_MAX)), g0i2f LINT_MAX))) : lint
        val n3 = (g0f2i (min (floor (r * succ (g0i2f LLINT_MAX)), g0i2f LLINT_MAX))) : llint
        val n4 = (g0i2u n1) : uint
        val n5 = (g0i2u n2) : ulint
        val n6 = (g0i2u n3) : ullint
        val n7 = (g0f2i (min (floor (r * succ (g0i2f INT8_MAX)), g0i2f INT8_MAX))) : int8
        val n8 = (g0i2u n7) : uint8

        val- true : bool = popcount n1 = brute_force_popcount<intknd> n1
        val- true : bool = popcount n2 = brute_force_popcount<lintknd> n2
        val- true : bool = popcount n3 = brute_force_popcount<llintknd> n3
        val- true : bool = popcount n4 = brute_force_popcount<uintknd> n4
        val- true : bool = popcount n5 = brute_force_popcount<ulintknd> n5
        val- true : bool = popcount n6 = brute_force_popcount<ullintknd> n6
        val- true : bool = popcount n7 = brute_force_popcount<int8knd> n7
        val- true : bool = popcount n8 = brute_force_popcount<uint8knd> n8

        val [m1 : int] m1 = g1ofg0 n1
        val [m2 : int] m2 = g1ofg0 n2
        val [m3 : int] m3 = g1ofg0 n3
        val [m4 : int] m4 = g1ofg0 n4
        val [m5 : int] m5 = g1ofg0 n5
        val [m6 : int] m6 = g1ofg0 n6
        val [m7 : int] m7 = g1ofg0 n7
        val [m8 : int] m8 = g1ofg0 n8

        val () = assertloc (isgtez m1)
        val () = assertloc (isgtez m2)
        val () = assertloc (isgtez m3)
        prval () = lemma_g1uint_param m4
        prval () = lemma_g1uint_param m5
        prval () = lemma_g1uint_param m6
        val () = assertloc (isgtez m7)
        prval () = lemma_g1uint_param m8

        prval () = lemma_popcount_isnat {m1} ()
        prval () = lemma_popcount_isnat {m2} ()
        prval () = lemma_popcount_isnat {m3} ()
        prval () = lemma_popcount_isnat {m4} ()
        prval () = lemma_popcount_isnat {m5} ()
        prval () = lemma_popcount_isnat {m6} ()
        prval () = lemma_popcount_isnat {m7} ()
        prval () = lemma_popcount_isnat {m8} ()

        val pc1 = popcount m1
        val pc2 = popcount m2
        val pc3 = popcount m3
        val pc4 = popcount m4
        val pc5 = popcount m5
        val pc6 = popcount m6
        val pc7 = popcount m7
        val pc8 = popcount m8

        prval [pc1 : int] EQINT () = eqint_make_gint pc1
        prval [pc2 : int] EQINT () = eqint_make_gint pc2
        prval [pc3 : int] EQINT () = eqint_make_gint pc3
        prval [pc4 : int] EQINT () = eqint_make_gint pc4
        prval [pc5 : int] EQINT () = eqint_make_gint pc5
        prval [pc6 : int] EQINT () = eqint_make_gint pc6
        prval [pc7 : int] EQINT () = eqint_make_gint pc7
        prval [pc8 : int] EQINT () = eqint_make_gint pc8

        prval () = prop_verify {0 <= pc1} ()
        prval () = prop_verify {0 <= pc2} ()
        prval () = prop_verify {0 <= pc3} ()
        prval () = prop_verify {0 <= pc4} ()
        prval () = prop_verify {0 <= pc5} ()
        prval () = prop_verify {0 <= pc6} ()
        prval () = prop_verify {0 <= pc7} ()
        prval () = prop_verify {0 <= pc8} ()

        val bfpc1 = g1ofg0 (brute_force_popcount<intknd> m1)
        val bfpc2 = g1ofg0 (brute_force_popcount<lintknd> m2)
        val bfpc3 = g1ofg0 (brute_force_popcount<llintknd> m3)
        val bfpc4 = g1ofg0 (brute_force_popcount<uintknd> m4)
        val bfpc5 = g1ofg0 (brute_force_popcount<ulintknd> m5)
        val bfpc6 = g1ofg0 (brute_force_popcount<ullintknd> m6)
        val bfpc7 = g1ofg0 (brute_force_popcount<int8knd> m7)
        val bfpc8 = g1ofg0 (brute_force_popcount<uint8knd> m8)

        val () = assertloc (0 <= bfpc1)
        val () = assertloc (0 <= bfpc2)
        val () = assertloc (0 <= bfpc3)
        val () = assertloc (0 <= bfpc4)
        val () = assertloc (0 <= bfpc5)
        val () = assertloc (0 <= bfpc6)
        val () = assertloc (0 <= bfpc7)
        val () = assertloc (0 <= bfpc8)

        val- true : Bool = pc1 = bfpc1
        val- true : Bool = pc2 = bfpc2
        val- true : Bool = pc3 = bfpc3
        val- true : Bool = pc4 = bfpc4
        val- true : Bool = pc5 = bfpc5
        val- true : Bool = pc6 = bfpc6
        val- true : Bool = pc7 = bfpc7
        val- true : Bool = pc8 = bfpc8

        (* Test fallback implementations. *)
        val- true = $extfcall (int, "ats2_xprelude__popcount_int_fallback", n1) = bfpc1
        val- true = $extfcall (int, "ats2_xprelude__popcount_lint_fallback", n2) = bfpc2
        val- true = $extfcall (int, "ats2_xprelude__popcount_llint_fallback", n3) = bfpc3
        val- true = $extfcall (int, "ats2_xprelude__popcount_uint_fallback", n4) = bfpc4
        val- true = $extfcall (int, "ats2_xprelude__popcount_ulint_fallback", n5) = bfpc5
        val- true = $extfcall (int, "ats2_xprelude__popcount_ullint_fallback", n6) = bfpc6
      in
      end
  end

fn
test21 () : void =
  let
    val () = println! (g0uint_ipow_uint_uint (5U, 3U))
    val () = println! ((~2) ** 10)
    val () = println! (0UL ** 0)
    val () = println! (0U ** 0U)
    val () = println! ((~1) ** 20000U)
    val () = println! ((~1) ** 1001)
  in
  end

implement
main () =
  begin
    test1 ();
    test2 ();
    test3 ();
    test4 ();
    test5 ();
    test6 ();
    test7 ();
    test8 ();
    test9 ();
    test10 ();
    test11 ();
    test12 ();
    test13 ();
    test14 ();
    test15 ();
    test16 ();
    test17 ();
    test18 ();
    test19 ();
    test20 ();
    test21 ();
    0
  end

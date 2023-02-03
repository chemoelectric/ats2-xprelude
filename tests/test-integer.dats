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

staload UN = "prelude/SATS/unsafe.sats"

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

    (* Test the fallback implementation. *)
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
    0
  end

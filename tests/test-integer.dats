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

    val- true = 1U + 2U + 3U + 4U = 10
    val- true : Bool = 10U - 2U - 3U - 4U = 1U
    val- true = 1U * 2U * 3U * 4U = 24
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
    0
  end

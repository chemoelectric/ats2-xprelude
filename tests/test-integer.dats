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

implement
main () =
  begin
    test1 ();
    test2 ();
    test3 ();
    0
  end

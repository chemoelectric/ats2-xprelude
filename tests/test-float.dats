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

#define ATS_EXTERN_PREFIX "ats2_poly_"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload UN = "prelude/SATS/unsafe.sats"

implement
main0 () =
  let
    val- true = epsilon<fltknd> () > 0.0F
    val- true = epsilon<dblknd> () > 0.0
    val- true = epsilon<ldblknd> () > 0.0L
    val- true = epsilon<fltknd> () <= 1E-5F
    val- true = epsilon<dblknd> () <= 1E-9
    val- true = epsilon<ldblknd> () <= 1E-9L

    val- true = sgn ~1.0F = ~1
    val- true = sgn ~2.0 = ~1
    val- true = sgn ~3.0L = ~1
    val- true = sgn 0.0F = 0
    val- true = sgn 0.0 = 0
    val- true = sgn 0.0L = 0
    val- true = sgn 1.0F = 1
    val- true = sgn 2.0 = 1
    val- true = sgn 3.0L = 1

    val- true = round 5.2F = 5.0F
    val- true = round ~5.2F = ~5.0F
    val- true = round 5.2 = 5.0
    val- true = round ~5.2 = ~5.0
    val- true = round 5.2L = 5.0L
    val- true = round ~5.2L = ~5.0L
    val- true = round 4.5L = 5.0L
    val- true = round 5.5L = 6.0L
    val- true = round ~4.5L = ~5.0L
    val- true = round ~5.5L = ~6.0L

    val- true = nearbyint 5.2F = 5.0F
    val- true = nearbyint ~5.2F = ~5.0F
    val- true = nearbyint 5.2 = 5.0
    val- true = nearbyint ~5.2 = ~5.0
    val- true = nearbyint 5.2L = 5.0L
    val- true = nearbyint ~5.2L = ~5.0L
    val- true = nearbyint 4.5L = 4.0L
    val- true = nearbyint 5.5L = 6.0L
    val- true = nearbyint ~4.5L = ~4.0L
    val- true = nearbyint ~5.5L = ~6.0L

    val- true = rint 5.2F = 5.0F
    val- true = rint ~5.2F = ~5.0F
    val- true = rint 5.2 = 5.0
    val- true = rint ~5.2 = ~5.0
    val- true = rint 5.2L = 5.0L
    val- true = rint ~5.2L = ~5.0L
    val- true = rint 4.5L = 4.0L
    val- true = rint 5.5L = 6.0L
    val- true = rint ~4.5L = ~4.0L
    val- true = rint ~5.5L = ~6.0L

    val- true = floor 5.2F = 5.0F
    val- true = floor ~5.2F = ~6.0F
    val- true = floor 5.2 = 5.0
    val- true = floor ~5.2 = ~6.0
    val- true = floor 5.2L = 5.0L
    val- true = floor ~5.2L = ~6.0L
    val- true = floor 4.5L = 4.0L
    val- true = floor 5.5L = 5.0L

    val- true = ceil 5.2F = 6.0F
    val- true = ceil ~5.2F = ~5.0F
    val- true = ceil 5.2 = 6.0
    val- true = ceil ~5.2 = ~5.0
    val- true = ceil 5.2L = 6.0L
    val- true = ceil ~5.2L = ~5.0L
    val- true = ceil 4.5L = 5.0L
    val- true = ceil 5.5L = 6.0L

    val- true = trunc 5.2F = 5.0F
    val- true = trunc ~5.2F = ~5.0F
    val- true = trunc 5.2 = 5.0
    val- true = trunc ~5.2 = ~5.0
    val- true = trunc 5.2L = 5.0L
    val- true = trunc ~5.2L = ~5.0L
    val- true = trunc 4.5L = 4.0L
    val- true = trunc 5.5L = 5.0L

    val- true = sqrt 0.0F = 0.0F
    val- true = sqrt 1.0L = 1.0L
    val- true = sqrt 4.0 = 2.0
    val- true = sqrt 25.0 = 5.0

    val- true = sin 0.0F = 0.0F
    val- true = abs (sin 1.57079632675 - 1.0) < 0.000001
    val- true = cos 0.0L = 1.0L
    val- true = abs (cos 1.57079632675) < 0.000001
    val- true = abs (tan 0.785398163375 - 1.0) < 0.000001
    val- true = abs (asin 1.0 - 1.57079632675) < 0.000001
    val- true = abs (acos 0.0 - 1.57079632675) < 0.000001
    val- true = abs (atan 1.0 - 0.785398163375) < 0.000001
    val- true = abs (atan2 (3.0L, 4.0L) - 0.643501108793284L) < 0.000001L
  in
  end

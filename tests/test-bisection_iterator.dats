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

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload UN = "prelude/SATS/unsafe.sats"

staload "xprelude/SATS/exrat.sats"
staload _ = "xprelude/DATS/exrat.dats"

staload "xprelude/SATS/bisection_iterator.sats"
staload _ = "xprelude/DATS/bisection_iterator.dats"

fn
test1 () : void =
  let
    val iter = bisection_iterator_forwards_make ()
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (0, 1)
    val- true = b = exrat_make (1, 1)

    val iter = bisection_iterator_next iter
    val- true = bisection_iterator_done iter
  in
  end

fn
test2 () : void =
  let
    val iter = bisection_iterator_backwards_make ()
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (0, 1)
    val- true = b = exrat_make (1, 1)

    val iter = bisection_iterator_next iter
    val- true = bisection_iterator_done iter
  in
  end

fn
test3 () : void =
  let
    val iter = bisection_iterator_forwards_make ()
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (0, 1)
    val- true = b = exrat_make (1, 1)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (0, 1)
    val- true = b = exrat_make (1, 2)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (0, 1)
    val- true = b = exrat_make (1, 4)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (0, 1)
    val- true = b = exrat_make (1, 8)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (1, 8)
    val- true = b = exrat_make (1, 4)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (1, 4)
    val- true = b = exrat_make (1, 2)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (1, 4)
    val- true = b = exrat_make (3, 8)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (1, 4)
    val- true = b = exrat_make (5, 16)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (5, 16)
    val- true = b = exrat_make (3, 8)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (3, 8)
    val- true = b = exrat_make (1, 2)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (3, 8)
    val- true = b = exrat_make (7, 16)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (7, 16)
    val- true = b = exrat_make (1, 2)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (7, 16)
    val- true = b = exrat_make (15, 32)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (15, 32)
    val- true = b = exrat_make (1, 2)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (1, 2)
    val- true = b = exrat_make (1, 1)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (1, 2)
    val- true = b = exrat_make (3, 4)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (3, 4)
    val- true = b = exrat_make (1, 1)

    val iter = bisection_iterator_next iter
    val- true = bisection_iterator_done iter
  in
  end

fn
test4 () : void =
  let
    val iter = bisection_iterator_backwards_make ()
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (0, 1)
    val- true = b = exrat_make (1, 1)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (1, 2)
    val- true = b = exrat_make (1, 1)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (3, 4)
    val- true = b = exrat_make (1, 1)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (7, 8)
    val- true = b = exrat_make (1, 1)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (3, 4)
    val- true = b = exrat_make (7, 8)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (1, 2)
    val- true = b = exrat_make (3, 4)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (5, 8)
    val- true = b = exrat_make (3, 4)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (11, 16)
    val- true = b = exrat_make (3, 4)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (5, 8)
    val- true = b = exrat_make (11, 16)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (1, 2)
    val- true = b = exrat_make (5, 8)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (9, 16)
    val- true = b = exrat_make (5, 8)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (1, 2)
    val- true = b = exrat_make (9, 16)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (17, 32)
    val- true = b = exrat_make (9, 16)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (1, 2)
    val- true = b = exrat_make (17, 32)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (0, 1)
    val- true = b = exrat_make (1, 2)

    val iter = bisection_iterator_bisect iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (1, 4)
    val- true = b = exrat_make (1, 2)

    val iter = bisection_iterator_next iter
    val- false = bisection_iterator_done iter
    val @(a, b) = bisection_iterator_interval iter
    val- true = a = exrat_make (0, 1)
    val- true = b = exrat_make (1, 4)

    val iter = bisection_iterator_next iter
    val- true = bisection_iterator_done iter
  in
  end

implement
main () =
  begin
    test1 ();
    test2 ();
    test3 ();
    test4 ();
    0
  end

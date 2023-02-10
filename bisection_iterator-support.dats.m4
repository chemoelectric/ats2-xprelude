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
include(`common-macros.m4')m4_include(`ats2-xprelude-macros.m4')
(*------------------------------------------------------------------*)

#define ATS_DYNLOADFLAG 0
#define ATS_PACKNAME "ats2-xprelude.bisection_iterator"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload "xprelude/SATS/exrat.sats"
staload _ = "xprelude/DATS/exrat.dats"

staload "xprelude/SATS/bisection_iterator.sats"

(*------------------------------------------------------------------*)

typedef _bisection_iterator =
  '{
    numerator = exrat,
    denominator = exrat,
    backwards = bool
  }

assume bisection_iterator = _bisection_iterator

implement
bisection_iterator_forwards_make () =
  '{
    numerator = g0i2f 0,
    denominator = g0i2f 1,
    backwards = false
  }

implement
bisection_iterator_backwards_make () =
  '{
    numerator = g0i2f 0,
    denominator = g0i2f 1,
    backwards = true
  }

implement
bisection_iterator_done iter =
  let
    val '{
          numerator = numer,
          denominator = denom,
          backwards = _
        } = iter
  in
    (numer = denom) && iseqz (pred denom)
  end

implement
bisection_iterator_interval iter =
  if bisection_iterator_done iter then
    let
      val msg = "bisection_iterator_interval:past_end"
    in
      $raise IllegalArgExn msg
    end
  else
    let
      val '{
            numerator = numer,
            denominator = denom,
            backwards = backwards
          } = iter
    in
      if ~backwards then
        @(numer / denom, (succ numer) / denom)
      else
        let
          val top = denom - numer
        in
          @((pred top) / denom, top / denom)
        end
    end

implement
bisection_iterator_bisect iter =
  if bisection_iterator_done iter then
    let
      val msg = "bisection_iterator_bisect:past_end"
    in
      $raise IllegalArgExn msg
    end
  else
    let
      val '{
            numerator = numer,
            denominator = denom,
            backwards = backwards
          } = iter
    in
      '{
        numerator = mul_2exp (numer, 1),
        denominator = mul_2exp (denom, 1),
        backwards = backwards
      }
    end

implement
bisection_iterator_next iter =
  if bisection_iterator_done iter then
    let
      val msg = "bisection_iterator_next:past_end"
    in
      $raise IllegalArgExn msg
    end
  else
    let
      val '{
            numerator = numer,
            denominator = denom,
            backwards = backwards
          } = iter

      val numer = succ numer
      val shift_amount =
        (g0u2i (pred (exrat_numerator_ffs numer))) : intmax
    in
      '{
        numerator = div_2exp (numer, shift_amount),
        denominator = div_2exp (denom, shift_amount),
        backwards = backwards
      }
    end

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

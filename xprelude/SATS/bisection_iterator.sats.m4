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
(*

  Iteration, interval by interval, for adaptive bisection algorithms.

*)
(*------------------------------------------------------------------*)

#define ATS_PACKNAME "ats2-xprelude.bisection_iterator"

#include "xprelude/HATS/xprelude_sats.hats"
staload "xprelude/SATS/exrat.sats"

(*------------------------------------------------------------------*)

abstype bisection_iterator = ptr

(* Make a new bisection iterator that goes forwards. *)
fn
bisection_iterator_forwards_make :
  () -<> bisection_iterator

(* Make a new bisection iterator that goes backwards. *)
fn
bisection_iterator_backwards_make :
  () -<> bisection_iterator

(* Is iteration completed? *)
fn
bisection_iterator_done :
  bisection_iterator -<> bool

(* Return the current interval. Raises an exception if iteration was
   already completed. *)
fn
bisection_iterator_interval :
  bisection_iterator -< !exn > @(exrat, exrat)

(* Bisect the current interval. Raises an exception if iteration was
   already completed. *)
fn
bisection_iterator_bisect :
  bisection_iterator -< !exn > bisection_iterator

(* Move to the next interval. Raises an exception if iteration was
   already completed. *)
fn
bisection_iterator_next :
  bisection_iterator -< !exn > bisection_iterator

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

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
include(`common-macros.m4')m4_include(`ats2-xprelude-macros.m4')
(*------------------------------------------------------------------*)

#define ATS_PACKNAME "ats2-xprelude.sort"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "xprelude/HATS/xprelude_sats.hats"

(*------------------------------------------------------------------*)
(* Array sorting. *)

(* The comparison function. Defaults to gcompare_ref_ref<a>. *)
fn {a : vt@ype}
array_sort$cmp :
  (&a, &a) -<> int

(* Sorting, possibly unstable. *)
fn {a : vt@ype}
array_sort :
  {n : int}
  (&array (INV(a), n) >> array (a, n),
   size_t n) -< !wrt >
    void

(* Stable sorting. *)
fn {a : vt@ype}
array_stable_sort :
  {n : int}
  (&array (INV(a), n) >> array (a, n),
   size_t n) -< !wrt >
    void

(*------------------------------------------------------------------*)
(* Array sorting with functions or closures for the comparison. *)

fn {a : vt@ype}
array_sort_fun :
  {n : int}
  (&array (INV(a), n) >> array (a, n),
   size_t n,
   (&a, &a) -<> int) -< !wrt >
    void

fn {a : vt@ype}
array_stable_sort_fun :
  {n : int}
  (&array (INV(a), n) >> array (a, n),
   size_t n,
   (&a, &a) -<> int) -< !wrt >
    void

(* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - *)

fn {a : vt@ype}
array_sort_cloref :
  {n : int}
  (&array (INV(a), n) >> array (a, n),
   size_t n,
   (&a, &a) -<cloref> int) -< !wrt >
    void

fn {a : vt@ype}
array_stable_sort_cloref :
  {n : int}
  (&array (INV(a), n) >> array (a, n),
   size_t n,
   (&a, &a) -<cloref> int) -< !wrt >
    void

(* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - *)

fn {a : vt@ype}
array_sort_cloptr :
  {n : int}
  (&array (INV(a), n) >> array (a, n),
   size_t n,
   &((&a, &a) -<cloptr> int)) -< !wrt >
    void

fn {a : vt@ype}
array_stable_sort_cloptr :
  {n : int}
  (&array (INV(a), n) >> array (a, n),
   size_t n,
   &((&a, &a) -<cloptr> int)) -< !wrt >
    void

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

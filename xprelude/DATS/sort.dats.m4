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

#define ATS_DYNLOADFLAG 0

#define ATS_PACKNAME "ats2-xprelude.sort"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload "xprelude/SATS/sort.sats"

m4_if(using_array_timsort,`yes',
  `#include "timsort/HATS/array-timsort.hats"')

(*------------------------------------------------------------------*)

implement {a}
array_sort$cmp (x, y) =
  gcompare_ref_ref<a> (x, y)

(*------------------------------------------------------------------*)
(* Array sorting, possibly unstable. *)

m4_if(ARRAY_SORT,`timsort',
`
implement {a}
array_sort (arr, n) =
  let
    implement
    array_timsort$cmp<a> (x, y) =
      array_sort$cmp<a> (x, y)
  in
    array_timsort<a> (arr, n)
  end
',`
dnl
dnl  The default array sort is the prelude’s quicksort. It is
dnl  unstable.
dnl
implement {a}
array_sort (arr, n) =
  let
    implement
    array_quicksort$cmp<a> (x, y) =
      array_sort$cmp<a> (x, y)
  in
    array_quicksort<a> (arr, n)
  end
')

(*------------------------------------------------------------------*)
(* Array sorting, stable. *)

m4_if(ARRAY_STABLE_SORT,`timsort',
`
implement {a}
array_stable_sort (arr, n) =
  let
    implement
    array_timsort$cmp<a> (x, y) =
      array_sort$cmp<a> (x, y)
  in
    array_timsort<a> (arr, n)
  end
',`
dnl
dnl  The default stable array sort is the prelude’s list mergesort.
dnl  One moves the array contents to a list, sorts the list, then
dnl  moves the contents back into the array.
dnl
implement {a}
array_stable_sort (arr, n) =
  let
    implement
    list_vt_mergesort$cmp<a> (x, y) =
      array_sort$cmp<a> (x, y)

    val lst = list_vt_mergesort<a> (array2list (arr, n))
  in
    array_copy_from_list_vt<a> (arr, lst)
  end
')

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:
dnl

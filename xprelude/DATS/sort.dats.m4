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

staload UN = "prelude/SATS/unsafe.sats"

m4_if(WITH_TIMSORT,`yes',
`#include "timsort/HATS/array-timsort.hats"
')dnl

(*------------------------------------------------------------------*)

#ifndef VERBOSE_XPRELUDE #then
#define VERBOSE_XPRELUDE 0
#endif

(*------------------------------------------------------------------*)

(*------------------------------------------------------------------*)

#undef ARRAY_SORT
#undef ARRAY_STABLE_SORT
#undef LIST_SORT
#undef LIST_STABLE_SORT

#define DEFAULT_SORT 0
#define PRELUDE_SORT 1
#define TIMSORT 2

#ifndef XPRELUDE_SORT #then
  #define XPRELUDE_SORT DEFAULT_SORT
#endif

#ifdef XPRELUDE_ARRAY_SORT
  #define ARRAY_SORT XPRELUDE_ARRAY_SORT
#endif
#ifdef XPRELUDE_ARRAY_STABLE_SORT
  #define ARRAY_STABLE_SORT XPRELUDE_ARRAY_STABLE_SORT
#endif
#ifdef XPRELUDE_LIST_SORT
  #define LIST_SORT XPRELUDE_LIST_SORT
#endif
#ifdef XPRELUDE_LIST_STABLE_SORT
  #define LIST_STABLE_SORT XPRELUDE_LIST_STABLE_SORT
#endif

#if XPRELUDE_SORT = 1 #then
  (* Force all unset sort implementations to be from the prelude. *)
  #ifndef ARRAY_SORT
    #define ARRAY_SORT PRELUDE_SORT
  #endif
  #ifndef ARRAY_STABLE_SORT
    #define ARRAY_STABLE_SORT PRELUDE_SORT
  #endif
  #ifndef LIST_SORT
    #define LIST_SORT PRELUDE_SORT
  #endif
  #ifndef LIST_STABLE_SORT
    #define LIST_STABLE_SORT PRELUDE_SORT
  #endif
#elif XPRELUDE_SORT = 2 #then
  (* Force all unset sort implementations to be from ats2-timsort. *)
  #ifndef ARRAY_SORT
    #define ARRAY_SORT TIMSORT
  #endif
  #ifndef ARRAY_STABLE_SORT
    #define ARRAY_STABLE_SORT TIMSORT
  #endif
  #ifndef LIST_SORT
    #define LIST_SORT TIMSORT
  #endif
  #ifndef LIST_STABLE_SORT
    #define LIST_STABLE_SORT TIMSORT
  #endif
#endif

(* Anything still unset gets set to the default. *)
#ifndef ARRAY_SORT #then
  #define ARRAY_SORT DEFAULT_SORT
#endif
#ifndef ARRAY_STABLE_SORT #then
  #define ARRAY_STABLE_SORT DEFAULT_SORT
#endif
#ifndef LIST_SORT #then
  #define LIST_SORT DEFAULT_SORT
#endif
#ifndef LIST_STABLE_SORT #then
  #define LIST_STABLE_SORT DEFAULT_SORT
#endif

m4_if(WITH_TIMSORT,`no',
`
(* This package was built without support for timsort, so override
   requests for timsort. *)
#if ARRAY_SORT = TIMSORT #then
  #define ARRAY_SORT DEFAULT_SORT
#endif
#if ARRAY_STABLE_SORT = TIMSORT #then
  #define ARRAY_STABLE_SORT DEFAULT_SORT
#endif
#if LIST_SORT = TIMSORT #then
  #define LIST_SORT DEFAULT_SORT
#endif
#if LIST_STABLE_SORT = TIMSORT #then
  #define LIST_STABLE_SORT DEFAULT_SORT
#endif
')dnl

m4_if(WITH_TIMSORT,`yes',
`
(* Default to timsort. *)
#if ARRAY_SORT = DEFAULT_SORT #then
  #define ARRAY_SORT TIMSORT
#endif
#if ARRAY_STABLE_SORT = DEFAULT_SORT #then
  #define ARRAY_STABLE_SORT TIMSORT
#endif
#if LIST_SORT = DEFAULT_SORT #then
  #define LIST_SORT TIMSORT
#endif
#if LIST_STABLE_SORT = DEFAULT_SORT #then
  #define LIST_STABLE_SORT TIMSORT
#endif
',`
(* Default to sorting based on the prelude. *)
#if ARRAY_SORT = DEFAULT_SORT #then
  #define ARRAY_SORT PRELUDE_SORT
#endif
#if ARRAY_STABLE_SORT = DEFAULT_SORT #then
  #define ARRAY_STABLE_SORT PRELUDE_SORT
#endif
#if LIST_SORT = DEFAULT_SORT #then
  #define LIST_SORT PRELUDE_SORT
#endif
#if LIST_STABLE_SORT = DEFAULT_SORT #then
  #define LIST_STABLE_SORT PRELUDE_SORT
#endif
')dnl

(*------------------------------------------------------------------*)

implement {a}
array_sort$cmp (x, y) =
  gcompare_ref_ref<a> (x, y)

(*------------------------------------------------------------------*)
(* Array sorting, possibly unstable. *)

extern fn {a : vt@ype}
_array_sort__array_quicksort :
  $d2ctype (array_sort<a>)

extern fn {a : vt@ype}
_array_sort__array_timsort :
  $d2ctype (array_sort<a>)

implement {a}
_array_sort__array_quicksort (arr, n) =
  let
    implement
    array_quicksort$cmp<a> (x, y) =
      array_sort$cmp<a> (x, y)
  in
    array_quicksort<a> (arr, n)
  end

m4_if(WITH_TIMSORT,`yes',
`
implement {a}
_array_sort__array_timsort (arr, n) =
  let
    implement
    array_timsort$cmp<a> (x, y) =
      array_sort$cmp<a> (x, y)
  in
    array_timsort<a> (arr, n)
  end
')dnl

implement {a}
array_sort (arr, n) =
  let
    #if ARRAY_SORT = PRELUDE_SORT #then
      #if VERBOSE_XPRELUDE #then
        #print "xprelude: array_sort calls array_quicksort from the prelude\n"
      #endif
      val () = _array_sort__array_quicksort<a> (arr, n)
    #elif ARRAY_SORT = TIMSORT #then
      #if VERBOSE_XPRELUDE #then
        #print "xprelude: array_sort calls array_timsort from ats2-timsort\n"
      #endif
      val () = _array_sort__array_timsort<a> (arr, n)
    #endif
  in
  end

(*------------------------------------------------------------------*)
(* Array sorting, stable. *)

extern fn {a : vt@ype}
_array_stable_sort__list_vt_mergesort :
  $d2ctype (array_sort<a>)

extern fn {a : vt@ype}
_array_stable_sort__array_timsort :
  $d2ctype (array_sort<a>)

implement {a}
_array_stable_sort__list_vt_mergesort (arr, n) =
  let
    implement
    list_vt_mergesort$cmp<a> (x, y) =
      array_sort$cmp<a> (x, y)

    val lst = list_vt_mergesort<a> (array2list (arr, n))
  in
    array_copy_from_list_vt<a> (arr, lst)
  end

m4_if(WITH_TIMSORT,`yes',
`
implement {a}
_array_stable_sort__array_timsort (arr, n) =
  let
    implement
    array_timsort$cmp<a> (x, y) =
      array_sort$cmp<a> (x, y)
  in
    array_timsort<a> (arr, n)
  end
')dnl

implement {a}
array_stable_sort (arr, n) =
  let
    #if ARRAY_STABLE_SORT = PRELUDE_SORT #then
      #if VERBOSE_XPRELUDE #then
        #print "xprelude: array_stable_sort calls list_vt_mergesort from the prelude\n"
      #endif
      val () = _array_stable_sort__list_vt_mergesort<a> (arr, n)
    #elif ARRAY_STABLE_SORT = TIMSORT #then
      #if VERBOSE_XPRELUDE #then
        #print "xprelude: array_stable_sort calls array_timsort from ats2-timsort\n"
      #endif
      val () = _array_stable_sort__array_timsort<a> (arr, n)
    #endif
  in
  end

(*------------------------------------------------------------------*)
(* Derivatives of the basic array sorting. *)

m4_foreachq(`STAB',``',`stable_'',
`
implement {a}
array_`'STAB`'sort_fun (arr, n, cmp) =
  let
    implement
    array_sort$cmp<a> (x, y) =
      cmp (x, y)
  in
    array_`'STAB`'sort<a> (arr, n)
  end

implement {a}
array_`'STAB`'sort_cloref (arr, n, cmp) =
  let
    implement
    array_sort$cmp<a> (x, y) =
      cmp (x, y)
  in
    array_`'STAB`'sort<a> (arr, n)
  end

implement {a}
array_`'STAB`'sort_cloptr (arr, n, cmp) =
  let
    extern castfn
    make_view :
      {p : addr}
      ptr p -<>
        @(((&a, &a) -<cloptr> int) @ p,
          ((&a, &a) -<cloptr> int) @ p -<lin,prf> void |
          ptr p)

    val p_cmp = addr@ cmp

    implement
    array_sort$cmp<a> (x, y) =
      let
        val @(view, consume_view | p) = make_view p_cmp
        macdef cmp = !p
        val i = cmp (x, y)
        prval () = consume_view view
      in
        i
      end
  in
    array_`'STAB`'sort<a> (arr, n)
  end

implement {a}
arrayptr_`'STAB`'sort (arr, n) =
  let
    val p = ptrcast arr
    prval pf = arrayptr_takeout {a} arr
    val () = array_`'STAB`'sort<a> (!p, n)
    prval () = arrayptr_addback {a} (pf | arr)
  in
  end

m4_foreachq(`CMP',`fun,cloref,cloptr',
`
implement {a}
arrayptr_`'STAB`'sort_`'CMP (arr, n, cmp) =
  let
    val p = ptrcast arr
    prval pf = arrayptr_takeout {a} arr
    val () = array_`'STAB`'sort_`'CMP<a> (!p, n, cmp)
    prval () = arrayptr_addback {a} (pf | arr)
  in
  end
')dnl

implement {a}
arrayref_`'STAB`'sort (arr, n) =
  let
    val @(vbox pf | p) = arrayref_get_viewptr {a} arr
  in
    array_`'STAB`'sort<a> (!p, n)
  end

m4_foreachq(`CMP',`fun,cloref,cloptr',
`
implement {a}
arrayref_`'STAB`'sort_`'CMP (arr, n, cmp) =
  let
    val @(vbox pf | p) = arrayref_get_viewptr {a} arr
  in
    array_`'STAB`'sort_`'CMP<a> (!p, n, cmp)
  end
')dnl

implement {a}
arrszref_`'STAB`'sort arr =
  let
    extern praxi
    make_view :
      {p : addr}
      {n : int}
      () -<prf>
        @(array_v (a, p, n),
          array_v (a, p, n) -<lin,prf> void)

    val p = arrszref_get_ref {a} arr
    and n = g1ofg0 (arrszref_get_size {a} arr)
    prval [p : addr] EQADDR () = eqaddr_make_ptr p
    prval [n : int] EQINT () = eqint_make_guint n

    prval @(pf, fpf) = make_view {p} {n} ()
    val () = array_`'STAB`'sort<a> (!p, n)
    prval () = fpf pf
  in
  end

m4_foreachq(`CMP',`fun,cloref,cloptr',
`
implement {a}
arrszref_`'STAB`'sort_`'CMP (arr, cmp) =
  let
    extern praxi
    make_view :
      {p : addr}
      {n : int}
      () -<prf>
        @(array_v (a, p, n),
          array_v (a, p, n) -<lin,prf> void)

    val p = arrszref_get_ref {a} arr
    and n = g1ofg0 (arrszref_get_size {a} arr)
    prval [p : addr] EQADDR () = eqaddr_make_ptr p
    prval [n : int] EQINT () = eqint_make_guint n

    prval @(pf, fpf) = make_view {p} {n} ()
    val () = array_`'STAB`'sort_`'CMP<a> (!p, n, cmp)
    prval () = fpf pf
  in
  end
')dnl

')dnl
(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:
dnl

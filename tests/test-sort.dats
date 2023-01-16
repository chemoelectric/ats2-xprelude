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
#include "xprelude/HATS/sort.hats"

staload "xprelude/SATS/fixed32p32.sats"
staload _ = "xprelude/DATS/fixed32p32.dats"

staload UN = "prelude/SATS/unsafe.sats"

macdef i2mx = g0int2int<intknd,intmaxknd>
macdef i2ld = g0int2float<intknd,ldblknd>
macdef i2fx = g0int2float<intknd,fix32p32knd>

fn {a : t@ype}
arrayref2list
          {n   : int}
          (arr : arrayref (a, n),
           n   : size_t n)
    :<!ref> list (a, n) =
  let
    fun
    loop {i : nat | i <= n}
         .<i>.
         (i     : size_t i,
          accum : list (a, n - i))
        :<!ref> list (a, n) =
      if iseqz i then
        accum
      else
        loop (pred i, list_cons (arr[pred i], accum))

    prval () = lemma_arrayref_param arr
  in
    loop (n, list_nil ())
  end

fn {a : t@ype}
arrszref2list
          (arr : arrszref a)
    :<!exnref> List0 a =
  let
    val n = g1ofg0 (size arr)
    prval [n : int] EQINT () = eqint_make_guint n

    fun
    loop {i : nat | i <= n}
         .<i>.
         (i     : size_t i,
          accum : list (a, n - i))
        :<!exnref> List0 a =
      if iseqz i then
        accum
      else
        loop (pred i, list_cons (arr[pred i], accum))
  in
    loop (n, list_nil ())
  end

fn
test1 () : void =
  let
    (* array_sort, using gcompare_val_val. *)

    val lst1 = $list (2, 5, 3, 4, 6, 1, 9, 8, 7, 0)
    var arr : @[int][10]
    val () = array_initize_list<int> (arr, 10, lst1)
    val () = array_sort<int> (arr, i2sz 10)
    val lst2 = list_vt2t (array2list (arr, i2sz 10))
    val- true = lst2 = $list (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)

    val lst1 = $list (i2mx 2, i2mx 5, i2mx 3, i2mx 4, i2mx 6,
                      i2mx 1, i2mx 9, i2mx 8, i2mx 7, i2mx 0)
    var arr : @[intmax][10]
    val () = array_initize_list<intmax> (arr, 10, lst1)
    val () = array_sort<intmax> (arr, i2sz 10)
    val lst2 = list_vt2t (array2list (arr, i2sz 10))
    val- true = lst2 = $list (i2mx 0, i2mx 1, i2mx 2, i2mx 3, i2mx 4,
                              i2mx 5, i2mx 6, i2mx 7, i2mx 8, i2mx 9)

    val lst1 = $list (i2ld 2, i2ld 5, i2ld 3, i2ld 4, i2ld 6,
                      i2ld 1, i2ld 9, i2ld 8, i2ld 7, i2ld 0)
    var arr : @[ldouble][10]
    val () = array_initize_list<ldouble> (arr, 10, lst1)
    val () = array_sort<ldouble> (arr, i2sz 10)
    val lst2 = list_vt2t (array2list (arr, i2sz 10))
    val- true = lst2 = $list (i2ld 0, i2ld 1, i2ld 2, i2ld 3, i2ld 4,
                              i2ld 5, i2ld 6, i2ld 7, i2ld 8, i2ld 9)
  in
  end

fn
test2 () : void =
  let
    (* array_stable_sort, using gcompare_val_val.

       There is no testing of stability, here. *)

    val lst1 = $list (2, 5, 3, 4, 6, 1, 9, 8, 7, 0)
    var arr : @[int][10]
    val () = array_initize_list<int> (arr, 10, lst1)
    val () = array_stable_sort<int> (arr, i2sz 10)
    val lst2 = list_vt2t (array2list (arr, i2sz 10))
    val- true = lst2 = $list (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)

    val lst1 = $list (i2mx 2, i2mx 5, i2mx 3, i2mx 4, i2mx 6,
                      i2mx 1, i2mx 9, i2mx 8, i2mx 7, i2mx 0)
    var arr : @[intmax][10]
    val () = array_initize_list<intmax> (arr, 10, lst1)
    val () = array_stable_sort<intmax> (arr, i2sz 10)
    val lst2 = list_vt2t (array2list (arr, i2sz 10))
    val- true = lst2 = $list (i2mx 0, i2mx 1, i2mx 2, i2mx 3, i2mx 4,
                              i2mx 5, i2mx 6, i2mx 7, i2mx 8, i2mx 9)

    val lst1 = $list (i2ld 2, i2ld 5, i2ld 3, i2ld 4, i2ld 6,
                      i2ld 1, i2ld 9, i2ld 8, i2ld 7, i2ld 0)
    var arr : @[ldouble][10]
    val () = array_initize_list<ldouble> (arr, 10, lst1)
    val () = array_stable_sort<ldouble> (arr, i2sz 10)
    val lst2 = list_vt2t (array2list (arr, i2sz 10))
    val- true = lst2 = $list (i2ld 0, i2ld 1, i2ld 2, i2ld 3, i2ld 4,
                              i2ld 5, i2ld 6, i2ld 7, i2ld 8, i2ld 9)
  in
  end

fn
test3 () : void =
  let
    (* array_sort, using functions and closures for the
       comparisons. *)

    val lst1 = $list (i2mx 2, i2mx 5, i2mx 3, i2mx 4, i2mx 6,
                      i2mx 1, i2mx 9, i2mx 8, i2mx 7, i2mx 0)
    val expected = $list (i2mx 0, i2mx 1, i2mx 2, i2mx 3, i2mx 4,
                          i2mx 5, i2mx 6, i2mx 7, i2mx 8, i2mx 9)

    var arr : @[intmax][10]

    (* function *)
    val () = array_initize_list<intmax> (arr, 10, lst1)
    val () = array_sort_fun<intmax> (arr, i2sz 10, lam (x, y) => compare (x, y))
    val lst2 = list_vt2t (array2list (arr, i2sz 10))
    val- true = lst2 = expected

    (* cloref *)
    val closure =
      lam (x : &intmax, y : &intmax) : int =<cloref>
        compare<intmaxknd> (x, y)
    val () = array_initize_list<intmax> (arr, 10, lst1)
    val () = array_sort_cloref<intmax> (arr, i2sz 10, closure)
    val lst2 = list_vt2t (array2list (arr, i2sz 10))
    val- true = lst2 = expected

    (* cloptr *)
    var closure =
      lam (x : &intmax, y : &intmax) : int =<cloptr>
        compare<intmaxknd> (x, y)
    val () = array_initize_list<intmax> (arr, 10, lst1)
    val () = array_sort_cloptr<intmax> (arr, i2sz 10, closure)
    val lst2 = list_vt2t (array2list (arr, i2sz 10))
    val- true = lst2 = expected
    val () = cloptr_free ($UN.castvwtp0{cloptr0} closure)
  in
  end

fn
test4 () : void =
  let
    (* array_stable_sort, using functions and closures for the
       comparisons. *)

    val lst1 = $list (i2mx 2, i2mx 5, i2mx 3, i2mx 4, i2mx 6,
                      i2mx 1, i2mx 9, i2mx 8, i2mx 7, i2mx 0)
    val expected = $list (i2mx 0, i2mx 1, i2mx 2, i2mx 3, i2mx 4,
                          i2mx 5, i2mx 6, i2mx 7, i2mx 8, i2mx 9)

    var arr : @[intmax][10]

    (* function *)
    val () = array_initize_list<intmax> (arr, 10, lst1)
    val () = array_stable_sort_fun<intmax> (arr, i2sz 10, lam (x, y) => compare (x, y))
    val lst2 = list_vt2t (array2list (arr, i2sz 10))
    val- true = lst2 = expected

    (* cloref *)
    val closure =
      lam (x : &intmax, y : &intmax) : int =<cloref>
        compare<intmaxknd> (x, y)
    val () = array_initize_list<intmax> (arr, 10, lst1)
    val () = array_stable_sort_cloref<intmax> (arr, i2sz 10, closure)
    val lst2 = list_vt2t (array2list (arr, i2sz 10))
    val- true = lst2 = expected

    (* cloptr *)
    var closure =
      lam (x : &intmax, y : &intmax) : int =<cloptr>
        compare<intmaxknd> (x, y)
    val () = array_initize_list<intmax> (arr, 10, lst1)
    val () = array_stable_sort_cloptr<intmax> (arr, i2sz 10, closure)
    val lst2 = list_vt2t (array2list (arr, i2sz 10))
    val- true = lst2 = expected
    val () = cloptr_free ($UN.castvwtp0{cloptr0} closure)
  in
  end

fn
test5 () : void =
  let
    (* Some arrayptr_sort and arrayptr_stable_sort tests (without
       tests of stability). *)

    val lst1 = $list (i2fx 2, i2fx 5, i2fx 3, i2fx 4, i2fx 6,
                      i2fx 1, i2fx 9, i2fx 8, i2fx 7, i2fx 0)
    val expected = $list (i2fx 0, i2fx 1, i2fx 2, i2fx 3, i2fx 4,
                          i2fx 5, i2fx 6, i2fx 7, i2fx 8, i2fx 9)

    val arr = arrayptr_make_list<fixed32p32> (10, lst1)
    val () = arrayptr_sort<fixed32p32> (arr, i2sz 10)
    val lst2 = list_vt2t (arrayptr_imake_list<fixed32p32> (arr, i2sz 10))
    val- true = lst2 = expected
    val () = arrayptr_free arr

    val arr = arrayptr_make_list<fixed32p32> (10, lst1)
    val () = arrayptr_stable_sort<fixed32p32> (arr, i2sz 10)
    val lst2 = list_vt2t (arrayptr_imake_list<fixed32p32> (arr, i2sz 10))
    val- true = lst2 = expected
    val () = arrayptr_free arr

    val arr = arrayptr_make_list<fixed32p32> (10, lst1)
    val () = arrayptr_sort_fun<fixed32p32> (arr, i2sz 10, lam (x, y) => compare (x, y))
    val lst2 = list_vt2t (arrayptr_imake_list<fixed32p32> (arr, i2sz 10))
    val- true = lst2 = expected
    val () = arrayptr_free arr

    val arr = arrayptr_make_list<fixed32p32> (10, lst1)
    val () = arrayptr_stable_sort_fun<fixed32p32> (arr, i2sz 10, lam (x, y) => compare (x, y))
    val lst2 = list_vt2t (arrayptr_imake_list<fixed32p32> (arr, i2sz 10))
    val- true = lst2 = expected
    val () = arrayptr_free arr

    val closure = lam (x : &fixed32p32, y : &fixed32p32) : int =<cloref> compare (x, y)
    val arr = arrayptr_make_list<fixed32p32> (10, lst1)
    val () = arrayptr_sort_cloref<fixed32p32> (arr, i2sz 10, closure)
    val lst2 = list_vt2t (arrayptr_imake_list<fixed32p32> (arr, i2sz 10))
    val- true = lst2 = expected
    val () = arrayptr_free arr

    val closure = lam (x : &fixed32p32, y : &fixed32p32) : int =<cloref> compare (x, y)
    val arr = arrayptr_make_list<fixed32p32> (10, lst1)
    val () = arrayptr_stable_sort_cloref<fixed32p32> (arr, i2sz 10, closure)
    val lst2 = list_vt2t (arrayptr_imake_list<fixed32p32> (arr, i2sz 10))
    val- true = lst2 = expected
    val () = arrayptr_free arr

    var closure = lam (x : &fixed32p32, y : &fixed32p32) : int =<cloptr> compare (x, y)
    val arr = arrayptr_make_list<fixed32p32> (10, lst1)
    val () = arrayptr_sort_cloptr<fixed32p32> (arr, i2sz 10, closure)
    val lst2 = list_vt2t (arrayptr_imake_list<fixed32p32> (arr, i2sz 10))
    val- true = lst2 = expected
    val () = arrayptr_free arr
    val () = cloptr_free ($UN.castvwtp0{cloptr0} closure)

    var closure = lam (x : &fixed32p32, y : &fixed32p32) : int =<cloptr> compare (x, y)
    val arr = arrayptr_make_list<fixed32p32> (10, lst1)
    val () = arrayptr_stable_sort_cloptr<fixed32p32> (arr, i2sz 10, closure)
    val lst2 = list_vt2t (arrayptr_imake_list<fixed32p32> (arr, i2sz 10))
    val- true = lst2 = expected
    val () = arrayptr_free arr
    val () = cloptr_free ($UN.castvwtp0{cloptr0} closure)
  in
  end

fn
test6 () : void =
  let
    (* Some arrayref_sort and arrayref_stable_sort tests (without
       tests of stability). *)

    val lst1 = $list (i2fx 2, i2fx 5, i2fx 3, i2fx 4, i2fx 6,
                      i2fx 1, i2fx 9, i2fx 8, i2fx 7, i2fx 0)
    val expected = $list (i2fx 0, i2fx 1, i2fx 2, i2fx 3, i2fx 4,
                          i2fx 5, i2fx 6, i2fx 7, i2fx 8, i2fx 9)

    val arr = arrayref_make_list<fixed32p32> (10, lst1)
    val () = arrayref_sort<fixed32p32> (arr, i2sz 10)
    val lst2 = arrayref2list<fixed32p32> (arr, i2sz 10)
    val- true = lst2 = expected

    val arr = arrayref_make_list<fixed32p32> (10, lst1)
    val () = arrayref_stable_sort<fixed32p32> (arr, i2sz 10)
    val lst2 = arrayref2list<fixed32p32> (arr, i2sz 10)
    val- true = lst2 = expected

    val arr = arrayref_make_list<fixed32p32> (10, lst1)
    val () = arrayref_sort_fun<fixed32p32> (arr, i2sz 10, lam (x, y) => compare (x, y))
    val lst2 = arrayref2list<fixed32p32> (arr, i2sz 10)
    val- true = lst2 = expected

    val arr = arrayref_make_list<fixed32p32> (10, lst1)
    val () = arrayref_stable_sort_fun<fixed32p32> (arr, i2sz 10, lam (x, y) => compare (x, y))
    val lst2 = arrayref2list<fixed32p32> (arr, i2sz 10)
    val- true = lst2 = expected

    val closure = lam (x : &fixed32p32, y : &fixed32p32) : int =<cloref> compare (x, y)
    val arr = arrayref_make_list<fixed32p32> (10, lst1)
    val () = arrayref_sort_cloref<fixed32p32> (arr, i2sz 10, closure)
    val lst2 = arrayref2list<fixed32p32> (arr, i2sz 10)
    val- true = lst2 = expected

    val closure = lam (x : &fixed32p32, y : &fixed32p32) : int =<cloref> compare (x, y)
    val arr = arrayref_make_list<fixed32p32> (10, lst1)
    val () = arrayref_stable_sort_cloref<fixed32p32> (arr, i2sz 10, closure)
    val lst2 = arrayref2list<fixed32p32> (arr, i2sz 10)
    val- true = lst2 = expected

    var closure = lam (x : &fixed32p32, y : &fixed32p32) : int =<cloptr> compare (x, y)
    val arr = arrayref_make_list<fixed32p32> (10, lst1)
    val () = arrayref_sort_cloptr<fixed32p32> (arr, i2sz 10, closure)
    val lst2 = arrayref2list<fixed32p32> (arr, i2sz 10)
    val- true = lst2 = expected
    val () = cloptr_free ($UN.castvwtp0 closure)

    var closure = lam (x : &fixed32p32, y : &fixed32p32) : int =<cloptr> compare (x, y)
    val arr = arrayref_make_list<fixed32p32> (10, lst1)
    val () = arrayref_stable_sort_cloptr<fixed32p32> (arr, i2sz 10, closure)
    val lst2 = arrayref2list<fixed32p32> (arr, i2sz 10)
    val- true = lst2 = expected
    val () = cloptr_free ($UN.castvwtp0 closure)
  in
  end

fn
test7 () : void =
  let
    (* Some arrszref_sort and arrszref_stable_sort tests (without
       tests of stability). *)

    val lst1 = $list (i2fx 2, i2fx 5, i2fx 3, i2fx 4, i2fx 6,
                      i2fx 1, i2fx 9, i2fx 8, i2fx 7, i2fx 0)
    val expected = $list (i2fx 0, i2fx 1, i2fx 2, i2fx 3, i2fx 4,
                          i2fx 5, i2fx 6, i2fx 7, i2fx 8, i2fx 9)

    val arr = arrszref_make_list<fixed32p32> lst1
    val () = arrszref_sort<fixed32p32> arr
    val lst2 = arrszref2list<fixed32p32> arr
    val- true = lst2 = expected

    val arr = arrszref_make_list<fixed32p32> lst1
    val () = arrszref_stable_sort<fixed32p32> arr
    val lst2 = arrszref2list<fixed32p32> arr
    val- true = lst2 = expected

    val arr = arrszref_make_list<fixed32p32> lst1
    val () = arrszref_sort_fun<fixed32p32> (arr, lam (x, y) => compare (x, y))
    val lst2 = arrszref2list<fixed32p32> arr
    val- true = lst2 = expected

    val arr = arrszref_make_list<fixed32p32> lst1
    val () = arrszref_stable_sort_fun<fixed32p32> (arr, lam (x, y) => compare (x, y))
    val lst2 = arrszref2list<fixed32p32> arr
    val- true = lst2 = expected

    val closure = lam (x : &fixed32p32, y : &fixed32p32) : int =<cloref> compare (x, y)
    val arr = arrszref_make_list<fixed32p32> lst1
    val () = arrszref_sort_cloref<fixed32p32> (arr, closure)
    val lst2 = arrszref2list<fixed32p32> arr
    val- true = lst2 = expected

    val closure = lam (x : &fixed32p32, y : &fixed32p32) : int =<cloref> compare (x, y)
    val arr = arrszref_make_list<fixed32p32> lst1
    val () = arrszref_stable_sort_cloref<fixed32p32> (arr, closure)
    val lst2 = arrszref2list<fixed32p32> arr
    val- true = lst2 = expected

    var closure = lam (x : &fixed32p32, y : &fixed32p32) : int =<cloptr> compare (x, y)
    val arr = arrszref_make_list<fixed32p32> lst1
    val () = arrszref_sort_cloptr<fixed32p32> (arr, closure)
    val lst2 = arrszref2list<fixed32p32> arr
    val- true = lst2 = expected
    val () = cloptr_free ($UN.castvwtp0 closure)

    var closure = lam (x : &fixed32p32, y : &fixed32p32) : int =<cloptr> compare (x, y)
    val arr = arrszref_make_list<fixed32p32> lst1
    val () = arrszref_stable_sort_cloptr<fixed32p32> (arr, closure)
    val lst2 = arrszref2list<fixed32p32> arr
    val- true = lst2 = expected
    val () = cloptr_free ($UN.castvwtp0 closure)
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
    0
  end

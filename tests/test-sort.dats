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

staload UN = "prelude/SATS/unsafe.sats"

macdef i2mx = g0int2int<intknd,intmaxknd>
macdef i2ld = g0int2float<intknd,ldblknd>

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

implement
main () =
  begin
    test1 ();
    test2 ();
    test3 ();
    test4 ();
    0
  end

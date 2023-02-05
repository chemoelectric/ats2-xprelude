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
#define ATS_PACKNAME "ats2-xprelude.integer"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

(******************************************************************
  Some integer support that is not included in the Postiats
  prelude, or that shadows what is in the prelude.
*******************************************************************)

%{#
#include "xprelude/CATS/integer.cats"
%}

staload "xprelude/SATS/arith_prf.sats"

(*------------------------------------------------------------------*)
(* intmax_t and uintmax_t. *)

tkindef intmax_kind = "intb2c(intmax)"
stadef intmaxknd = intmax_kind
typedef intmax0 = g0int intmaxknd
typedef intmax1 (i : int) = g1int (intmaxknd, i)
stadef intmax = intmax1 // 2nd-select
stadef intmax = intmax0 // 1st-select
stadef Intmax = [i : int] intmax1 i

tkindef uintmax_kind = "uintb2c(uintmax)"
stadef uintmaxknd = uintmax_kind
typedef uintmax0 = g0uint uintmaxknd
typedef uintmax1 (i : int) = g1uint (uintmaxknd, i)
stadef uintmax = uintmax1 // 2nd-select
stadef uintmax = uintmax0 // 1st-select
stadef uIntmax = [i : nat] uintmax1 i

(*------------------------------------------------------------------*)
(* Printing. *)

(* I give the overloads precedence 1, so they will take precedence
   over overloads of precedence 0 in the prelude. *)

m4_foreachq(`INT',`intbases',
`
fn fprint_`'INT : fprint_type (m4_g0int(INT)) = "mac#%"
fn print_`'INT : m4_g0int(INT) -> void = "mac#%"
fn prerr_`'INT : m4_g0int(INT) -> void = "mac#%"
overload fprint with fprint_`'INT of 1
overload print with print_`'INT of 1
overload prerr with prerr_`'INT of 1
')dnl

m4_foreachq(`UINT',`uintbases',
`
fn fprint_`'UINT : fprint_type (m4_g0uint(UINT)) = "mac#%"
fn print_`'UINT : m4_g0uint(UINT) -> void = "mac#%"
fn prerr_`'UINT : m4_g0uint(UINT) -> void = "mac#%"
overload fprint with fprint_`'UINT of 1
overload print with print_`'UINT of 1
overload prerr with prerr_`'UINT of 1
')dnl

(*------------------------------------------------------------------*)
(* Conversion to a string. *)

m4_foreachq(`INT',`intbases',
`
fn {} tostrptr_`'INT : m4_g0int(INT) -< !wrt > Strptr1
fn {} tostring_`'INT : m4_g0int(INT) -<> string
')dnl

m4_foreachq(`UINT',`uintbases',
`
fn {} tostrptr_`'UINT : m4_g0uint(UINT) -< !wrt > Strptr1
fn {} tostring_`'UINT : m4_g0uint(UINT) -<> string
')dnl

(*------------------------------------------------------------------*)
(* Type conversions. *)

m4_foreachq(`N',`0,1',

`m4_foreachq(`INT1',`intbases',
`m4_foreachq(`INT2',`intbases',
`m4_if(N,`0',`fn g`'N`'int2int_`'INT1`_'INT2 : m4_g0int(INT1) -<> m4_g0int(INT2) = "mac#%"',
       N,`1',`fn g`'N`'int2int_`'INT1`_'INT2 : {i : int} m4_g1int(INT1, i) -<> m4_g1int(INT2, i) = "mac#%"')
')
')dnl

m4_foreachq(`INT1',`intbases',
`m4_foreachq(`UINT2',`uintbases',
`m4_if(N,`0',`fn g`'N`'int2uint_`'INT1`_'UINT2 : m4_g0int(INT1) -<> m4_g0uint(UINT2) = "mac#%"',
       N,`1',`fn g`'N`'int2uint_`'INT1`_'UINT2 : {i : nat} m4_g1int(INT1, i) -<> m4_g1uint(UINT2, i) = "mac#%"')
')
')dnl

m4_foreachq(`UINT1',`uintbases',
`m4_foreachq(`INT2',`intbases',
`m4_if(N,`0',`fn g`'N`'uint2int_`'UINT1`_'INT2 : m4_g0uint(UINT1) -<> m4_g0int(INT2) = "mac#%"',
       N,`1',`fn g`'N`'uint2int_`'UINT1`_'INT2 : {i : int} m4_g1uint(UINT1, i) -<> [0 <= i] m4_g1int(INT2, i) = "mac#%"')
')
')dnl

m4_foreachq(`UINT1',`uintbases',
`m4_foreachq(`UINT2',`uintbases',
`m4_if(N,`0',`fn g`'N`'uint2uint_`'UINT1`_'UINT2 : m4_g0uint(UINT1) -<> m4_g0uint(UINT2) = "mac#%"',
       N,`1',`fn g`'N`'uint2uint_`'UINT1`_'UINT2 : {i : int} m4_g1uint(UINT1, i) -<> m4_g1uint(UINT2, i) = "mac#%"')
')
')dnl
')dnl

macdef g0i2i x = g0int2int ,(x)
macdef g1i2i x = g1int2int ,(x)

macdef g0i2u x = g0int2uint ,(x)
macdef g1i2u x = g1int2uint ,(x)

macdef g0u2i x = g0uint2int ,(x)
macdef g1u2i x = g1uint2int ,(x)

macdef g0u2u x = g0uint2uint ,(x)
macdef g1u2u x = g1uint2uint ,(x)

(*------------------------------------------------------------------*)
(* Comparisons. *)

m4_foreachq(`INT',`intbases',
`m4_foreachq(`OP',`comparisons',
`fn `g0int_'OP`_'INT : m4_g0int_comparison(INT) = "mac#%"
')
')dnl

m4_foreachq(`UINT',`uintbases',
`m4_foreachq(`OP',`comparisons',
`fn `g0uint_'OP`_'UINT : m4_g0uint_comparison(UINT) = "mac#%"
')
')dnl

m4_foreachq(`INT',`intbases',
`m4_foreachq(`OP',`comparisons',
`fn `g1int_'OP`_'INT : {i, j : int} m4_g1int_comparison(INT, i, j, i ats_cmp_static(OP) j) = "mac#%"
')
')dnl

m4_foreachq(`UINT',`uintbases',
`m4_foreachq(`OP',`comparisons',
`fn `g1uint_'OP`_'UINT : {i, j : int} m4_g1uint_comparison(UINT, i, j, i ats_cmp_static(OP) j) = "mac#%"
')
')dnl

(*------------------------------------------------------------------*)
(* Comparisons with zero. *)

// FIXME:
// FIXME:
// FIXME:
// FIXME:
// FIXME: The prelude accidentally exchanges the definitions of
//        g1uint_iseqz_type and g1uint_isneqz_type, and make other,
//        similar errors. These bugs should be reported.
// FIXME:
// FIXME:
// FIXME:
// FIXME:

m4_foreachq(`OP',`comparisons',
`fn {tk : tkind} `g1int_is'OP`z' : {i : int} m4_g1int_compare0(tk, i, i ats_cmp_static(OP) 0)
')dnl

m4_foreachq(`OP',`gt,eq,neq',
`m4_if(OP,`gt',`fn {tk : tkind} `g1uint_is'OP`z' : {i : int} m4_g1uint_compare0(tk, i, i > 0)',
       OP,`eq',`fn {tk : tkind} `g1uint_is'OP`z' : {i : int} m4_g1uint_compare0(tk, i, i == 0)',
       OP,`neq',`fn {tk : tkind} `g1uint_is'OP`z' : {i : int} m4_g1uint_compare0(tk, i, i > 0)')
')dnl

(* Set the precedences of the following overloads one higher than the
   equivalent overloads in the prelude (which has had bugs that we are
   working around). *)
m4_foreachq(`OP',`comparisons',
`overload `is'OP`z' with `g1int_is'OP`z' of 11
')dnl
m4_foreachq(`OP',`gt,eq,neq',
`overload `is'OP`z' with `g1uint_is'OP`z' of 11
')dnl

m4_foreachq(`INT',`intbases',
`m4_foreachq(`OP',`comparisons',
`fn `g0int_is'OP`z_'INT : m4_g0int_compare0(INT) = "mac#%"
')
')dnl

m4_foreachq(`UINT',`uintbases',
`m4_foreachq(`OP',`gt,eq,neq',
`fn `g0uint_is'OP`z_'UINT : m4_g0uint_compare0(UINT) = "mac#%"
')
')dnl

m4_foreachq(`INT',`intbases',
`m4_foreachq(`OP',`comparisons',
`fn `g1int_is'OP`z_'INT : {i : int} m4_g1int_compare0(INT, i, i ats_cmp_static(OP) 0) = "mac#%"
')
')dnl

m4_foreachq(`UINT',`uintbases',
`m4_foreachq(`OP',`gt,eq,neq',
`m4_if(OP,`gt',`fn g1uint_is`'OP`z_'UINT : {i : int} m4_g1uint_compare0(UINT, i, i > 0) = "mac#%"',
       OP,`eq',`fn g1uint_is`'OP`z_'UINT : {i : int} m4_g1uint_compare0(UINT, i, i == 0) = "mac#%"',
       OP,`neq',`fn g1uint_is`'OP`z_'UINT : {i : int} m4_g1uint_compare0(UINT, i, i > 0) = "mac#%"')
')
')dnl

(*------------------------------------------------------------------*)
(* ‘qsort-style’ comparison. *)

m4_foreachq(`INT',`intbases',
`
fn g0int_compare_`'INT : (m4_g0int(INT), m4_g0int(INT)) -<> `i'nt = "mac#%"
fn g1int_compare_`'INT : {i, j : int} (m4_g1int(INT, i), m4_g1int(INT, j)) -<> `i'nt (sgn (i - j)) = "mac#%"
')dnl

m4_foreachq(`UINT',`uintbases',
`
fn g0uint_compare_`'UINT : (m4_g0uint(UINT), m4_g0uint(UINT)) -<> `i'nt = "mac#%"
fn g1uint_compare_`'UINT : {i, j : int} (m4_g1uint(UINT, i), m4_g1uint(UINT, j)) -<> `i'nt (sgn (i - j)) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Negation. *)

m4_foreachq(`INT',`intbases',
`
fn g0int_neg_`'INT : m4_g0int_unary(INT) = "mac#%"
fn g1int_neg_`'INT : {i : int} m4_g1int_unary(INT, i, ~i) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Absolute value. *)

m4_foreachq(`INT',`intbases',
`
fn g0int_abs_`'INT : m4_g0int_unary(INT) = "mac#%"
fn g1int_abs_`'INT : {i : int} m4_g1int_unary(INT, i, abs i) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Successor and predecessor. *)

m4_foreachq(`INT',`intbases',
`
fn g0int_succ_`'INT : m4_g0int_unary(INT) = "mac#%"
fn g1int_succ_`'INT : {i : int} m4_g1int_unary(INT, i, i + 1) = "mac#%"
fn g0int_pred_`'INT : m4_g0int_unary(INT) = "mac#%"
fn g1int_pred_`'INT : {i : int} m4_g1int_unary(INT, i, i - 1) = "mac#%"
')dnl

m4_foreachq(`UINT',`uintbases',
`
fn g0uint_succ_`'UINT : m4_g0uint(UINT) -<> m4_g0uint(UINT) = "mac#%"
fn g1uint_succ_`'UINT : {i : int} m4_g1uint_unary(UINT, i, i + 1) = "mac#%"
fn g0uint_pred_`'UINT : m4_g0uint(UINT) -<> m4_g0uint(UINT) = "mac#%"
fn g1uint_pred_`'UINT : {i : pos} m4_g1uint_unary(UINT, i, i - 1) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Integer halving (ignoring remainder). *)

m4_foreachq(`INT',`intbases',
`
fn g0int_half_`'INT : m4_g0int_unary(INT) = "mac#%"
fn g1int_half_`'INT : {i : int} m4_g1int_unary(INT, i, i / 2) = "mac#%"
')dnl

m4_foreachq(`UINT',`uintbases',
`
fn g0uint_half_`'UINT : m4_g0uint_unary(UINT) = "mac#%"
fn g1uint_half_`'UINT : {i : int} m4_g1uint_unary(UINT, i, i / 2) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Addition. *)

m4_foreachq(`INT',`intbases',
`
fn g0int_add_`'INT : m4_g0int_binary(INT) = "mac#%"
fn g1int_add_`'INT : {i, j : int} m4_g1int_binary(INT, i, j, i + j) = "mac#%"
')dnl

m4_foreachq(`UINT',`uintbases',
`
fn g0uint_add_`'UINT : m4_g0uint_binary(UINT) = "mac#%"
fn g1uint_add_`'UINT : {i, j : int} m4_g1uint_binary(UINT, i, j, i + j) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Subtraction. *)

m4_foreachq(`INT',`intbases',
`
fn g0int_sub_`'INT : m4_g0int_binary(INT) = "mac#%"
fn g1int_sub_`'INT : {i, j : int} m4_g1int_binary(INT, i, j, i - j) = "mac#%"
')dnl

m4_foreachq(`UINT',`uintbases',
`
fn g0uint_sub_`'UINT : m4_g0uint_binary(UINT) = "mac#%"
fn g1uint_sub_`'UINT : {i, j : int | j <= i} m4_g1uint_binary(UINT, i, j, i - j) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Multiplication. *)

m4_foreachq(`INT',`intbases',
`
fn g0int_mul_`'INT : m4_g0int_binary(INT) = "mac#%"
fn g1int_mul_`'INT : {i, j : int} m4_g1int_binary(INT, i, j, i * j) = "mac#%"
')dnl

m4_foreachq(`UINT',`uintbases',
`
fn g0uint_mul_`'UINT : m4_g0uint_binary(UINT) = "mac#%"
fn g1uint_mul_`'UINT : {i, j : int} m4_g1uint_binary(UINT, i, j, i * j) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Division.

   The g1 versions of mod and nmod here have stronger postconditions
   than those in the prelude. *)

fn {tk : tkind}
g1int_nmod :
  {i, j : int | 0 <= i; 0 < j}
  (m4_g1int(tk, i), m4_g1int(tk, j)) -<>
    [r : nat | r < j; r == (i \nmod_int_int j)]
    m4_g1int(tk, r)

fn {tk : tkind}
g1uint_mod :
  {i, j : int | 0 < j}
  (m4_g1uint(tk, i), m4_g1uint(tk, j)) -<>
    [r : nat | r < j; r == (i \nmod_int_int j)]
    m4_g1uint(tk, r)

(* Set the precedences of the following overloads a little higher than
   the equivalent overloads in the prelude. *)
overload nmod with g1int_nmod of 22
overload nmod with nmod_g1int_int1 of 23
overload mod with g1uint_mod of 21

m4_foreachq(`INT',`intbases',
`
fn g0int_div_`'INT : m4_g0int_binary(INT) = "mac#%"
fn g1int_div_`'INT : {i, j : int | j != 0} m4_g1int_binary(INT, i, j, i \idiv_int_int j) = "mac#%"

fn g0int_mod_`'INT : m4_g0int_binary(INT) = "mac#%"
fn g1int_nmod_`'INT : $d2ctype (g1int_nmod<intb2k(INT)>) = "mac#%"
')dnl

m4_foreachq(`UINT',`uintbases',
`
fn g0uint_div_`'UINT : m4_g0uint_binary(UINT) = "mac#%"
fn g1uint_div_`'UINT : {i, j : int | 0 < j} (m4_g1uint(UINT, i), m4_g1uint(UINT, j)) -<>
  [q : nat | q == (i \ndiv_int_int j)] m4_g1uint(UINT, q) = "mac#%"

fn g0uint_mod_`'UINT : m4_g0uint_binary(UINT) = "mac#%"
fn g1uint_mod_`'UINT : $d2ctype (g1uint_mod<uintb2k(UINT)>) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Euclidean division with remainder always positive. *)

fn {tk : tkind}
g0int_eucliddiv :
  m4_g0int_binary(tk)

fn {tk : tkind}
g0int_euclidrem :
  m4_g0int_binary(tk)

fn {tk : tkind}
g0int_eucliddivrem :
  (m4_g0int(tk), m4_g0int(tk)) -<> @(m4_g0int(tk), m4_g0int(tk))

fn {tk : tkind}
g1int_eucliddiv :
  {i, j : int | j != 0}
  m4_g1int_binary(tk, i, j, i \eucliddiv j)

fn {tk : tkind}
g1int_euclidrem :
  {i, j : int | j != 0}
  m4_g1int_binary(tk, i, j, i \euclidrem j)

fn {tk : tkind}
g1int_eucliddivrem :
  {i, j : int | j != 0}
  (m4_g1int(tk, i), m4_g1int(tk, j)) -<>
    @(m4_g1int(tk, i \eucliddiv j),
      m4_g1int(tk, i \euclidrem j))

m4_foreachq(`INT',`intbases',
`
fn g0int_eucliddiv_`'INT : $d2ctype (g0int_eucliddiv<intb2k(INT)>) = "mac#%"
fn g1int_eucliddiv_`'INT : $d2ctype (g1int_eucliddiv<intb2k(INT)>) = "mac#%"
fn g0int_euclidrem_`'INT : $d2ctype (g0int_euclidrem<intb2k(INT)>) = "mac#%"
fn g1int_euclidrem_`'INT : $d2ctype (g1int_euclidrem<intb2k(INT)>) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* min and max. *)

m4_foreachq(`INT',`intbases',
`fn g0int_min_`'INT : m4_g0int_binary(INT) = "mac#%"
fn g1int_min_`'INT : {i, j : int} m4_g1int_binary(INT, i, j, i \min j) = "mac#%"
fn g0int_max_`'INT : m4_g0int_binary(INT) = "mac#%"
fn g1int_max_`'INT : {i, j : int} m4_g1int_binary(INT, i, j, i \max j) = "mac#%"

')dnl
m4_foreachq(`UINT',`uintbases',
`fn g0uint_min_`'UINT : m4_g0uint_binary(UINT) = "mac#%"
fn g1uint_min_`'UINT : {i, j : int} m4_g1uint_binary(UINT, i, j, i \min j) = "mac#%"
fn g0uint_max_`'UINT : m4_g0uint_binary(UINT) = "mac#%"
fn g1uint_max_`'UINT : {i, j : int} m4_g1uint_binary(UINT, i, j, i \max j) = "mac#%"

')dnl
(*------------------------------------------------------------------*)
(* ‘Counting trailing zeros’ of a positive number. *)

fn {tk : tkind} g0int_ctz : m4_g0int_to_int(tk)
fn {tk : tkind} g1int_ctz : {i : pos} m4_g1int_to_int(tk, i, ctz_int i)

fn {tk : tkind} g0uint_ctz : m4_g0uint_to_int(tk)
fn {tk : tkind} g1uint_ctz : {i : pos} m4_g1uint_to_int(tk, i, ctz_int i)

m4_foreachq(`INT',`intbases',
`fn g0int_ctz_`'INT : m4_g0int_to_int(INT) = "mac#%"
fn g1int_ctz_`'INT : {i : pos} m4_g1int_to_int(INT, i, ctz_int i) = "mac#%"

')dnl
m4_foreachq(`UINT',`uintbases',
`fn g0uint_ctz_`'UINT : m4_g0uint_to_int(UINT) = "mac#%"
fn g1uint_ctz_`'UINT : {i : pos} m4_g1uint_to_int(UINT, i, ctz_int i) = "mac#%"

')dnl
overload ctz with g0int_ctz of 0
overload ctz with g1int_ctz of 1
overload ctz with g0uint_ctz of 0
overload ctz with g1uint_ctz of 1

(*------------------------------------------------------------------*)
(* ‘Find first set’ and ‘find last set’ of a non-negative number. *)

fn {tk : tkind} g0int_ffs : m4_g0int_to_int(tk)
fn {tk : tkind} g1int_ffs : {i : nat} m4_g1int_to_int(tk, i, ffs_int i)

fn {tk : tkind} g0uint_ffs : m4_g0uint_to_int(tk)
fn {tk : tkind} g1uint_ffs : {i : nat} m4_g1uint_to_int(tk, i, ffs_int i)

fn {tk : tkind} g0int_fls : m4_g0int_to_int(tk)
fn {tk : tkind} g1int_fls : {i : nat} m4_g1int_to_int(tk, i, fls_int i)

fn {tk : tkind} g0uint_fls : m4_g0uint_to_int(tk)
fn {tk : tkind} g1uint_fls : {i : nat} m4_g1uint_to_int(tk, i, fls_int i)

m4_foreachq(`INT',`intbases',
`fn g0int_ffs_`'INT : m4_g0int_to_int(INT) = "mac#%"
fn g1int_ffs_`'INT : {i : nat} m4_g1int_to_int(INT, i, ffs_int i) = "mac#%"
fn g0int_fls_`'INT : m4_g0int_to_int(INT) = "mac#%"
fn g1int_fls_`'INT : {i : nat} m4_g1int_to_int(INT, i, fls_int i) = "mac#%"

')dnl
m4_foreachq(`UINT',`uintbases',
`fn g0uint_ffs_`'UINT : m4_g0uint_to_int(UINT) = "mac#%"
fn g1uint_ffs_`'UINT : {i : nat} m4_g1uint_to_int(UINT, i, ffs_int i) = "mac#%"
fn g0uint_fls_`'UINT : m4_g0uint_to_int(UINT) = "mac#%"
fn g1uint_fls_`'UINT : {i : nat} m4_g1uint_to_int(UINT, i, fls_int i) = "mac#%"

')dnl
overload ffs with g0int_ffs of 0
overload ffs with g1int_ffs of 1
overload ffs with g0uint_ffs of 0
overload ffs with g1uint_ffs of 1

overload fls with g0int_fls of 0
overload fls with g1int_fls of 1
overload fls with g0uint_fls of 0
overload fls with g1uint_fls of 1

(*------------------------------------------------------------------*)
(* Population count of a non-negative number. *)

fn {tk : tkind} g0int_popcount : m4_g0int_to_int(tk)
fn {tk : tkind} g1int_popcount : {i : nat} m4_g1int_to_int(tk, i, popcount_int i)

fn {tk : tkind} g0uint_popcount : m4_g0uint_to_int(tk)
fn {tk : tkind} g1uint_popcount : {i : nat} m4_g1uint_to_int(tk, i, popcount_int i)

m4_foreachq(`INT',`intbases',
`fn g0int_popcount_`'INT : m4_g0int_to_int(INT) = "mac#%"
fn g1int_popcount_`'INT : {i : nat} m4_g1int_to_int(INT, i, popcount_int i) = "mac#%"

')dnl
m4_foreachq(`UINT',`uintbases',
`fn g0uint_popcount_`'UINT : m4_g0uint_to_int(UINT) = "mac#%"
fn g1uint_popcount_`'UINT : {i : nat} m4_g1uint_to_int(UINT, i, popcount_int i) = "mac#%"

')dnl
overload popcount with g0int_popcount of 0
overload popcount with g1int_popcount of 1
overload popcount with g0uint_popcount of 0
overload popcount with g1uint_popcount of 1

(*------------------------------------------------------------------*)
(* Greatest common divisor, with gcd(0,0) = 0. *)

fn {tk : tkind}
g0int_gcd :
  m4_g0int_binary(tk)

fn {tk : tkind}
g1int_gcd :
  {i, j : int}
  m4_g1int_binary(tk, i, j, gcd_int_int (i, j))

fn {tk : tkind}
g0uint_gcd :
  m4_g0uint_binary(tk)

fn {tk : tkind}
g1uint_gcd :
  {i, j : int}
  m4_g1uint_binary(tk, i, j, gcd_int_int (i, j))

m4_foreachq(`INT',`intbases',
`fn g0int_gcd_`'INT : $d2ctype (g0int_gcd<intb2k(INT)>)
fn g1int_gcd_`'INT : $d2ctype (g1int_gcd<intb2k(INT)>)

')dnl
m4_foreachq(`UINT',`uintbases',
`fn g0uint_gcd_`'UINT : $d2ctype (g0uint_gcd<uintb2k(UINT)>)
fn g1uint_gcd_`'UINT : $d2ctype (g1uint_gcd<uintb2k(UINT)>)

')dnl
(*------------------------------------------------------------------*)
(* Logical shifts. *)

(* I have added the g1 versions. Also I have made the shifts safe
   against the second argument being large: they return zero. C
   standards leave the behavior implementation-defined. *)

fn {tk : tkind}
g1uint_lsl :
  {i, j : int | 0 <= j}
  m4_g1uint_logical_shift(tk, i, j, i \lsl_int_int j)

fn {tk : tkind}
g1uint_lsr :
  {i, j : int | 0 <= j}
  m4_g1uint_logical_shift(tk, i, j, i \lsr_int_int j)

(* These overloads have precedences one greater than the precedences
   of g0uint_lsl and g0uint_lsr. *)
overload << with g1uint_lsl of 11
overload >> with g1uint_lsr of 11

m4_foreachq(`UINT',`uintbases',
`
fn g0uint_lsl_`'UINT : m4_g0uint_logical_shift(UINT) = "mac#%"
fn g1uint_lsl_`'UINT : {i, j : int | 0 <= j} m4_g1uint_logical_shift(UINT, i, j, i \lsl_int_int j) = "mac#%"
fn g0uint_lsr_`'UINT : m4_g0uint_logical_shift(UINT) = "mac#%"
fn g1uint_lsr_`'UINT : {i, j : int | 0 <= j} m4_g1uint_logical_shift(UINT, i, j, i \lsr_int_int j) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Arithmetic shifts. *)

(* I have added the g1 versions.

   The signed << and >> operators of C are not required to do
   arithmetic shifting, and >> may in fact zero-fill rather than
   one-fill.
   
   Thus we do not use the signed << and >> operators.
   
   Our implementation also is compiler dependent: we use an unsafe
   union to convert between signed and unsigned
   representations. However, we use the unsigned << and >> operators,
   which have well defined behavior. *)

fn {tk : tkind}
g1int_asl :
  {i, j : int | 0 <= j}
  m4_g1int_arith_shift(tk, i, j, i \asl_int_int j)

fn {tk : tkind}
g1int_asr :
  {i, j : int | 0 <= j}
  m4_g1int_arith_shift(tk, i, j, i \asr_int_int j)

(* These overloads have precedences one greater than the precedences
   of g0int_asl and g0int_asr. *)
overload << with g1int_asl of 1
overload >> with g1int_asr of 1

m4_foreachq(`INT',`intbases',
`
fn g0int_asl_`'INT : m4_g0int_arith_shift(INT) = "mac#%"
fn g1int_asl_`'INT : {i, j : int | 0 <= j} m4_g1int_arith_shift(INT, i, j, i \asl_int_int j) = "mac#%"
fn g0int_asr_`'INT : m4_g0int_arith_shift(INT) = "mac#%"
fn g1int_asr_`'INT : {i, j : int | 0 <= j} m4_g1int_arith_shift(INT, i, j, i \asr_int_int j) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Bitwise logical expressions. *)

(* We implement these for both unsigned and signed representations.

   We also add g1 versions.

   Our reasoning for supporting signed integers is: one might as well
   have bitwise logical operations on signed integers, if one is going
   to have 8086-style arithmetic shifts. *)

fn {tk : tkind}
g0int_lnot :
  m4_g0int_unary(tk)

fn {tk : tkind}
g1int_lnot :
  {i : int}
  m4_g1int_unary(tk, i, signed_lnot_int i)

fn {tk : tkind}
g1uint_lnot :
  {i : int}
  m4_g1uint_unary(tk, i, lnot_int i)

m4_foreachq(`OP',`land,lor,lxor',
`
fn {tk : tkind}
g0int_`'OP :
  m4_g0int_binary(tk)

fn {tk : tkind}
g1int_`'OP :
  {i, j : int}
  m4_g1int_binary(tk, i, j, i \signed_`'OP`'_int_int j)

fn {tk : tkind}
g1uint_`'OP :
  {i, j : int}
  m4_g1uint_binary(tk, i, j, i \OP`'_int_int j)
')dnl

(* The g1 overloads have precedences one greater than the precedences
   of their g0 counterparts. The g0uint overloads are set in the
   prelude. *)
overload ~ with g1uint_lnot of 1
m4_foreachq(`OP',`lnot,land,lor,lxor',
`overload OP with g0int_`'OP of 0
overload OP with g1int_`'OP of 1
overload OP with g1uint_`'OP of 1
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`
m4_foreachq(`OP',`lnot,land,lor,lxor',
`fn g`'N`'int_`'OP`'_`'INT : $d2ctype (g`'N`'int_`'OP<intb2k(INT)>) = "mac#%"
')dnl
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`
m4_foreachq(`OP',`lnot,land,lor,lxor',
`fn g`'N`'uint_`'OP`'_`'UINT : $d2ctype (g`'N`'uint_`'OP<uintb2k(UINT)>) = "mac#%"
')dnl
')
')dnl

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

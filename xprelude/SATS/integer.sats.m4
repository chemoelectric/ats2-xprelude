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
#define ATS_EXTERN_PREFIX "ats2_xprelude_"

(******************************************************************
  Some integer support that is not included in the Postiats
  prelude.
*******************************************************************)

%{#
#include "xprelude/CATS/integer.cats"
%}

(*------------------------------------------------------------------*)
(* intmax_t and uintmax_t. *)

tkindef intmax_kind = "ats2_xprelude_intmax"
stadef intmaxknd = intmax_kind
typedef intmax0 = g0int intmaxknd
typedef intmax1 (i : int) = g1int (intmaxknd, i)
stadef intmax = intmax1 // 2nd-select
stadef intmax = intmax0 // 1st-select
stadef Intmax = [i : int] intmax1 i

tkindef uintmax_kind = "ats2_xprelude_uintmax"
stadef uintmaxknd = uintmax_kind
typedef uintmax0 = g0uint uintmaxknd
typedef uintmax1 (i : int) = g1uint (uintmaxknd, i)
stadef uintmax = uintmax1 // 2nd-select
stadef uintmax = uintmax0 // 1st-select
stadef uIntmax = [i : nat] uintmax1 i

(*------------------------------------------------------------------*)

(*
  
  Functions below that *are* already in the prelude might harmlessly
  be shadowed.

*)

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
(* Negation. *)

m4_foreachq(`INT',`intbases',
`
fn `g0int_neg_'INT : m4_g0int_unary(INT) = "mac#%"
fn `g1int_neg_'INT : {i : int} m4_g1int_unary(INT, i, ~i) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Absolute value. *)

m4_foreachq(`INT',`intbases',
`
fn `g0int_abs_'INT : m4_g0int_unary(INT) = "mac#%"
fn `g1int_abs_'INT : {i : int} m4_g1int_unary(INT, i, abs i) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Successor and predecessor. *)

m4_foreachq(`INT',`intbases',
`
fn `g0int_succ_'INT : m4_g0int_unary(INT) = "mac#%"
fn `g1int_succ_'INT : {i : int} m4_g1int_unary(INT, i, i + 1) = "mac#%"
fn `g0int_pred_'INT : m4_g0int_unary(INT) = "mac#%"
fn `g1int_pred_'INT : {i : int} m4_g1int_unary(INT, i, i - 1) = "mac#%"
')dnl

m4_foreachq(`UINT',`uintbases',
`
fn `g0uint_succ_'UINT : m4_g0uint(UINT) -<> m4_g0uint(UINT) = "mac#%"
fn `g1uint_succ_'UINT : {i : int} m4_g1uint_unary(UINT, i, i + 1) = "mac#%"
fn `g0uint_pred_'UINT : m4_g0uint(UINT) -<> m4_g0uint(UINT) = "mac#%"
fn `g1uint_pred_'UINT : {i : pos} m4_g1uint_unary(UINT, i, i - 1) = "mac#%"
')dnl

(*------------------------------------------------------------------*)
(* Integer halving (ignoring remainder). *)

m4_foreachq(`INT',`intbases',
`
fn `g0int_half_'INT : m4_g0int_unary(INT) = "mac#%"
fn `g1int_half_'INT : {i : int} m4_g1int_unary(INT, i, i / 2) = "mac#%"
')dnl

m4_foreachq(`UINT',`uintbases',
`
fn `g0uint_half_'UINT : m4_g0uint_unary(UINT) = "mac#%"
fn `g1uint_half_'UINT : {i : int} m4_g1uint_unary(UINT, i, i / 2) = "mac#%"
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
dnl
dnl local variables:
dnl mode: ATS
dnl end:

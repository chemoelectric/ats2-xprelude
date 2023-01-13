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

#define ATS_DYNLOADFLAG 0

#define ATS_PACKNAME "ats2-xprelude.integer"
#define ATS_EXTERN_PREFIX "ats2_xprelude_"

#include "share/atspre_staload.hats"

staload UN = "prelude/SATS/unsafe.sats"
staload "xprelude/SATS/integer.sats"

(*------------------------------------------------------------------*)
(* Printing. *)

m4_foreachq(`INT',`intbases',
`implement fprint_val<m4_g0int(INT)> (outf, i) = fprint_`'INT (outf, i)
')dnl

m4_foreachq(`UINT',`uintbases',
`implement fprint_val<m4_g0uint(UINT)> (outf, i) = fprint_`'UINT (outf, i)
')dnl

(*------------------------------------------------------------------*)
(* Conversion to a string. *)

m4_foreachq(`INT',`intbases',
`
implement {}
tostrptr_`'INT i =
  let
    #define BUFSZ 160         (* Large enough for a 512-bit number. *)
    var buf = @[char][BUFSZ] (m4_singlequote`\0'm4_singlequote)
    val _ = $extfcall (int, "snprintf", addr@ buf, BUFSZ - 1,
                       "%jd", g0int2int<intb2k(INT),intmaxknd> i)
  in
    string0_copy ($UN.cast{string} buf)
  end

implement {}
tostring_`'INT i =
  $effmask_wrt strptr2string (tostrptr_`'INT i)

implement tostrptr_val<m4_g0int(INT)> = tostrptr_`'INT
implement tostring_val<m4_g0int(INT)> = tostring_`'INT
')dnl

m4_foreachq(`UINT',`uintbases',
`
implement {}
tostrptr_`'UINT i =
  let
    #define BUFSZ 160         (* Large enough for a 512-bit number. *)
    var buf = @[char][BUFSZ] (m4_singlequote`\0'm4_singlequote)
    val _ = $extfcall (uint, "snprintf", addr@ buf, BUFSZ - 1,
                       "%ju", g0uint2uint<uintb2k(UINT),uintmaxknd> i)
  in
    string0_copy ($UN.cast{string} buf)
  end

implement {}
tostring_`'UINT i =
  $effmask_wrt strptr2string (tostrptr_`'UINT i)

implement tostrptr_val<m4_g0uint(UINT)> = tostrptr_`'UINT
implement tostring_val<m4_g0uint(UINT)> = tostring_`'UINT
')dnl

(*------------------------------------------------------------------*)
(* Type conversions. *)

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT1',`intbases',
`m4_foreachq(`INT2',`intbases',
`implement g`'N`'int2int<intb2k(INT1),intb2k(INT2)> = g`'N`'int2int_`'INT1`_'INT2
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT1',`intbases',
`m4_foreachq(`UINT2',`uintbases',
`implement g`'N`'int2uint<intb2k(INT1),uintb2k(UINT2)> = g`'N`'int2uint_`'INT1`_'UINT2
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT1',`uintbases',
`m4_foreachq(`INT2',`intbases',
`implement g`'N`'uint2int<uintb2k(UINT1),intb2k(INT2)> = g`'N`'uint2int_`'UINT1`_'INT2
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT1',`uintbases',
`m4_foreachq(`UINT2',`uintbases',
`implement g`'N`'uint2uint<uintb2k(UINT1),uintb2k(UINT2)> = g`'N`'uint2uint_`'UINT1`_'UINT2
')
')
')dnl

(*------------------------------------------------------------------*)
(* Comparisons. *)

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`m4_foreachq(`OP',`comparisons',
`implement g`'N`int_'OP<intb2k(INT)> = g`'N`int_'OP`_'INT
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`m4_foreachq(`OP',`comparisons',
`implement g`'N`uint_'OP<uintb2k(UINT)> = g`'N`uint_'OP`_'UINT
')
')
')dnl

(*------------------------------------------------------------------*)
(* Comparisons with zero. *)

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`m4_foreachq(`OP',`comparisons',
`implement g`'N`int_is'OP`z'<intb2k(INT)> = g`'N`int_is'OP`z_'INT
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`m4_foreachq(`OP',`gt,eq,neq',
`implement g`'N`uint_is'OP`z'<uintb2k(UINT)> = g`'N`uint_is'OP`z_'UINT
')
')
')dnl

(*------------------------------------------------------------------*)
(* ‘qsort-style’ comparison. *)

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`implement g`'N`'int_compare<intb2k(INT)> = g`'N`'int_compare_`'INT
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`implement g`'N`'uint_compare<uintb2k(UINT)> = g`'N`'uint_compare_`'UINT
')
')dnl

(*------------------------------------------------------------------*)
(* Negation. *)

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`implement g`'N`int_neg'<intb2k(INT)> = g`'N`int_neg_'INT
')
')dnl

(*------------------------------------------------------------------*)
(* Absolute value. *)

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`implement g`'N`int_abs'<intb2k(INT)> = g`'N`int_abs_'INT
')
')dnl

(*------------------------------------------------------------------*)
(* Successor and predecessor. *)

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`implement g`'N`int_succ'<intb2k(INT)> = g`'N`int_succ_'INT
implement g`'N`int_pred'<intb2k(INT)> = g`'N`int_pred_'INT
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`implement g`'N`uint_succ'<uintb2k(UINT)> = g`'N`uint_succ_'UINT
implement g`'N`uint_pred'<uintb2k(UINT)> = g`'N`uint_pred_'UINT
')
')dnl

(*------------------------------------------------------------------*)
(* Integer halving (ignoring remainder). *)

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`implement g`'N`int_half'<intb2k(INT)> = g`'N`int_half_'INT
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`implement g`'N`uint_half'<uintb2k(UINT)> = g`'N`uint_half_'UINT
')
')dnl

(*------------------------------------------------------------------*)
(* Binary operations. *)

m4_foreachq(`BINOP',`add,sub,mul,div,mod,min,max',
`
m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`m4_if(BINOP`'N,`mod1',`',dnl  /* Skip g1int_mod */
`implement g`'N`'int_`'BINOP<intb2k(INT)> = g`'N`'int_`'BINOP`'_`'INT')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`implement g`'N`'uint_`'BINOP<uintb2k(UINT)> = g`'N`'uint_`'BINOP`'_`'UINT
')
')dnl
')dnl

m4_foreachq(`INT',`intbases',
`implement g1int_nmod<intb2k(INT)> = g1int_nmod_`'INT
')dnl

implement {tk}
nmod_g1int_int1 (x, y) =
  g1i2i (g1int_nmod (x, g1i2i y))

(*------------------------------------------------------------------*)
(* Euclidean division with remainder always positive. *)

implement {tk : tkind}
g0int_eucliddivrem (n, d) =
  let
    val q0 = g0int_div (n, d)
    val r0 = g0int_mod (n, d)
  in
    if isgtez n then
      @(q0, r0)
    else if iseqz r0 then
      @(q0, r0)
    else if isltz d then
      @(succ q0, r0 - d)
    else
      @(pred q0, r0 + d)
  end

implement {tk : tkind}
g1int_eucliddivrem (n, d) =
  $UN.cast (g0int_eucliddivrem (g0ofg1 n, g0ofg1 d))

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`implement g`'N`'int_eucliddiv<intb2k(INT)> = g`'N`'int_eucliddiv_`'INT
implement g`'N`'int_euclidrem<intb2k(INT)> = g`'N`'int_euclidrem_`'INT
')
')dnl

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

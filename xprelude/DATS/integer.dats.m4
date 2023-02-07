`(*
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
*)'
include(`common-macros.m4')m4_include(`ats2-xprelude-macros.m4')

#define ATS_DYNLOADFLAG 0

#define ATS_PACKNAME "ats2-xprelude.integer"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"

staload UN = "prelude/SATS/unsafe.sats"
staload "xprelude/SATS/integer.sats"

staload "xprelude/SATS/arith_prf.sats"

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

m4_foreachq(`INT',`intbases',
`implement gequal_val_val<m4_g0int(INT)> = g0int_eq<intb2k(INT)>
')dnl

m4_foreachq(`UINT',`uintbases',
`implement gequal_val_val<m4_g0uint(UINT)> = g0uint_eq<intb2k(UINT)>
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

m4_foreachq(`INT',`intbases',
`implement gcompare_val_val<m4_g0int(INT)> = g0int_compare<intb2k(INT)>
')dnl

m4_foreachq(`UINT',`uintbases',
`implement gcompare_val_val<m4_g0uint(UINT)> = g0uint_compare<intb2k(UINT)>
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
    (* The C optimizer most likely will reduce these these two
       divisions to just one. *)
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
(* Raising an integer to a non-negative integer power. *)

implement {tk1} {tk2}
g0int_ipow_guint (b, i) =
  $effmask_wrt
  let
    val i = g1ofg0 i
    prval [i : int] EQINT () = eqint_make_guint i

    val last_set = fls i
    prval [last_set : int] EQINT () = eqint_make_gint last_set
    prval () = lemma_fls_isnat {i} ()

    var j : intGte 0
    var power : g0int tk1 = g0i2i 1
    var base : g0int tk1 = b
    var exponent : g0uint tk2 = i
  in
    for* {j : nat | j <= last_set}
         .<last_set - j>.
         (j : int j) =>
      (j := 0; j <> last_set; j := succ j)
        let
          val exponent_halved = half exponent
        in
          if exponent_halved + exponent_halved <> exponent then
            power := power * base;
          exponent := exponent_halved;
          base := base * base
        end;
    power
  end

implement {tk1} {tk2}
g0int_ipow_gint (b, i) =
  $effmask_wrt
  let
    prval [i : int] EQINT () = eqint_make_gint i
    prval () = prop_verify {0 <= i} ()

    val last_set = fls i
    prval [last_set : int] EQINT () = eqint_make_gint last_set
    prval () = lemma_fls_isnat {i} ()

    var j : intGte 0
    var power : g0int tk1 = g0i2i 1
    var base : g0int tk1 = b
    var exponent : [expnt : nat] g1int (tk2, expnt) = i
  in
    for* {j : nat | j <= last_set}
         .<last_set - j>.
         (j : int j) =>
      (j := 0; j <> last_set; j := succ j)
        let
          val exponent_halved = half exponent
        in
          if exponent_halved + exponent_halved <> exponent then
            power := power * base;
          exponent := exponent_halved;
          base := base * base
        end;
    power
  end

implement {tk1} {tk2}
g0uint_ipow_guint (b, i) =
  $effmask_wrt
  let
    val i = g1ofg0 i
    prval [i : int] EQINT () = eqint_make_guint i

    val last_set = fls i
    prval [last_set : int] EQINT () = eqint_make_gint last_set
    prval () = lemma_fls_isnat {i} ()

    var j : intGte 0
    var power : g0uint tk1 = g0i2u 1
    var base : g0uint tk1 = b
    var exponent : g0uint tk2 = i
  in
    for* {j : nat | j <= last_set}
         .<last_set - j>.
         (j : int j) =>
      (j := 0; j <> last_set; j := succ j)
        let
          val exponent_halved = half exponent
        in
          if exponent_halved + exponent_halved <> exponent then
            power := power * base;
          exponent := exponent_halved;
          base := base * base
        end;
    power
  end

implement {tk1} {tk2}
g0uint_ipow_gint (b, i) =
  $effmask_wrt
  let
    prval [i : int] EQINT () = eqint_make_gint i
    prval () = prop_verify {0 <= i} ()

    val last_set = fls i
    prval [last_set : int] EQINT () = eqint_make_gint last_set
    prval () = lemma_fls_isnat {i} ()

    var j : intGte 0
    var power : g0uint tk1 = g0i2u 1
    var base : g0uint tk1 = b
    var exponent : [expnt : nat] g1int (tk2, expnt) = i
  in
    for* {j : nat | j <= last_set}
         .<last_set - j>.
         (j : int j) =>
      (j := 0; j <> last_set; j := succ j)
        let
          val exponent_halved = half exponent
        in
          if exponent_halved + exponent_halved <> exponent then
            power := power * base;
          exponent := exponent_halved;
          base := base * base
        end;
    power
  end

m4_foreachq(`INT1',`conventional_intbases',
`m4_foreachq(`UINT2',`conventional_uintbases',
`implement g0int_ipow_guint<intb2k(INT1)><uintb2k(UINT2)> = g0int_ipow_`'INT1`'_`'UINT2
')')

m4_foreachq(`INT1',`conventional_intbases',
`m4_foreachq(`INT2',`conventional_intbases',
`implement g0int_ipow_gint<intb2k(INT1)><intb2k(INT2)> = g0int_ipow_`'INT1`'_`'INT2
')')

m4_foreachq(`UINT1',`conventional_uintbases',
`m4_foreachq(`UINT2',`conventional_uintbases',
`implement g0uint_ipow_guint<intb2k(UINT1)><uintb2k(UINT2)> = g0uint_ipow_`'UINT1`'_`'UINT2
')')

m4_foreachq(`UINT1',`conventional_uintbases',
`m4_foreachq(`INT2',`conventional_intbases',
`implement g0uint_ipow_gint<intb2k(UINT1)><intb2k(INT2)> = g0uint_ipow_`'UINT1`'_`'INT2
')')

(* We can now re-implement g0int_npow in terms of g0int_ipow_gint,
   and so get the precompiled implementations.
   //
   //
   WARNING: YOU MIGHT GET RESULTS DIFFERENT FROM WHAT THE PRELUDE’S
   IMPLEMENTATION WOULD GIVE YOU. But the differences should occur
   only in cases of signed-integer overflow.
   //
   // *)
implement {tk} g0int_npow = g0int_ipow_gint<tk><intknd>

(*------------------------------------------------------------------*)
(* Some of the more obscure bitwise operations. *)

m4_define(`obscure_bitwise_operations',`ctz, ffs, fls, popcount')

m4_foreachq(`OP',`obscure_bitwise_operations',
`m4_foreachq(`INT',`intbases',
`implement g0int_`'OP<intb2k(INT)> = g0int_`'OP`'_`'INT
implement g1int_`'OP<intb2k(INT)> = g1int_`'OP`'_`'INT
')dnl
')dnl

m4_foreachq(`OP',`obscure_bitwise_operations',
`m4_foreachq(`UINT',`uintbases',
`implement g0uint_`'OP<uintb2k(UINT)> = g0uint_`'OP`'_`'UINT
implement g1uint_`'OP<uintb2k(UINT)> = g1uint_`'OP`'_`'UINT
')dnl
')dnl

(*------------------------------------------------------------------*)
(* Logical shifts. *)

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`implement g`'N`'uint_lsl<uintb2k(UINT)> = g`'N`'uint_lsl_`'UINT
implement g`'N`'uint_lsr<uintb2k(UINT)> = g`'N`'uint_lsr_`'UINT
')
')dnl

(*------------------------------------------------------------------*)
(* Arithmetic shifts. *)

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`implement g`'N`'int_asl<intb2k(INT)> = g`'N`'int_asl_`'INT
implement g`'N`'int_asr<intb2k(INT)> = g`'N`'int_asr_`'INT
')
')dnl

(*------------------------------------------------------------------*)
(* Bitwise logical expressions. *)

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`m4_foreachq(`OP',`lnot,land,lor,lxor',
`implement g`'N`'int_`'OP<intb2k(INT)> = g`'N`'int_`'OP`'_`'INT
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`m4_foreachq(`OP',`lnot,land,lor,lxor',
`implement g`'N`'uint_`'OP<uintb2k(UINT)> = g`'N`'uint_`'OP`'_`'UINT
')
')
')dnl

(*------------------------------------------------------------------*)
(* Greatest common divisor. *)

m4_foreachq(`U',``',`u'',
`fn {tk : tkind}
_g0`'U`'int_gcd
          (u : g0`'U`'int tk,
           v : g0`'U`'int tk)
    :<> g0`'U`'int tk =
  (* Stein’s algorithm. This is an implementation Barry Schwartz
     originally wrote for Rosetta Code. *)
  let
    typedef t = g0`'U`'int tk

    (* Use this macro to fake proof that an int is non-negative. *)
    macdef nonneg (n) = $UNSAFE.cast{intGte 0} ,(n)

    fun
    loop (x_odd : t,
          y     : t)
        :<!ntm> t =
      let
        (* Remove twos from y, giving an odd number.
           Note gcd(x_odd,y_odd) = gcd(x_odd,y). *)
        val y_odd = (y >> nonneg (ctz y))
      in
        if x_odd = y_odd then
          x_odd
        else
          let
            (* If y_odd < x_odd then swap x_odd and y_odd.
               This operation does not affect the gcd. *)
            val x_odd = min (x_odd, y_odd)
            and y_odd = max (x_odd, y_odd)
          in
            loop (x_odd, y_odd - x_odd)
          end
      end

    fn {}
    compute_gcd (u : t,
                 v : t)
        :<> t =
      let
        (* n = the number of common factors of two in u and v. *)
        val n = ctz (u lor v)

        (* Remove the common twos from u and v, giving x and y. *)
        val x = (u >> nonneg n)
        val y = (v >> nonneg n)

        (* Remove twos from x, giving an odd number.
           Note gcd(x_odd,y) = gcd(x,y). *)
        val x_odd = (x >> nonneg (ctz x))

        (* Run the main loop. *)
        val z = $effmask_ntm (loop (x_odd, y))
      in
        (* Put the common factors of two back in. *)
        (z << nonneg n)
      end

    (* If v < u then swap u and v. This operation does not
       affect the gcd. *)
    val u = min (u, v)
    and v = max (u, v)
  in
    if iseqz u then
      v
    else
      compute_gcd<> (u, v)
  end

')dnl
implement {tk}
g0uint_gcd (i, j) =
  _g0uint_gcd<tk> (i, j)

implement {tk}
g1uint_gcd (i, j) =
  $UN.cast (g0uint_gcd<tk> (i, j))

implement {tk}
g0int_gcd (i, j) =
  _g0int_gcd<tk> (abs i, abs j)

implement {tk}
g1int_gcd (i, j) =
  $UN.cast (g0int_gcd<tk> (i, j))

if_COMPILING_IMPLEMENTATIONS(
`m4_foreachq(`INT',`intbases',
`implement g1int_gcd_`'INT (i, j) = g1int_gcd<intb2k(INT)> (i, j)
implement g0int_gcd_`'INT (i, j) = g0ofg1 (g1int_gcd_`'INT (g1ofg0 i, g1ofg0 j))
')dnl
')dnl

if_COMPILING_IMPLEMENTATIONS(
`m4_foreachq(`UINT',`uintbases',
`implement g1uint_gcd_`'UINT (i, j) = g1uint_gcd<uintb2k(UINT)> (i, j)
implement g0uint_gcd_`'UINT (i, j) = g0ofg1 (g1uint_gcd_`'UINT (g1ofg0 i, g1ofg0 j))
')dnl
')dnl

if_not_COMPILING_IMPLEMENTATIONS(
`m4_foreachq(`INT',`intbases',
`implement g0int_gcd<intb2k(INT)> = g0int_gcd_`'INT
implement g1int_gcd<intb2k(INT)> = g1int_gcd_`'INT
')dnl
')dnl

if_not_COMPILING_IMPLEMENTATIONS(
`m4_foreachq(`UINT',`uintbases',
`implement g0uint_gcd<uintb2k(UINT)> = g0uint_gcd_`'UINT
implement g1uint_gcd<uintb2k(UINT)> = g1uint_gcd_`'UINT
')dnl
')dnl

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

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

#define ATS_PACKNAME "ats2-xprelude.float"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"

staload UN = "prelude/SATS/unsafe.sats"

staload "xprelude/SATS/integer.sats"
staload _ = "xprelude/DATS/integer.dats"

staload "xprelude/SATS/float.sats"

(*------------------------------------------------------------------*)
(* Printing. *)

(* Putting printing in a template, rather than in C code, makes it
   possible to build programs even if some of the ‘strfromXXX’
   functions are missing from the C libraries. *)

m4_foreachq(`FLT1',`extended_floattypes',
`implement {}
fprint_`'FLT1 (out, x) =
  let
    #define BUFSZ 128
    var buf = @[char][BUFSZ] (m4_singlequote`\0'm4_singlequote)
    val _ = $extfcall (int, "strfrom`'floatt2sfx(FLT1)",
                       addr@ buf, BUFSZ - 1, "%.6f", x)
    val _ = $extfcall (int, "fprintf", out, "%s", addr@ buf)
  in
  end

implement {} print_`'FLT1 x = fprint_`'FLT1 (stdout_ref, x)
implement {} prerr_`'FLT1 x = fprint_`'FLT1 (stderr_ref, x)

')dnl
(*------------------------------------------------------------------*)
(* Conversion to a string. *)

(* Putting conversion to a string in a template, rather than in C
   code, makes it possible to build programs even if some of the
   ‘strfromXXX’ functions are missing from the C libraries. *)

implement {}
tostrptr_float x =
  let
    #define BUFSZ 128
    var buf = @[char][BUFSZ] (m4_singlequote`\0'm4_singlequote)
    val _ = $extfcall (int, "snprintf", addr@ buf, BUFSZ - 1, "%.6f",
                       g0float2float<float_kind,double_kind> x)
  in
    string0_copy ($UN.cast{string} buf)
  end

implement {}
tostrptr_double x =
  let
    #define BUFSZ 128
    var buf = @[char][BUFSZ] (m4_singlequote`\0'm4_singlequote)
    val _ = $extfcall (int, "snprintf", addr@ buf, BUFSZ - 1,
                       "%.6f", x)
  in
    string0_copy ($UN.cast{string} buf)
  end

implement {}
tostrptr_ldouble x =
  let
    #define BUFSZ 128
    var buf = @[char][BUFSZ] (m4_singlequote`\0'm4_singlequote)
    val _ = $extfcall (int, "snprintf", addr@ buf, BUFSZ - 1,
                       "%.6Lf", x)
  in
    string0_copy ($UN.cast{string} buf)
  end

m4_foreachq(`FLT1',`extended_floattypes',
`implement {}
tostrptr_`'FLT1 x =
  let
    #define BUFSZ 128
    var buf = @[char][BUFSZ] (m4_singlequote`\0'm4_singlequote)
    val _ = $extfcall (int, "strfrom`'floatt2sfx(FLT1)",
                       addr@ buf, BUFSZ - 1, "%.6f", x)
  in
    string0_copy ($UN.cast{string} buf)
  end

implement {}
tostring_`'FLT1 i =
  $effmask_wrt strptr2string (tostrptr_`'FLT1 i)

implement tostrptr_val<FLT1> = tostrptr_`'FLT1
implement tostring_val<FLT1> = tostring_`'FLT1

')dnl

(*------------------------------------------------------------------*)
(* Type conversions. *)

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0int2float<intb2k(INT),floatt2k(FLT1)> = g0int2float_`'INT`_'FLT1
')
')dnl

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float2int<floatt2k(FLT1),intb2k(INT)> = g0float2int_`'FLT1`_'INT
')
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`FLT2',`conventional_floattypes',
`implement g0float2float<floatt2k(FLT1),floatt2k(FLT2)> = g0float2float_`'FLT1`_'FLT2
')dnl
')dnl

(*------------------------------------------------------------------*)
(* Epsilons. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_epsilon<floatt2k(FLT1)> = g0float_epsilon_`'FLT1
')dnl

(*------------------------------------------------------------------*)
(* Sign and absolute value. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_sgn<floatt2k(FLT1)> = g0float_sgn_`'FLT1
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_abs<floatt2k(FLT1)> = g0float_abs_`'FLT1
')dnl

(*------------------------------------------------------------------*)
(* Library functions. *)

m4_foreachq(`UOP',`unary_ops',
`m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_`'UOP`'<floatt2k(FLT1)> = g0float_`'UOP`'_`'FLT1
')dnl
')dnl

m4_foreachq(`AOP',`binary_ops',
`m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_`'AOP`'<floatt2k(FLT1)> = g0float_`'AOP`'_`'FLT1
')dnl
')dnl

m4_foreachq(`TOP',`trinary_ops',
`m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_`'TOP`'<floatt2k(FLT1)> = g0float_`'TOP`'_`'FLT1
')dnl
')dnl

(*------------------------------------------------------------------*)
(* Comparisons. *)

m4_foreachq(`OP',`comparisons',
`implement {tk} g0float_is`'OP`'z x = g0float_`'OP<tk> (x, g0i2f 0)
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`OP',`comparisons',
`implement g0float_`'OP<floatt2k(FLT1)> = g0float_`'OP`'_`'FLT1
')
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`OP',`comparisons',
`implement g0float_is`'OP`'z<floatt2k(FLT1)> = g0float_is`'OP`'z_`'FLT1
')
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_compare<floatt2k(FLT1)> = g0float_compare_`'FLT1
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`implement gequal_val_val<FLT1> = g0float_eq<floatt2k(FLT1)>
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`implement gcompare_val_val<FLT1> = g0float_compare<floatt2k(FLT1)>
')dnl

(*------------------------------------------------------------------*)
(* Arithmetic. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`OP',`min,max,add,sub,mul,div,mod',
`implement g0float_`'OP<floatt2k(FLT1)> = g0float_`'OP`'_`'FLT1
')
')dnl

(*------------------------------------------------------------------*)
(* An implementation of g0float_npow that doesn’t contain a bug
   there is in the prelude’s implementation. The prelude’s
   implementation unwisely assumes C correctly casts between
   floating point types. *)

//   FIXME: REPORT THIS AS A BUG IN THE PRELUDE.
//   FIXME: REPORT THIS AS A BUG IN THE PRELUDE.
//   FIXME: REPORT THIS AS A BUG IN THE PRELUDE.
//   FIXME: REPORT THIS AS A BUG IN THE PRELUDE.

implement {tk}
g0float_npow (x, n) =
  let
    fun
    loop {n : nat}
         .<n>.
         (x     : g0float tk,
          accum : g0float tk,
          n     : int n)
        :<> g0float tk =
      if 2 <= n then
        let
          val nhalf = half n
          and xsquare = x * x
        in
          if nhalf + nhalf = n then
            loop (xsquare, accum, nhalf)
          else
            loop (xsquare, x * accum, nhalf)
        end
      else if n <> 0 then
        x * accum
      else
        accum
  in
    loop (x, g0i2f 1, n)
  end

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

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

implement fprint_val<FLT1> = fprint_`'FLT1

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
(* Epsilon. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_epsilon<floatt2k(FLT1)> = g0float_epsilon_`'FLT1
')dnl

(*------------------------------------------------------------------*)
(* Float radix. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_radix<floatt2k(FLT1)> = g0float_radix_`'FLT1
')dnl

(*------------------------------------------------------------------*)
(* Miscellaneous other floating point parameters. *)

m4_foreachq(`PARAM',`mant_dig, min_exp, max_exp,
                     max_value, min_value, true_min_value',
`m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_`'PARAM<floatt2k(FLT1)> = g0float_`'PARAM`'_`'FLT1
')dnl

')dnl
m4_foreachq(`PARAM',`decimal_dig, dig, min_10_exp, max_10_exp',
`m4_foreachq(`FLT1',`regular_floattypes, extended_binary_floattypes',
`implement g0float_`'PARAM<floatt2k(FLT1)> = g0float_`'PARAM`'_`'FLT1
')dnl

')dnl
(*------------------------------------------------------------------*)
(* Sign, absolute value, negative. *)

m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_sgn<floatt2k(FLT1)> = g0float_sgn_`'FLT1
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_abs<floatt2k(FLT1)> = g0float_abs_`'FLT1
')dnl

m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_neg<floatt2k(FLT1)> = g0float_neg_`'FLT1
')dnl

(*------------------------------------------------------------------*)
(* Library functions. *)

implement {tk}
g0float_strfrom (format, x) =
  let
    vtypedef unsafe_strfrom_cloptr =
      {p : addr}
      {n : int}
      (!array_v (byte?, p, n) >> array_v (byte, p, n) |
       ptr p, size_t n) -<cloptr1>
        int

    typedef unsafe_strfrom_cloref =
      {p : addr}
      {n : int}
      (!array_v (byte?, p, n) >> array_v (byte, p, n) |
       ptr p, size_t n) -<cloref1>
        int

    extern fn
    my_extern_prefix`'validate_strfrom_format :
      string -<> bool = "ext#%"

    extern fn
    my_extern_prefix`'apply_unsafe_strfrom :
      unsafe_strfrom_cloref -> Strptr1 = "ext#%"

    val valid = my_extern_prefix`'validate_strfrom_format format
  in
    if ~valid then
      let
        val msg = "g0float_strfrom:invalid_format_string"
      in
        $raise IllegalArgExn msg
      end
    else
      let
        val unsafe_strfrom =
          begin
            lam (pf_buf | p_buf, size) =<cloptr1>
              g0float_unsafe_strfrom<tk> (!p_buf, size, format, x)
          end : unsafe_strfrom_cloptr
        val clo = $UN.castvwtp1{unsafe_strfrom_cloref} unsafe_strfrom
        val retval = my_extern_prefix`'apply_unsafe_strfrom clo
        val () = cloptr_free ($UN.castvwtp0 unsafe_strfrom)
      in
        retval
      end
(*
      let
        #define BUFSZ 128
        var buf : @[byte][BUFSZ]
        val n = g0float_unsafe_strfrom<tk> (buf, i2sz BUFSZ,
                                            format, x)
        val n = g1ofg0 n
        val () = assertloc (isgtez n)
      in
        if n < BUFSZ then
          string0_copy ($UN.cast{string} buf)
        else
          let
            val n1 = succ (i2sz n)
            val @(pf_buf, pfgc_buf | p_buf) = array_ptr_alloc<byte> n1
            val m = g0float_unsafe_strfrom<tk> (!p_buf, n1, format, x)
            val () = assertloc (m = n)
            val retval = string0_copy ($UN.cast{string} p_buf)
            val () = array_ptr_free (pf_buf, pfgc_buf | p_buf)
          in
            retval
          end
      end
*)
  end

m4_foreachq(`FUNC',`unary_ops, binary_ops, trinary_ops,
                    scalbn, scalbln, ilogb,
                    frexp, modf,
                    unsafe_strfrom, unsafe_strto',
`m4_foreachq(`FLT1',`conventional_floattypes',
`implement g0float_`'FUNC`'<floatt2k(FLT1)> = g0float_`'FUNC`'_`'FLT1
')dnl

')dnl
(*------------------------------------------------------------------*)
(* `Comparisons.' *)

(* In case a type has been given no specific implementations of some
   of the `comparisons' to zero. *)
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

(* In case a type has no specific implementation of succ. *)
implement {tk}
g0float_succ x =
  x + g0i2f 1

(* In case a type has no specific implementation of pred. *)
implement {tk}
g0float_pred x =
  x - g0i2f 1

m4_foreachq(`FLT1',`conventional_floattypes',
`m4_foreachq(`OP',`min,max,add,sub,mul,div,mod,succ,pred',
`implement g0float_`'OP<floatt2k(FLT1)> = g0float_`'OP`'_`'FLT1
')
')dnl

(*------------------------------------------------------------------*)
(* Floating point constants. *)

m4_foreachq(`CONST',`list_of_m4_constant',
`(* m4_constant_comment(CONST) *)
m4_foreachq(`FLT1',`conventional_floattypes',
`implement mathconst_`'CONST<floatt2k(FLT1)> () = M_`'CONST`'floatt2sfx(FLT1)
')dnl  

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

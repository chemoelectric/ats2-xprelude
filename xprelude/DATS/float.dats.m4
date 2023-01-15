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

#define ATS_DYNLOADFLAG 0

#define ATS_PACKNAME "ats2-xprelude.float"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"

staload "xprelude/SATS/integer.sats"
staload _ = "xprelude/DATS/integer.dats"

staload "xprelude/SATS/float.sats"

(*------------------------------------------------------------------*)

implement g0float_epsilon<fltknd> = g0float_epsilon_float
implement g0float_epsilon<dblknd> = g0float_epsilon_double
implement g0float_epsilon<ldblknd> = g0float_epsilon_ldouble

implement g0float_sgn<fltknd> = g0float_sgn_float
implement g0float_sgn<dblknd> = g0float_sgn_double
implement g0float_sgn<ldblknd> = g0float_sgn_ldouble

m4_foreachq(uop,`unary_ops',
`
implement g0float_`'uop`'<fltknd> = g0float_`'uop`'_float
implement g0float_`'uop`'<dblknd> = g0float_`'uop`'_double
implement g0float_`'uop`'<ldblknd> = g0float_`'uop`'_ldouble
')

m4_foreachq(aop,`binary_ops',
`
implement g0float_`'aop`'<fltknd> = g0float_`'aop`'_float
implement g0float_`'aop`'<dblknd> = g0float_`'aop`'_double
implement g0float_`'aop`'<ldblknd> = g0float_`'aop`'_ldouble
')

m4_foreachq(top,`trinary_ops',
`
implement g0float_`'top`'<fltknd> = g0float_`'top`'_float
implement g0float_`'top`'<dblknd> = g0float_`'top`'_double
implement g0float_`'top`'<ldblknd> = g0float_`'top`'_ldouble
')

(*------------------------------------------------------------------*)
(* Implementations of some of the templates in the prelude.         *)

implement {tk} g0float_isltz x = g0float_lt<tk> (x, g0i2f 0)
implement {tk} g0float_isltez x = g0float_lte<tk> (x, g0i2f 0)
implement {tk} g0float_isgtz x = g0float_gt<tk> (x, g0i2f 0)
implement {tk} g0float_isgtez x = g0float_gte<tk> (x, g0i2f 0)
implement {tk} g0float_iseqz x = g0float_eq<tk> (x, g0i2f 0)
implement {tk} g0float_isneqz x = g0float_neq<tk> (x, g0i2f 0)

implement gequal_val_val<float> (x, y) = (x = y)
implement gequal_val_val<ldouble> (x, y) = (x = y)

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT',`float,double,ldouble',
`implement g0int2float<intb2k(INT),floatt2k(FLT)> = g0int2float_`'INT`_'FLT
')
')dnl

m4_foreachq(`INT',`intbases',
`m4_foreachq(`FLT',`float,double,ldouble',
`implement g0float2int<floatt2k(FLT),intb2k(INT)> = g0float2int_`'FLT`_'INT
')
')dnl

m4_foreachq(`FLT1',`float,double,ldouble',
`m4_foreachq(`FLT2',`float,double,ldouble',
`implement g0float2float<floatt2k(FLT1),floatt2k(FLT2)> = g0float2float_`'FLT1`_'FLT2
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

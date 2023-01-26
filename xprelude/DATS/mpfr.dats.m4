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

#define ATS_PACKNAME "ats2-xprelude.mpfr"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload "xprelude/SATS/fixed32p32.sats"
staload _ = "xprelude/DATS/fixed32p32.dats"

staload "xprelude/SATS/exrat.sats"
staload _ = "xprelude/DATS/exrat.dats"

staload "xprelude/SATS/mpfr.sats"

(*------------------------------------------------------------------*)
(* Precision. *)

extern fn
mpfr_set_default_prec_uintmax :
  $d2ctype (mpfr_set_default_prec_guint<uintmaxknd>) = "mac#%"

extern fn
mpfr_set_prec_uintmax :
  $d2ctype (mpfr_set_prec_guint<uintmaxknd>) = "mac#%"

implement {tk}
mpfr_set_default_prec_gint prec =
  mpfr_set_default_prec_uintmax (g1int2uint<tk,uintmaxknd> prec)

implement {tk}
mpfr_set_default_prec_guint prec =
  mpfr_set_default_prec_uintmax (g1uint2uint<tk,uintmaxknd> prec)

implement {tk}
mpfr_set_prec_gint (x, prec) =
  mpfr_set_prec_uintmax (x, g1int2uint<tk,uintmaxknd> prec)

implement {tk}
mpfr_set_prec_guint (x, prec) =
  mpfr_set_prec_uintmax (x, g1uint2uint<tk,uintmaxknd> prec)

(*------------------------------------------------------------------*)
(* Creating new mpfr instances of given precision. *)

extern fn
_mpfr_make_prec_uintmax :
  {prec : pos}
  uintmax prec -<> mpfr = "mac#%"

implement {tk}
mpfr_make_prec_gint prec =
  _mpfr_make_prec_uintmax (g1i2u prec)

implement {tk}
mpfr_make_prec_guint prec =
  _mpfr_make_prec_uintmax (g1u2u prec)

(*------------------------------------------------------------------*)
(* Value-replacement symbols. *)

(* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - *)
(* Replacement (<-) *)

extern fn fixed32p32_mpfr_replace : g0float_replace_type (fix32p32knd, mpfr) = "mac#%"
extern fn exrat_mpfr_replace : g0float_replace_type (exratknd, mpfr) = "mac#%"
m4_foreachq(`T',`floattypes',
`extern fn mpfr_`'T`'_replace : g0float_replace_type (mpfrknd, T) = "mac#%"
')dnl
m4_foreachq(`INT',`intbases',
`extern fn mpfr_`'INT`'_replace : g0float_replace_type (mpfrknd, intb2t(INT)) = "mac#%"
')dnl

implement g0float_float_replace<fix32p32knd><mpfrknd> = fixed32p32_mpfr_replace
implement g0float_float_replace<exratknd><mpfrknd> = exrat_mpfr_replace
implement g0float_float_replace<mpfrknd><mpfrknd> = mpfr_mpfr_replace
m4_foreachq(`FLT1',`floattypes_without_mpfr',
`implement g0float_float_replace<mpfrknd><floatt2k(FLT1)> = mpfr_`'FLT1`'_replace
')dnl
m4_foreachq(`INT',`intbases',
`implement g0float_int_replace<mpfrknd><intb2k(INT)> = mpfr_`'INT`'_replace
')dnl

(* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - *)
(* Negation. *)

m4_foreachq(`OP',`negate',
`implement g0float_`'OP<mpfrknd> = g0float_`'OP`'_mpfr
')dnl

(*------------------------------------------------------------------*)
(* Miscellaneous implementations for mpfr. *)

m4_foreachq(`OP',`neg',
`implement g0float_`'OP<mpfrknd> = g0float_`'OP`'_mpfr
')dnl

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:
dnl

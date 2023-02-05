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
(*------------------------------------------------------------------*)

#define ATS_PACKNAME "ats2-xprelude.arith_prf"

(*------------------------------------------------------------------*)
(* CHAR_BIT (in <limits.h>) is almost certainly equal to 8, but, in
   xprelude/DATS/arith_prf.dats, we will also VERIFY that CHAR_BIT
   does equal 8. *)

#define ATS2_XPRELUDE_ARITH_PRF_CHAR_BIT 8

m4_define(`CHAR_BIT',``ATS2_XPRELUDE_ARITH_PRF_CHAR_BIT'')dnl
dnl
(*------------------------------------------------------------------*)
(* Lemmas for division that return more information than do their
   equivalents in the prelude. *)

(* The prelude’s version of divmod_mul_elim does not assert that r =
   (x \nmod_int_int y), although that is implied by the rest of the
   result. *)
praxi
divmod_mul_elim :
  {x, y : int | 0 <= x; 0 < y}
  {q, r : int}
  DIVMOD (x, y, q, r) -<prf>
    [0 <= q; 0 <= r; r < y;
     q == (x \ndiv_int_int y);
     r == (x \nmod_int_int y);
     x == (q * y) + r]
     void

(*------------------------------------------------------------------*)
(*

  EUCLIDEAN DIVISION, with remainder always positive:

  Division with truncation towards minus infinity, if the divisor is
  positive, or towards plus infinity, if the divisor is negative.
 
  See Boute, Raymond T, ‘The Euclidean definition of the functions div
  and mod’, ACM Transactions on Programming Languages and Systems
  (TOPLAS), 14(2), April 1992, pp. 127-144, doi:10.1145/128861.128862.
 
  This is how ‘div’ and ‘mod’ work in SMT2.

*)

(* Division. *)
stacst eucliddiv : (int, int) -> int

(* The remainder after division. *)
stadef euclidrem (n : int, d : int) = n - (eucliddiv (n, d) * d)

local

  infixl (/) div rem
  stadef div = eucliddiv
  stadef rem = euclidrem

in (* local *)

  absprop EUCLIDDIV (n : int, d : int, q : int, r : int)

  praxi
  eucliddiv_istot :
    {n, d : int | d != 0}
    () -<prf> EUCLIDDIV (n, d, n div d, n rem d)

  praxi
  eucliddiv_isfun :
    {n, d   : int}
    {q1, r1 : int}
    {q2, r2 : int}
    (EUCLIDDIV (n, d, q1, r1),
     EUCLIDDIV (n, d, q2, r2)) -<prf>
      [q1 == q2; r1 == r2]
      void

  prfn
  eucliddiv_elim :
    {n, d : int}
    {q, r : int}
    EUCLIDDIV (n, d, q, r) -<prf>
      [qd : int | d != 0; 0 <= r; r < abs d; n == qd + r]
      MUL (q, d, qd)

  praxi
  eucliddiv_mul_elim :
    {n, d : int}
    {q, r : int}
    EUCLIDDIV (n, d, q, r) -<prf>
      [d != 0; q == n div d; r == n rem d;
       0 <= r; r < abs d; n == (q * d) + r]
      void

  praxi
  eucliddiv_divmod :
    {n, d   : nat}
    {q1, r1 : int}
    {q2, r2 : int}
    (EUCLIDDIV (n, d, q1, r1),
     DIVMOD (n, d, q2, r2)) -<prf>
      [q1 == q2; r1 == r2]
      void

  prfn
  eucliddiv_div :
    {n, d : int | 0 <= n; 0 < d}
    () -<prf> [n div d == (n \ndiv_int_int d)] void

  prfn
  euclidrem_mod :
    {n, d : int | 0 <= n; 0 < d}
    () -<prf> [n rem d == (n \nmod_int_int d)] void

end (* local *)

(*------------------------------------------------------------------*)
(* Bitwise logical operations. *)

stacst lsl_int_int : (int, int) -> int
stacst lsr_int_int : (int, int) -> int

stacst asl_int_int : (int, int) -> int
stacst asr_int_int : (int, int) -> int

stacst lnot_int : int -> int
stacst land_int_int : (int, int) -> int
stacst lor_int_int : (int, int) -> int
stacst lxor_int_int : (int, int) -> int

stacst signed_lnot_int : int -> int
stacst signed_land_int_int : (int, int) -> int
stacst signed_lor_int_int : (int, int) -> int
stacst signed_lxor_int_int : (int, int) -> int

(*------------------------------------------------------------------*)
(* ‘Count trailing zeros’ of a positive number. *)

stacst ctz_int : int -> int

praxi
lemma_ctz_isnat :
  {n : pos}
  () -<prf>
    [0 <= ctz_int n]
    void

praxi
lemma_ctz_bounds_gint :
  {tk : tkind}
  {n  : pos}
  g1int (tk, n) -<prf>
    [0 <= ctz_int n;
     ctz_int n < CHAR_BIT * sizeof (g1int (tk, n))]
    void

praxi
lemma_ctz_bounds_guint :
  {tk : tkind}
  {n  : pos}
  g1int (tk, n) -<prf>
    [0 <= ctz_int n;
     ctz_int n < CHAR_BIT * sizeof (g1uint (tk, n))]
    void

(*------------------------------------------------------------------*)
(* ‘Find first set’ and ‘find last set’ of a non-negative number. *)

stacst ffs_int : int -> int
stacst fls_int : int -> int

m4_foreachq(`OP',`ffs, fls',
`praxi
lemma_`'OP`'_isnat :
  {n : nat}
  () -<prf>
    [0 <= OP`'_int n]
    void

praxi
lemma_`'OP`'_bounds_gint :
  {tk : tkind}
  {n  : nat}
  g1int (tk, n) -<prf>
    [0 <= OP`'_int n;
     OP`'_int n <= CHAR_BIT * sizeof (g1int (tk, n))]
    void

praxi
lemma_`'OP`'_bounds_guint :
  {tk : tkind}
  {n  : nat}
  g1int (tk, n) -<prf>
    [0 <= OP`'_int n;
     OP`'_int n <= CHAR_BIT * sizeof (g1uint (tk, n))]
    void

')dnl
(*------------------------------------------------------------------*)
(* Population count of a non-negative number. *)

stacst popcount_int : int -> int

praxi
lemma_popcount_isnat :
  {n : nat}
  () -<prf>
    [0 <= popcount_int n]
    void

praxi
lemma_popcount_bounds_gint :
  {tk : tkind}
  {n  : nat}
  g1int (tk, n) -<prf>
    [0 <= popcount_int n;
     popcount_int n <= CHAR_BIT * sizeof (g1int (tk, n))]
    void

praxi
lemma_popcount_bounds_guint :
  {tk : tkind}
  {n  : nat}
  g1int (tk, n) -<prf>
    [0 <= popcount_int n;
     popcount_int n <= CHAR_BIT * sizeof (g1uint (tk, n))]
    void

(*------------------------------------------------------------------*)
(* Greatest common divisor, with gcd(0,0) = 0. *)

stacst gcd_int_int : (int, int) -> int

praxi
lemma_gcd_isfun :
  {i1, j1 : int}
  {i2, j2 : int | i1 == i2; j1 == j2}
  () -<prf>
    [gcd_int_int (i1, j1) == gcd_int_int (i2, j2)]
    void

praxi
lemma_gcd_is_commutative :
  {i, j : int}
  () -<prf>
    [gcd_int_int (i, j) == gcd_int_int (j, i)]
    void

praxi
lemma_gcd_is_associative :
  {x, y, z : int}
  () -<prf>
    [((x \gcd_int_int y) \gcd_int_int z)
        == (x \gcd_int_int (y \gcd_int_int z))]
    void

praxi
lemma_gcd_is_sign_invariant :
  {i, j : int}
  () -<prf>
    [gcd_int_int (i, j) == gcd_int_int (abs i, abs j)]
    void

praxi
lemma_gcd_of_zero :
  {i : int}
  () -<prf>
    [gcd_int_int (0, i) == i]
    void

praxi
lemma_gcd_of_equals :
  {i : int}
  () -<prf>
    [gcd_int_int (i, i) == i]
    void

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

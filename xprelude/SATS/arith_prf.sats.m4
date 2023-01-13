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
#define ATS_EXTERN_PREFIX "ats2_xprelude_"

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
dnl
dnl local variables:
dnl mode: ATS
dnl end:

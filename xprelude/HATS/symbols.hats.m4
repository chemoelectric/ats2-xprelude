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
(* The following symbols are motivated by existence of numeric
   types—such as the floating point representation used by mpfr—that
   prefer to have their internals manipulated.

   The differ from symbols such as := whose role is to change the
   contents of a storage address, rather than to change the internals
   of the data structure stored there. Symbols such as <- are meant to
   do either of these things, depending on the type.

   It seemed prudent to use different symbols, rather than override
   the meanings of the old ones. *)

infix 0 <-                      (* Value replacement. *)
infix 0 <->                     (* Value swapping. *)

infix 0 <+-                     (* Add to the value. *)
infix 0 <~-                     (* Subtract from the value. *)
infix 0 <*-                     (* Multiply the value. *)
infix 0 </-                     (* Divide the value. *)

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

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

#define ATS_DYNLOADFLAG 0

#define ATS_PACKNAME "ats2-xprelude.float"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"

(*------------------------------------------------------------------*)

local

  fn
  valid_letter (c : char)
      :<> bool =
    (c = 'a') || (c = 'A')
      || (c = 'e') || (c = 'E')
      || (c = 'f') || (c = 'F')
      || (c = 'g') || (c = 'G')

  fn
  precision_is_all_digits
            {n   : int | 3 <= n}
            (fmt : string n,
             n   : size_t n)
      :<> bool =
    let
      fun
      loop {i : int | 2 <= i; i <= n - 1}
           .<(n - 1) - i>.
           (i : size_t i)
          :<> bool =
        if i = pred n then
          true
        else if isdigit fmt[i] then
          loop (succ i)
        else
          false
    in
      loop (i2sz 2)
    end

in (* local *)

  extern fn
  my_extern_prefix`'validate_strfrom_format :
    string -<> bool = "ext#%"

  implement
  my_extern_prefix`'validate_strfrom_format fmt =
    let
      val fmt = g1ofg0 fmt
      val n = length fmt
    in
      if n < i2sz 2 then
        false
      else if fmt[0] <> '%' then
        false
      else if fmt[1] = '.' then
        (* Precision is specified. *)
        (i2sz 3 <= n
          && precision_is_all_digits (fmt, n)
          && valid_letter fmt[pred n])
      else
        (* Precision is not specified. *)
        (n = i2sz 2 && valid_letter fmt[1])
    end

end (* local *)

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

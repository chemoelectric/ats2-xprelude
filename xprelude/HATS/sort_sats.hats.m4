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
#ifndef ATS2_XPRELUDE__SORT_SATS_HATS__HEADER_GUARD__ #then
#define ATS2_XPRELUDE__SORT_SATS_HATS__HEADER_GUARD__ 1

staload "xprelude/SATS/sort.sats"
m4_if(WITH_TIMSORT,`yes',
`staload "timsort/SATS/array-timsort.sats"
')dnl

#endif (* ATS2_XPRELUDE__SORT_SATS_HATS__HEADER_GUARD__ *)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

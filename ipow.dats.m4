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
(*------------------------------------------------------------------*)

#define ATS_DYNLOADFLAG 0

#define ATS_PACKNAME "ats2-xprelude.integer"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"

staload UN = "prelude/SATS/unsafe.sats"
staload "xprelude/SATS/integer.sats"

(*------------------------------------------------------------------*)

(*

  If the base is a g0uint, the implementation below will compute the
  power modulo the number of values the type of that base can
  represent.

  Zero raised to the power zero equals one.

*)

%{^

#include <assert.h>
#include <limits.h>

divert(-1)

m4_define(`NUM_BITS_PER_LOOP',`8')

m4_define(`handle_next_bit',
`  $3 *= ($2 & 1) * $1;
  $2 >>= 1;
  $1 *= $1;
')

m4_define(`handle_n_bits_continuous',
`m4_forloop(`I',`1',`$1',`
handle_next_bit(`$2',`$3',`$4')')
')

m4_define(`handle_up_to_n_bits_final',
`m4_forloop(`I',`2',`$1',`
case m4_eval(($1) - I + 2):
handle_next_bit(`$2',`$3',`$4')')
case 1:
  $4 *= ($3 & 1) * $2;

case 0:
  /* Do nothing. */ ;
')

m4_define(`write_ipow_function',`
$2
my_extern_prefix`'g0uint_ipow_$1_$3 ($2 base, $4 exponent)
{
  assert (0 <= exponent);
  $2 power = 1;
  int last_set = my_extern_prefix`'g0uint_fls_$3 (exponent);
  if (CHAR_BIT * sizeof exponent > NUM_BITS_PER_LOOP)
    while (last_set > NUM_BITS_PER_LOOP)
      {
        handle_n_bits_continuous(NUM_BITS_PER_LOOP,`base',`exponent',`power')
        last_set -= NUM_BITS_PER_LOOP;
      }
  switch (last_set)
    {
      handle_up_to_n_bits_final(NUM_BITS_PER_LOOP,`base',`exponent',`power')
    }
  return power;
}
')dnl

divert`'dnl

m4_foreachq(`UINT1',`conventional_uintbases',
`m4_foreachq(`UINT2',`conventional_uintbases',`
write_ipow_function(UINT1, uintb2c(UINT1), UINT2, uintb2c(UINT2), `u')
')dnl
')dnl

m4_foreachq(`INT1',`conventional_intbases',
`m4_foreachq(`UINT2',`conventional_uintbases',`
write_ipow_function(INT1, intb2c(INT1), UINT2, uintb2c(UINT2), `u')
')dnl
')dnl

%}

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

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

`As an exercise, in handle_next_bit I avoid branches, although it
seems to me that the more obvious implementation with a branch is
likely to be faster on many machines: '
m4_define(`handle_next_bit',
`  $3 *= (1 - ($2 & 1)) + (($2 & 1) * $1);
  $2 >>= 1;
  $1 *= $1;
')

m4_define(`handle_up_to_n_bits',
`m4_forloop(`I',`2',`$1',`
case m4_eval(($1) - I + 2):
handle_next_bit(`$2',`$3',`$4')')
case 1:
  $4 *= ($3 & 1) * $2;

case 0:
  /* Do nothing. */ ;
')

m4_define(`write_ipow_calculation_in_simplest_form',
`  $2 power = 1;
  switch (my_extern_prefix`'g0uint_fls_$3 (exponent))
    {
      handle_up_to_n_bits(integer_bitsize($3),`base',`exponent',`power')
    }
  return power;')

m4_define(`write_ipow_function_actual_function',`
$2
my_extern_prefix`'g0$5int_ipow_$1_$3 ($2 base, $4 exponent)
{
m4_if($5,`u',`write_ipow_calculation_in_simplest_form(`$1',`$2',`$3',`$4',`$5')',
      m4_eval(integer_bitsize($3) <= 8),`1',`write_ipow_calculation_in_simplest_form(`$1',`$2',`$3',`$4',`$5')',
      m4_eval(256 < integer_bitsize($1)),`1',`write_ipow_calculation_in_simplest_form(`$1',`$2',`$3',`$4',`$5')',
`  $2 power;
  if ((base < -1) | (1 < base))
    {
      /* Any exponent larger than uint8 is going to cause a signed
         integer to overflow, so ignore any bits left of the least
         significant byte. The result would have been ‘undefined’,
         anyway, and possibly the calculation would have raised a
         signal. (Only UNSIGNED integers are guaranteed by C to ‘wrap
         around’ on overflow.) */
      power = my_extern_prefix`'g0$5int_ipow_$1_uint8 (base, (uint8_t) exponent);
    }
  else if (base == 1)
    power = 1;
  else if (base == 0)
    power = 1 - (exponent & 1);
  else /* base == -1 */
    power = 1 - (2 * (exponent & 1));
  return power;')
}
')

m4_define(`write_ipow_function_calling_another',`
$2
my_extern_prefix`'g0$5int_ipow_$1_$3 ($2 base, $4 exponent)
{
  return my_extern_prefix`'g0$5int_ipow_$5int$6_uint$7 (base, exponent);
}
')

m4_define(`write_ipow_function',
`m4_if($1$3,`int8uint8',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`uint8uint8',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`int16uint8',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`uint16uint8',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`int32uint8',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`uint32uint8',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`int64uint8',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`uint64uint8',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',

       $1$3,`int8uint16',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`8',`32')',
       $1$3,`uint8uint16',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`8',`32')',
       $1$3,`int16uint16',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`16',`32')',
       $1$3,`uint16uint16',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`16',`32')',
       $1$3,`int32uint16',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`32',`32')',
       $1$3,`uint32uint16',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`32',`32')',
       $1$3,`int64uint16',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`32',`32')',
       $1$3,`uint64uint16',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`32',`32')',

       $1$3,`int8uint32',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`uint8uint32',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`int16uint32',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`uint16uint32',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`int32uint32',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`uint32uint32',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`int64uint32',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`uint64uint32',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',

       $1$3,`int8uint64',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`uint8uint64',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`int16uint64',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`uint16uint64',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`int32uint64',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`uint32uint64',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`int64uint64',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',
       $1$3,`uint64uint64',`write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')',

       integer_bitsize($1)`:'integer_bitsize($3),`8:8',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`8',`8')',
       integer_bitsize($1)`:'integer_bitsize($3),`16:8',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`16',`8')',
       integer_bitsize($1)`:'integer_bitsize($3),`32:8',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`32',`8')',
       integer_bitsize($1)`:'integer_bitsize($3),`64:8',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`64',`8')',

       integer_bitsize($1)`:'integer_bitsize($3),`8:16',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`8',`32')',
       integer_bitsize($1)`:'integer_bitsize($3),`16:16',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`16',`32')',
       integer_bitsize($1)`:'integer_bitsize($3),`32:16',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`32',`32')',
       integer_bitsize($1)`:'integer_bitsize($3),`64:16',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`64',`32')',

       integer_bitsize($1)`:'integer_bitsize($3),`8:32',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`8',`32')',
       integer_bitsize($1)`:'integer_bitsize($3),`16:32',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`16',`32')',
       integer_bitsize($1)`:'integer_bitsize($3),`32:32',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`32',`32')',
       integer_bitsize($1)`:'integer_bitsize($3),`64:32',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`64',`32')',

       integer_bitsize($1)`:'integer_bitsize($3),`8:64',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`8',`64')',
       integer_bitsize($1)`:'integer_bitsize($3),`16:64',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`16',`64')',
       integer_bitsize($1)`:'integer_bitsize($3),`32:64',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`32',`64')',
       integer_bitsize($1)`:'integer_bitsize($3),`64:64',
          `write_ipow_function_calling_another(`$1',`$2',`$3',`$4',`$5',`64',`64')',

       `write_ipow_function_actual_function(`$1',`$2',`$3',`$4',`$5')')dnl
')

divert`'dnl

m4_foreachq(`UINT1',`conventional_uintbases',
`m4_foreachq(`UINT2',`conventional_uintbases',`
write_ipow_function(UINT1, uintb2c(UINT1), UINT2, uintb2c(UINT2), `u')
')dnl
')dnl

m4_foreachq(`INT1',`conventional_intbases',
`m4_foreachq(`UINT2',`conventional_uintbases',`
write_ipow_function(INT1, intb2c(INT1), UINT2, uintb2c(UINT2), `')
')dnl
')dnl

%}

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

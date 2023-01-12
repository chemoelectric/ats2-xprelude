/*
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
*/
include(`common-macros.m4')m4_include(`ats2-xprelude-macros.m4')

#ifndef ATS2_POLY_CATS__INTEGER_CATS__HEADER_GUARD__
#define ATS2_POLY_CATS__INTEGER_CATS__HEADER_GUARD__

#include <stdint.h>
#include <`inttypes'.h>

#ifndef ats2_poly_inline
#define ats2_poly_inline ATSinline ()
#endif

/*------------------------------------------------------------------*/
/* intmax_t and uintmax_t */

typedef intmax_t ats2_poly_intmax;
typedef uintmax_t ats2_poly_uintmax;

/*------------------------------------------------------------------*/
/* Type conversions. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT1',`intbases',
`m4_foreachq(`INT2',`intbases',
`
ats2_poly_inline intb2c(INT2)
ats2_poly_g`'N`'int2int_`'INT1`_'INT2 (intb2c(INT1) i)
{
  return (intb2c(INT2)) i;
}
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT1',`intbases',
`m4_foreachq(`UINT2',`uintbases',
`
ats2_poly_inline uintb2c(UINT2)
ats2_poly_g`'N`'int2uint_`'INT1`_'UINT2 (intb2c(INT1) i)
{
  return (uintb2c(UINT2)) i;
}
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT1',`uintbases',
`m4_foreachq(`INT2',`intbases',
`
ats2_poly_inline intb2c(INT2)
ats2_poly_g`'N`'uint2int_`'UINT1`_'INT2 (uintb2c(UINT1) i)
{
  return (intb2c(INT2)) i;
}
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT1',`uintbases',
`m4_foreachq(`UINT2',`uintbases',
`
ats2_poly_inline uintb2c(UINT2)
ats2_poly_g`'N`'uint2uint_`'UINT1`_'UINT2 (uintb2c(UINT1) i)
{
  return (uintb2c(UINT2)) i;
}
')
')
')dnl

/*------------------------------------------------------------------*/
/* Comparisons. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`m4_foreachq(`OP',`comparisons',
`
ats2_poly_inline atstype_bool
ats2_poly_g`'N`'int_`'OP`_'INT (intb2c(INT) i, intb2c(INT) j)
{
  return (i ats_cmp_c(OP) j);
}
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`m4_foreachq(`OP',`comparisons',
`
ats2_poly_inline atstype_bool
ats2_poly_g`'N`'uint_`'OP`_'UINT (uintb2c(UINT) i, uintb2c(UINT) j)
{
  return (i ats_cmp_c(OP) j);
}
')
')
')dnl

/*------------------------------------------------------------------*/
/* Comparisons with zero. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`m4_foreachq(`OP',`comparisons',
`
ats2_poly_inline atstype_bool
`ats2_poly_g'N`int_is'OP`z_'INT (intb2c(INT) i)
{
  return (i ats_cmp_c(OP) 0);
}
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`m4_foreachq(`OP',`gt,eq,neq',
`
ats2_poly_inline atstype_bool
`ats2_poly_g'N`uint_is'OP`z_'UINT (uintb2c(UINT) i)
{
  return (i ats_cmp_c(OP) 0);
}
')
')
')dnl

/*------------------------------------------------------------------*/
/* Negation. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`
ats2_poly_inline intb2c(INT)
ats2_poly_g`'N`'int_neg_`'INT (intb2c(INT) i)
{
  return (-i);
}
')
')dnl

/*------------------------------------------------------------------*/
/* Absolute value. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`
ats2_poly_inline intb2c(INT)
ats2_poly_g`'N`'int_abs_`'INT (intb2c(INT) i)
{
  return (i < 0) ? (-i) : i;
}
')
')dnl

/*------------------------------------------------------------------*/
/* Successor and predecessor. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`
ats2_poly_inline intb2c(INT)
ats2_poly_g`'N`'int_succ_`'INT (intb2c(INT) i)
{
  return (i + 1);
}

ats2_poly_inline intb2c(INT)
ats2_poly_g`'N`'int_pred_`'INT (intb2c(INT) i)
{
  return (i - 1);
}
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`
ats2_poly_inline uintb2c(UINT)
ats2_poly_g`'N`'uint_succ_`'UINT (uintb2c(UINT) i)
{
  return (i + 1);
}

ats2_poly_inline uintb2c(UINT)
ats2_poly_g`'N`'uint_pred_`'UINT (uintb2c(UINT) i)
{
  return (i - 1);
}
')
')dnl

/*------------------------------------------------------------------*/
/* Integer halving (ignoring remainder). */

/* It seems worthwhile, here, to know what the C standards require of
   the >> operator, so programmers will know some thought went into
   the following.

   C standards require that >> on an unsigned or non-negative value be
   division by a power of 2. So one can write ‘>>1’ instead of
   ‘/2’. Either way, the C compiler is likely to produce the same
   code.

   On the other hand, the C standard does not specify the behavior of
   the >> operator, if it is acting on a negative number. So some
   other method must be employed. We write ‘/2’, which C compilers are
   likely to turn into an arithmetic shift right. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`
ats2_poly_inline intb2c(INT)
ats2_poly_g`'N`'int_half_`'INT (intb2c(INT) i)
{
  return (i / 2);
}
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`
ats2_poly_inline uintb2c(UINT)
ats2_poly_g`'N`'uint_half_`'UINT (uintb2c(UINT) i)
{
  return (i >> 1);
}
')
')dnl

/*------------------------------------------------------------------*/
/* Addition. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`
ats2_poly_inline intb2c(INT)
ats2_poly_g`'N`'int_add_`'INT (intb2c(INT) i, intb2c(INT) j)
{
  return (i + j);
}
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`
ats2_poly_inline uintb2c(UINT)
ats2_poly_g`'N`'uint_add_`'UINT (uintb2c(UINT) i, uintb2c(UINT) j)
{
  return (i + j);
}
')
')dnl

/*------------------------------------------------------------------*/

#endif /* ATS2_POLY_CATS__INTEGER_CATS__HEADER_GUARD__ */
dnl
dnl local variables:
dnl mode: C
dnl end:

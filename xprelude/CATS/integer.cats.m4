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

#ifndef MY_EXTERN_PREFIX`'CATS__INTEGER_CATS__HEADER_GUARD__
#define MY_EXTERN_PREFIX`'CATS__INTEGER_CATS__HEADER_GUARD__

#include <assert.h>
#include <stdint.h>
#include <`inttypes'.h>
#include <limits.h>

#ifndef my_extern_prefix`'inline
#define my_extern_prefix`'inline ATSinline ()
#endif

#ifndef my_extern_prefix`'boolc2ats
#define my_extern_prefix`'boolc2ats(B) \
  ((B) ? (atsbool_true) : (atsbool_false))
#endif

/*------------------------------------------------------------------*/
/*

  Credit for some of the programming ideas employed below belongs to:

  {{cite web
   | title       = Bit Twiddling Hacks
   | url         = https://graphics.stanford.edu/~seander/bithacks.html
   | date        = 2023-01-14
   | archiveurl  = http://archive.today/GNADt
   | archivedate = 2023-01-14 }}

  {{cite web
   | title       = BitScan - Chessprogramming wiki
   | url         = https://www.chessprogramming.org/index.php?title=BitScan&oldid=22495
   | date        = 2023-02-03
   | archiveurl  = http://archive.today/iPXfa
   | archivedate = 2023-02-03 }}

*/
/*------------------------------------------------------------------*/
/* intmax_t and uintmax_t */

typedef intmax_t my_extern_prefix`'intmax;
typedef uintmax_t my_extern_prefix`'uintmax;

/*------------------------------------------------------------------*/
/* Printing. */

m4_foreachq(`INT',`intbases',
`
my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'fprint_`'INT (atstype_ref out, intb2c(INT) x)
{
  (void) fprintf ((FILE *) out, "%jd", (intmax_t) x);
}

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'print_`'INT (intb2c(INT) x)
{
  (void) fprintf (stdout, "%jd", (intmax_t) x);
}

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'prerr_`'INT (intb2c(INT) x)
{
  (void) fprintf (stderr, "%jd", (intmax_t) x);
}
')dnl

m4_foreachq(`UINT',`uintbases',
`
my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'fprint_`'UINT (atstype_ref out, uintb2c(UINT) x)
{
  (void) fprintf ((FILE *) out, "%ju", (uintmax_t) x);
}

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'print_`'UINT (uintb2c(UINT) x)
{
  (void) fprintf (stdout, "%jd", (uintmax_t) x);
}

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'prerr_`'UINT (uintb2c(UINT) x)
{
  (void) fprintf (stderr, "%jd", (uintmax_t) x);
}
')dnl

/*------------------------------------------------------------------*/
/* Type conversions. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT1',`intbases',
`m4_foreachq(`INT2',`intbases',
`
my_extern_prefix`'inline intb2c(INT2)
my_extern_prefix`'g`'N`'int2int_`'INT1`_'INT2 (intb2c(INT1) i)
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
my_extern_prefix`'inline uintb2c(UINT2)
my_extern_prefix`'g`'N`'int2uint_`'INT1`_'UINT2 (intb2c(INT1) i)
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
my_extern_prefix`'inline intb2c(INT2)
my_extern_prefix`'g`'N`'uint2int_`'UINT1`_'INT2 (uintb2c(UINT1) i)
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
my_extern_prefix`'inline uintb2c(UINT2)
my_extern_prefix`'g`'N`'uint2uint_`'UINT1`_'UINT2 (uintb2c(UINT1) i)
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
my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g`'N`'int_`'OP`_'INT (intb2c(INT) i, intb2c(INT) j)
{
  return my_extern_prefix`'boolc2ats (i ats_cmp_c(OP) j);
}
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`m4_foreachq(`OP',`comparisons',
`
my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g`'N`'uint_`'OP`_'UINT (uintb2c(UINT) i, uintb2c(UINT) j)
{
  return my_extern_prefix`'boolc2ats (i ats_cmp_c(OP) j);
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
my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g`'N`'int_is`'OP`z_'INT (intb2c(INT) i)
{
  return my_extern_prefix`'boolc2ats (i ats_cmp_c(OP) 0);
}
')
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`m4_foreachq(`OP',`gt,eq,neq',
`
my_extern_prefix`'inline atstype_bool
my_extern_prefix`'g`'N`'uint_is`'OP`z_'UINT (uintb2c(UINT) i)
{
  return my_extern_prefix`'boolc2ats (i ats_cmp_c(OP) 0);
}
')
')
')dnl

/*------------------------------------------------------------------*/
/* ‘qsort-style’ comparison. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`
my_extern_prefix`'inline intb2c(`i'nt)
my_extern_prefix`'g`'N`'int_compare_`'INT (intb2c(INT) i, intb2c(INT) j)
{
  return (i > j) - (i < j);
}
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`
my_extern_prefix`'inline intb2c(`i'nt)
my_extern_prefix`'g`'N`'uint_compare_`'UINT (uintb2c(UINT) i, uintb2c(UINT) j)
{
  return (i > j) - (i < j);
}
')
')dnl

/*------------------------------------------------------------------*/
/* Negation. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`
my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g`'N`'int_neg_`'INT (intb2c(INT) i)
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
my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g`'N`'int_abs_`'INT (intb2c(INT) i)
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
my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g`'N`'int_succ_`'INT (intb2c(INT) i)
{
  return (i + 1);
}

my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g`'N`'int_pred_`'INT (intb2c(INT) i)
{
  return (i - 1);
}
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`
my_extern_prefix`'inline uintb2c(UINT)
my_extern_prefix`'g`'N`'uint_succ_`'UINT (uintb2c(UINT) i)
{
  return (i + 1);
}

my_extern_prefix`'inline uintb2c(UINT)
my_extern_prefix`'g`'N`'uint_pred_`'UINT (uintb2c(UINT) i)
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
my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g`'N`'int_half_`'INT (intb2c(INT) i)
{
  return (i / 2);
}
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`
my_extern_prefix`'inline uintb2c(UINT)
my_extern_prefix`'g`'N`'uint_half_`'UINT (uintb2c(UINT) i)
{
  return (i >> 1);
}
')
')dnl

/*------------------------------------------------------------------*/
/* Logical complement. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`
my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g`'N`'int_lnot_`'INT (intb2c(INT) i)
{
  return (~i);
}
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`
my_extern_prefix`'inline uintb2c(UINT)
my_extern_prefix`'g`'N`'uint_lnot_`'UINT (uintb2c(UINT) i)
{
  return (~i);
}
')
')dnl

/*------------------------------------------------------------------*/
/* Binary operations. */

m4_foreachq(`BINOP',`add,sub,mul,div,mod,land,lor,lxor',
`m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`m4_if(BINOP`'N,`mod1',`',dnl  /* Skip g1int_mod */
`
my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g`'N`'int_`'BINOP`'_`'INT (intb2c(INT) i, intb2c(INT) j)
{
  return (i ats_binop_c(BINOP) j);
}
')dnl
')
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`
my_extern_prefix`'inline uintb2c(UINT)
my_extern_prefix`'g`'N`'uint_`'BINOP`'_`'UINT (uintb2c(UINT) i, uintb2c(UINT) j)
{
  return (i ats_binop_c(BINOP) j);
}
')
')dnl
')dnl

m4_foreachq(`INT',`intbases',
`
my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g1int_nmod_`'INT (intb2c(INT) i, intb2c(INT) j)
{
  return (i % j);
}
')dnl

#undef _`'my_extern_prefix`'min
#undef _`'my_extern_prefix`'max
#define _`'my_extern_prefix`'min(x, y) (((x) < (y)) ? (x) : (y))
#define _`'my_extern_prefix`'max(x, y) (((y) < (x)) ? (x) : (y))

m4_foreachq(`BINOP',`min,max',
`m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`
my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g`'N`'int_`'BINOP`'_`'INT (intb2c(INT) i, intb2c(INT) j)
{
  return _`'my_extern_prefix`'`'BINOP (i, j);
}
')dnl
')dnl

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`
my_extern_prefix`'inline uintb2c(UINT)
my_extern_prefix`'g`'N`'uint_`'BINOP`'_`'UINT (uintb2c(UINT) i, uintb2c(UINT) j)
{
  return _`'my_extern_prefix`'`'BINOP (i, j);
}
')
')dnl
')dnl

#undef _`'my_extern_prefix`'min
#undef _`'my_extern_prefix`'max

/*------------------------------------------------------------------*/
/* Euclidean division with remainder always positive. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`
my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g`'N`'int_eucliddiv_`'INT (intb2c(INT) n, intb2c(INT) d)
{
  /* The C optimizer most likely will reduce these these two divisions
     to just one. */
  intb2c(INT) q0 = n / d;
  intb2c(INT) r0 = n % d;

  return ((0 <= n) ? q0 :
          (r0 == 0) ? q0 :
          (d < 0) ? (q0 + 1) :
          (q0 - 1));
}

my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g`'N`'int_euclidrem_`'INT (intb2c(INT) n, intb2c(INT) d)
{
  /* The C optimizer most likely will reduce these these two divisions
     to just one. */
  intb2c(INT) q0 = n / d;
  intb2c(INT) r0 = n % d;

  return ((0 <= n) ? r0 :
          (r0 == 0) ? r0 :
          (d < 0) ? (r0 - d) :
          (r0 + d));
}
')
')dnl

/*------------------------------------------------------------------*/
/* Logical shifts. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`UINT',`uintbases',
`
my_extern_prefix`'inline uintb2c(UINT)
my_extern_prefix`'g`'N`'uint_lsl_`'UINT (uintb2c(UINT) n, atstype_int i)
{
  return (i < CHAR_BIT * sizeof n) ? (n << i) : 0;
}

my_extern_prefix`'inline uintb2c(UINT)
my_extern_prefix`'g`'N`'uint_lsr_`'UINT (uintb2c(UINT) n, atstype_int i)
{
  return (i < CHAR_BIT * sizeof n) ? (n >> i) : 0;
}
')
')dnl

/*------------------------------------------------------------------*/
/* Arithmetic shifts. */

/* One should not really rely on << and >> operators to do arithmetic
   shifts. The following implementations instead use unsafe unions and
   logical shifts.

   Unions seemed a safer way to do the conversion between signed and
   unsigned than did casts. A cast of a negative number to an unsigned
   representation is allowed (by C standards) to signal an error. */

m4_foreachq(`N',`0,1',
`m4_foreachq(`INT',`intbases',
`
my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g`'N`'int_asl_`'INT (intb2c(INT) n, atstype_int i)
{
  union {
    intb2c(INT) i;
    uintb2c(int2uintbase(INT)) u;
  } x;

  x.i = n;
  x.u = my_extern_prefix`'g`'N`'uint_lsl_`'int2uintbase(INT) (x.u, i);
  return x.i;
}

my_extern_prefix`'inline intb2c(INT)
my_extern_prefix`'g`'N`'int_asr_`'INT (intb2c(INT) n, atstype_int i)
{
  union {
    intb2c(INT) i;
    uintb2c(int2uintbase(INT)) u;
  } x;

  x.i = n;
  if (n < 0)
    /* The bit-complement operations are so we get filling on the left
       with ones instead of zeros. */
    x.u = ~my_extern_prefix`'g`'N`'uint_lsr_`'int2uintbase(INT) (~x.u, i);
  else
    x.u = my_extern_prefix`'g`'N`'uint_lsr_`'int2uintbase(INT) (x.u, i);
  return x.i;
}
')
')dnl

/*------------------------------------------------------------------*/
/* Count trailing zeros. */

my_extern_prefix`'inline intb2c(int)
my_extern_prefix`'_ctz_uint64_fallback (uintb2c(uint64) n)
{
  /* De Bruijn bitscan with separated LS1B. See
     http://archive.today/iPXfa */
  return
    "\0\57\1\70\60\33\2\74\71\61\51\45\34\20\3\75\66\72\43\64\62\52\25\54\46\40\35\27\21\13\4\76\56\67\32\73\50\44\17\65\42\63\24\53\37\26\12\55\31\47\16\41\23\36\11\30\15\22\10\14\7\6\5\77"
    [((((uint64_t) n) ^ (((uint64_t) n) - 1)) * UINT64_C(0x03f79d71b4cb0a89)) >> 58];
}

#if defined __GNUC__

my_extern_prefix`'inline intb2c(int)
my_extern_prefix`'g0uint_ctz_uint (uintb2c(uint) n)
{
  return __builtin_ctz (n);
}

my_extern_prefix`'inline intb2c(int)
my_extern_prefix`'g0uint_ctz_ulint (uintb2c(ulint) n)
{
  return __builtin_ctzl (n);
}

my_extern_prefix`'inline intb2c(int)
my_extern_prefix`'g0uint_ctz_ullint (uintb2c(ullint) n)
{
  return __builtin_ctzll (n);
}

m4_foreachq(`INT',`sint, int, int8, int16, int32',
`#define my_extern_prefix`'g0int_ctz_`'INT`'(n) (my_extern_prefix`'g0uint_ctz_uint ((uintb2c(uint)) (n)))
')dnl
m4_foreachq(`INT',`lint',
`#define my_extern_prefix`'g0int_ctz_`'INT`'(n) (my_extern_prefix`'g0uint_ctz_ulint ((uintb2c(ulint)) (n)))
')dnl
m4_foreachq(`INT',`int64, llint, lint64, ssize, intptr, intmax',
`#define my_extern_prefix`'g0int_ctz_`'INT`'(n) (my_extern_prefix`'g0uint_ctz_ullint ((uintb2c(ullint)) (n)))
')dnl

m4_foreachq(`UINT',`usint, uint8, uint16, uint32',
`#define my_extern_prefix`'g0uint_ctz_`'UINT`'(n) (my_extern_prefix`'g0uint_ctz_uint ((uintb2c(uint)) (n)))
')dnl
m4_foreachq(`UINT',`uint64, size, uintptr, uintmax',
`#define my_extern_prefix`'g0uint_ctz_`'UINT`'(n) (my_extern_prefix`'g0uint_ctz_ullint ((uintb2c(ullint)) (n)))
')dnl

#else /* if not __GNUC__ */

_Static_assert (sizeof (uintb2c(uintmax)) <= 64,
                "the implementation of count trailing zeros "
                "assumes integers do not exceed 64 bits in size");

m4_foreachq(`INT',`intbases',
`#define my_extern_prefix`'g0int_ctz_`'INT`'(n)`'dnl
 (my_extern_prefix`'_ctz_uint64_fallback ((uintb2c(uint)) (n)))
')dnl

m4_foreachq(`UINT',`uintbases',
`#define my_extern_prefix`'g0uint_ctz_`'UINT`'(n)`'dnl
 (my_extern_prefix`'_ctz_uint64_fallback ((uintb2c(uint)) (n)))
')dnl

#endif /* if not __GNUC__ */

m4_foreachq(`INT',`intbases',
`#define my_extern_prefix`'g1int_ctz_`'INT my_extern_prefix`'g0int_ctz_`'INT
')dnl

m4_foreachq(`UINT',`uintbases',
`#define my_extern_prefix`'g1uint_ctz_`'UINT my_extern_prefix`'g0uint_ctz_`'UINT
')dnl

/*------------------------------------------------------------------*/

#endif `/*' MY_EXTERN_PREFIX`'CATS__INTEGER_CATS__HEADER_GUARD__ */
dnl
dnl local variables:
dnl mode: C
dnl end:

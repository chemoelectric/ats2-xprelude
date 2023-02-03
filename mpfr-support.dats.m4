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
m4_define(`REF',`atstype_ref')
(*------------------------------------------------------------------*)

#define ATS_DYNLOADFLAG 0

#define ATS_PACKNAME "ats2-xprelude.mpfr-support"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

#include "xprelude/HATS/xprelude_sats.hats"
staload "xprelude/SATS/mpfr.sats"

(*------------------------------------------------------------------*)
%{

#include <assert.h>
#include <stdint.h>
#include <`inttypes'.h>
#include <limits.h>

extern atsvoid_t0ype my_extern_prefix`'gmp_support_initialize (void);

#ifndef my_extern_prefix`'boolc2ats
#define my_extern_prefix`'boolc2ats(B) \
  ((B) ? (atsbool_true) : (atsbool_false))
#endif

#undef ROUNDING
#define ROUNDING my_extern_prefix`'mpfr_rnd

/*------------------------------------------------------------------*/

/* Round to the nearest number, giving ties to the nearest even. */
volatile mpfr_rnd_t my_extern_prefix`'mpfr_rnd = MPFR_RNDN;

volatile atomic_int my_extern_prefix`'mpfr_support_is_initialized = 0;

/* Use unsigned integers, so they will wrap around when they
   overflow. */
static volatile atomic_size_t my_extern_prefix`'mpfr_initialization_active = 0;
static volatile atomic_size_t my_extern_prefix`'mpfr_initialization_available = 0;

#define my_extern_prefix`'mpfr_support_pause() \
  do { /* nothing */ } while (0)

#if defined __GNUC__ && (defined __i386__ || defined __x86_64__)
/* Similar things can be done for other platforms and other
   compilers. */
#undef my_extern_prefix`'mpfr_support_pause
#define my_extern_prefix`'mpfr_support_pause() __builtin_ia32_pause ()
#endif

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'mpfr_initialization_obtain_lock (void)
{
  size_t my_ticket =
    atomic_fetch_add_explicit (&my_extern_prefix`'mpfr_initialization_available,
                               1, memory_order_seq_cst);

  while (my_ticket != atomic_load_explicit (&my_extern_prefix`'mpfr_initialization_active,
                                            memory_order_seq_cst))
    my_extern_prefix`'mpfr_support_pause ();

  atomic_thread_fence (memory_order_seq_cst);
}

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'mpfr_initialization_release_lock (void)
{
  atomic_thread_fence (memory_order_seq_cst);
  (void) atomic_fetch_add_explicit (&my_extern_prefix`'mpfr_initialization_active,
                                    1, memory_order_seq_cst);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_support_initialize (void)
{
  /* Initialize mpfr support. A ticket-lock is used to ensure this
     initialization is done but once. */

  my_extern_prefix`'mpfr_initialization_obtain_lock ();
  if (!atomic_load_explicit (&my_extern_prefix`'mpfr_support_is_initialized,
                             memory_order_acquire))
    {
      my_extern_prefix`'gmp_support_initialize ();

      atomic_store_explicit (&my_extern_prefix`'mpfr_support_is_initialized,
                             1, memory_order_release);
    }
  my_extern_prefix`'mpfr_initialization_release_lock ();
}

/*------------------------------------------------------------------*/
/* Basic printing. */

static atsvoid_t0ype
_`'my_extern_prefix`'fprint_mpfr (FILE *outf, floatt2c(mpfr) x)
{
  mpfr_fprintf (outf, "%.6Rf", x);
}

atsvoid_t0ype
my_extern_prefix`'fprint_mpfr (atstype_ref fref, floatt2c(mpfr) x)
{
  _`'my_extern_prefix`'fprint_mpfr ((FILE *) fref, x);
}

atsvoid_t0ype
my_extern_prefix`'print_mpfr (floatt2c(mpfr) x)
{
  _`'my_extern_prefix`'fprint_mpfr (stdout, x);
}

atsvoid_t0ype
my_extern_prefix`'prerr_mpfr (floatt2c(mpfr) x)
{
  _`'my_extern_prefix`'fprint_mpfr (stderr, x);
}

/*------------------------------------------------------------------*/
/* Formatted conversion to a string. */

intb2c(int)
my_extern_prefix`'g0float_unsafe_strfrom_mpfr (atstype_ptr str,
                                               uintb2c(size) n,
                                               atstype_string format,
                                               floatt2c(mpfr) fp)
{
  /* Assuming the format string is valid for g0float_strfrom, convert
     it to a format string for mpfr_snprintf. That is, insert the
     letter 'R' before the last character. */
  size_t format_len = strlen (format);
  assert (format_len >= 2);
  char *fmt = ATS_MALLOC (format_len + 2);
  memcpy (fmt, format, format_len - 1);
  fmt[format_len - 1] = m4_singlequote`'R`'m4_singlequote;
  fmt[format_len] = format[format_len - 1];
  fmt[format_len + 1] = m4_singlequote`'\0`'m4_singlequote;

  /* Using the modified format string, call mpfr_snprintf, in lieu of
     an actual strfromd-like function. */
  int retval = mpfr_snprintf (str, n, fmt, fp);

  /* Freeing the temporary format is not necessary, because one our
     mpfr support assumes a garbage collector. But I think freeing
     also will do no notable harm. */
  ATS_MFREE (fmt);

  return retval;
}

/*------------------------------------------------------------------*/
/* Creating an mpfr with a NaN value. */

static my_extern_prefix`'mpfr
_`'my_extern_prefix`'mpfr_init2 (mpfr_prec_t prec)
{
  my_extern_prefix`'mpfr_one_time_initialization ();
  floatt2c(mpfr) z = ATS_MALLOC (sizeof (my_extern_prefix`'mpfr_t));
  mpfr_init2 (z[0], prec);
  return z;
}

static my_extern_prefix`'mpfr
_`'my_extern_prefix`'mpfr_init_defaultprec (void)
{
  my_extern_prefix`'mpfr_one_time_initialization ();
  floatt2c(mpfr) z = ATS_MALLOC (sizeof (my_extern_prefix`'mpfr_t));
  mpfr_init (z[0]);
  return z;
}

static my_extern_prefix`'mpfr
_`'my_extern_prefix`'mpfr_init_maxprec1 (floatt2c(mpfr) x)
{
  my_extern_prefix`'mpfr_one_time_initialization ();
  floatt2c(mpfr) z = ATS_MALLOC (sizeof (my_extern_prefix`'mpfr_t));
  uintmax_t prec = mpfr_get_prec (x[0]);
  mpfr_init2 (z[0], prec);
  return z;
}

static my_extern_prefix`'mpfr
_`'my_extern_prefix`'mpfr_init_maxprec2 (floatt2c(mpfr) x,
                                         floatt2c(mpfr) y)
{
  my_extern_prefix`'mpfr_one_time_initialization ();
  floatt2c(mpfr) z = ATS_MALLOC (sizeof (my_extern_prefix`'mpfr_t));
  uintmax_t precx = mpfr_get_prec (x[0]);
  uintmax_t precy = mpfr_get_prec (y[0]);
  uintmax_t prec = (precx < precy) ? precy : precx;
  mpfr_init2 (z[0], prec);
  return z;
}

static my_extern_prefix`'mpfr
_`'my_extern_prefix`'mpfr_init_maxprec3 (floatt2c(mpfr) x,
                                         floatt2c(mpfr) y,
                                         floatt2c(mpfr) w)
{
  my_extern_prefix`'mpfr_one_time_initialization ();
  floatt2c(mpfr) z = ATS_MALLOC (sizeof (my_extern_prefix`'mpfr_t));
  uintmax_t precx = mpfr_get_prec (x[0]);
  uintmax_t precy = mpfr_get_prec (y[0]);
  uintmax_t precw = mpfr_get_prec (w[0]);
  uintmax_t prec = (precx < precy) ? precy : precx;
  prec = (prec < precw) ? precw : prec;
  mpfr_init2 (z[0], prec);
  return z;
}

/*------------------------------------------------------------------*/
/* Precision. */

my_extern_prefix`'inline mpfr_prec_t
_correct_prec (uintb2c(uintmax) prec)
{
  if (prec < MPFR_PREC_MIN)
    prec = MPFR_PREC_MIN;
  else if (prec > MPFR_PREC_MAX)
    prec = MPFR_PREC_MAX;
  return (mpfr_prec_t) prec;
}

atsvoid_t0ype
my_extern_prefix`'mpfr_set_default_prec_uintmax (uintb2c(uintmax) prec)
{
  mpfr_set_default_prec (_correct_prec (prec));
}

atsvoid_t0ype
my_extern_prefix`'mpfr_set_prec_uintmax (REF(mpfr) xp, uintb2c(uintmax) prec)
{
  floatt2c(mpfr) x = DEREF(mpfr, xp);
  mpfr_set_prec (x[0], _correct_prec (prec));
}

/*------------------------------------------------------------------*/
/* Creating new mpfr instances of given precision. */

my_extern_prefix`'mpfr
my_extern_prefix`'_mpfr_make_nan_prec_uintmax (uintb2c(uintmax) prec)
{
  return _`'my_extern_prefix`'mpfr_init2 (_correct_prec (prec));
}

/*------------------------------------------------------------------*/
/* Type conversions. */

divert(-1)

m4_define(`convertible_floattypes',
          `float, double, ldouble,
           float16, float32, float64, float128,
           float16x, float32x, float64x,
           decimal32, decimal64, decimal128,
           decimal64x, fixed32p32, exrat')

divert`'dnl

floatt2c(mpfr)
my_extern_prefix`'g0int2float_intmax_mpfr (intb2c(intmax) i)
{
  floatt2c(mpfr) z = _`'my_extern_prefix`'mpfr_init_defaultprec ();
  _`'my_extern_prefix`'mpfr_intmax_replace (&z, i);
  return z;
}

intb2c(intmax)
my_extern_prefix`'g0float2int_mpfr_intmax (floatt2c(mpfr) x)
{
  return mpfr_get_sj (x[0], ROUNDING);
}

m4_foreachq(`FLT1',`convertible_floattypes',`
FLOAT_SUPPORT_CHECK_FOR_MPFR(FLT1)

floatt2c(mpfr)
my_extern_prefix`'g0float2float_`'FLT1`'_mpfr (floatt2c(FLT1) x)
{
  floatt2c(mpfr) z = _`'my_extern_prefix`'mpfr_init_defaultprec ();
  my_extern_prefix`'mpfr_`'FLT1`'_replace (&z, x);
  return z;
}

m4_if(FLT1,`exrat',
`floatt2c(exrat)
my_extern_prefix`'g0float2float_mpfr_exrat (floatt2c(mpfr) x)
{
  floatt2c(exrat) z = my_extern_prefix`'g0int2float_int_exrat (0);
  my_extern_prefix`'exrat_mpfr_replace (&z, x);
  return z;
}
',
`floatt2c(FLT1)
my_extern_prefix`'g0float2float_mpfr_`'FLT1 (floatt2c(mpfr) x)
{
  floatt2c(FLT1) z;
  my_extern_prefix`'FLT1`'_`'mpfr_replace (&z, x);
  return z;
}
')dnl

END_FLOAT_SUPPORT_CHECK_FOR_MPFR(FLT1)
')dnl

/*------------------------------------------------------------------*/
/* Assorted operations. */

divert(-1)

m4_define(`supported_unary_ops',
  `sqrt, cbrt,
   exp, exp2, exp10,
   expm1, exp2m1, exp10m1,
   log, log2, log10,
   log1p, log2p1, log10p1,
   sin, cos, tan,
   asin, acos, atan,
   sinpi, cospi, tanpi,
   asinpi, acospi, atanpi,
   sinh, cosh, tanh,
   asinh, acosh, atanh,
   erf, erfc,
   j0, j1, y0, y1,
   digamma, eint, ai, li2, zeta')

m4_define(`supported_binary_ops',
  `copysign,
   fmod, remainder,
   pow, powr, hypot,
   atan2, atan2pi')

m4_define(`supported_trinary_ops',
  `fma')

m4_define(`supported_floattype_intmax_ops',
  `compoundn, rootn, pown')

divert`'dnl

m4_foreachq(`OP',`infinity, nan, huge_val',`
floatt2c(mpfr)
my_extern_prefix`'g0float_`'OP`'_mpfr (void)
{
  floatt2c(mpfr) z = _`'my_extern_prefix`'mpfr_init_defaultprec ();
dnl  Replacement would be redundant in the case of NaN.
  m4_if(OP,`nan',,`my_extern_prefix`'mpfr_`'OP`'_replace (&z);')
  return z;
}
')dnl

m4_foreachq(`OP',`neg, abs, fabs, reciprocal, logp1,
                  tgamma, lgamma,
                  round, nearbyint, rint, floor, ceil, trunc, roundeven,
                  nextup, nextdown,
                  supported_unary_ops',`
floatt2c(mpfr)
my_extern_prefix`'g0float_`'OP`'_mpfr (floatt2c(mpfr) x)
{
  floatt2c(mpfr) z = _`'my_extern_prefix`'mpfr_init_maxprec1 (x);
  my_extern_prefix`'mpfr_`'OP`'_replace (&z, x);
  return z;
}
')dnl

m4_foreachq(`OP',`add, sub, mul, div, supported_binary_ops',`
floatt2c(mpfr)
my_extern_prefix`'g0float_`'OP`'_mpfr (floatt2c(mpfr) x, floatt2c(mpfr) y)
{
  floatt2c(mpfr) z = _`'my_extern_prefix`'mpfr_init_maxprec2 (x, y);
  my_extern_prefix`'mpfr_`'OP`'_replace (&z, x, y);
  return z;
}
')dnl

m4_foreachq(`OP',`supported_trinary_ops',`
floatt2c(mpfr)
my_extern_prefix`'g0float_`'OP`'_mpfr (floatt2c(mpfr) x, floatt2c(mpfr) y, floatt2c(mpfr) w)
{
  floatt2c(mpfr) z = _`'my_extern_prefix`'mpfr_init_maxprec3 (x, y, w);
  my_extern_prefix`'mpfr_`'OP`'_replace (&z, x, y, w);
  return z;
}
')dnl

m4_foreachq(`OP',`supported_floattype_intmax_ops',`
floatt2c(mpfr)
my_extern_prefix`'g0float_`'OP`'_mpfr (floatt2c(mpfr) x, intb2c(intmax) i)
{
  floatt2c(mpfr) z = _`'my_extern_prefix`'mpfr_init_maxprec1 (x);
  my_extern_prefix`'mpfr_`'OP`'_replace (&z, x, i);
  return z;
}
')dnl

floatt2c(mpfr)
my_extern_prefix`'g0float_unsafe_strto_mpfr (atstype_ptr nptr, atstype_ptr endptr)
{
  floatt2c(mpfr) z = _`'my_extern_prefix`'mpfr_init_defaultprec ();
  my_extern_prefix`'mpfr_unsafe_strto_replace (&z, nptr, endptr);
  return z;
}

my_extern_prefix`'mpfr
my_extern_prefix`'_g0float_mul_2exp_intmax_mpfr (floatt2c(mpfr) x, intb2c(intmax) n)
{
  floatt2c(mpfr) z = _`'my_extern_prefix`'mpfr_init_maxprec1 (x);
  my_extern_prefix`'mpfr_mul_2exp_intmax_replace (&z, x, n);
  return z;
}

/*------------------------------------------------------------------*/
/* Value-replacement. */

atsvoid_t0ype
_`'my_extern_prefix`'mpfr_intmax_replace (REF(mpfr) yp, intb2c(intmax) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_sj (y[0], x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mpfr_replace (REF(mpfr) yp, floatt2c(mpfr) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set (y[0], x[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_float_replace (REF(mpfr) yp, floatt2c(float) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_flt (y[0], x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'float_mpfr_replace (REF(float) yp, floatt2c(mpfr) x)
{
  floatt2c(float) *y = (void *) yp;
  y[0] = mpfr_get_flt (x[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_double_replace (REF(mpfr) yp, floatt2c(double) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_d (y[0], x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'double_mpfr_replace (REF(double) yp, floatt2c(mpfr) x)
{
  floatt2c(double) *y = (void *) yp;
  y[0] = mpfr_get_d (x[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_ldouble_replace (REF(mpfr) yp, floatt2c(ldouble) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_ld (y[0], x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'ldouble_mpfr_replace (REF(ldouble) yp, floatt2c(mpfr) x)
{
  floatt2c(ldouble) *y = (void *) yp;
  y[0] = mpfr_get_ld (x[0], ROUNDING);
}

m4_foreachq(`N',`16, 16x, 32, 32x, 64, 64x, 128',`
FLOAT_SUPPORT_CHECK(`float'N)
FLOAT_SUPPORT_CHECK(`float128')

/* Be cautious and use float128, if it is available. */

atsvoid_t0ype
my_extern_prefix`'mpfr_float`'N`'_replace (REF(mpfr) yp, floatt2c(float`'N) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_float128 (y[0], (floatt2c(float128)) x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'float`'N`'_mpfr_replace (REF(float`'N) yp, floatt2c(mpfr) x)
{
  floatt2c(float`'N) *y = (void *) yp;
  y[0] = (floatt2c(float`'N)) mpfr_get_float128 (x[0], ROUNDING);
}

ELSE_FLOAT_SUPPORT_CHECK(`float128')

/* If float128 is not available, use ldouble (which likely is faster,
   anyway). */

atsvoid_t0ype
my_extern_prefix`'mpfr_float`'N`'_replace (REF(mpfr) yp, floatt2c(float`'N) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_ld (y[0], (floatt2c(ldouble)) x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'float`'N`'_mpfr_replace (REF(float`'N) yp, floatt2c(mpfr) x)
{
  floatt2c(float`'N) *y = (void *) yp;
  y[0] = (floatt2c(float`'N)) mpfr_get_ld (x[0], ROUNDING);
}

END_FLOAT_SUPPORT_CHECK(`float128')
END_FLOAT_SUPPORT_CHECK(`float'N)
')dnl

m4_foreachq(`N',`32, 64',`
FLOAT_SUPPORT_CHECK(`decimal'N)
#if `MPFR_HAS_DECIMAL'

atsvoid_t0ype
my_extern_prefix`'mpfr_decimal`'N`'_replace (REF(mpfr) yp, floatt2c(decimal`'N) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_decimal64 (y[0], (floatt2c(decimal64)) x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'decimal`'N`'_mpfr_replace (REF(decimal`'N) yp, floatt2c(mpfr) x)
{
  floatt2c(decimal`'N) *y = (void *) yp;
  y[0] = (floatt2c(decimal`'N)) mpfr_get_decimal64 (x[0], ROUNDING);
}

#else

atsvoid_t0ype
my_extern_prefix`'mpfr_decimal`'N`'_replace (REF(mpfr) yp, floatt2c(decimal`'N) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_ld (y[0], (floatt2c(ldouble)) x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'decimal`'N`'_mpfr_replace (REF(decimal`'N) yp, floatt2c(mpfr) x)
{
  floatt2c(decimal`'N) *y = (void *) yp;
  y[0] = (floatt2c(decimal`'N)) mpfr_get_ld (x[0], ROUNDING);
}

#endif
END_FLOAT_SUPPORT_CHECK(`decimal'N)
')dnl

m4_foreachq(`N',`64x,128',`
FLOAT_SUPPORT_CHECK(`decimal'N)
#if `MPFR_HAS_DECIMAL'

atsvoid_t0ype
my_extern_prefix`'mpfr_decimal`'N`'_replace (REF(mpfr) yp, floatt2c(decimal`'N) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_decimal64 (y[0], (floatt2c(decimal128)) x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'decimal`'N`'_mpfr_replace (REF(decimal`'N) yp, floatt2c(mpfr) x)
{
  floatt2c(decimal`'N) *y = (void *) yp;
  y[0] = (floatt2c(decimal`'N)) mpfr_get_decimal128 (x[0], ROUNDING);
}

m4_if(N,`128',,
`#else

atsvoid_t0ype
my_extern_prefix`'mpfr_decimal`'N`'_replace (REF(mpfr) yp, floatt2c(decimal`'N) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_ld (y[0], (floatt2c(ldouble)) x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'decimal`'N`'_mpfr_replace (REF(decimal`'N) yp, floatt2c(mpfr) x)
{
  floatt2c(decimal`'N) *y = (void *) yp;
  y[0] = (floatt2c(decimal`'N)) mpfr_get_ld (x[0], ROUNDING);
}
')
#endif
END_FLOAT_SUPPORT_CHECK(`decimal'N)
')dnl

divert(-1) ?????????????????????????????????????????????????????????????????????????????????????????
FLOAT_SUPPORT_CHECK_FOR_MPFR(`decimal128')

atsvoid_t0ype
my_extern_prefix`'mpfr_decimal128_replace (REF(mpfr) yp, floatt2c(decimal128) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_decimal128 (y[0], x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'decimal128_mpfr_replace (REF(decimal128) yp, floatt2c(mpfr) x)
{
  floatt2c(decimal128) *y = (void *) yp;
  y[0] = mpfr_get_decimal128 (x[0], ROUNDING);
}

END_FLOAT_SUPPORT_CHECK_FOR_MPFR(`decimal128')
 ????????????????????????????????????????????????????????????????????????????????????????? divert

atsvoid_t0ype
my_extern_prefix`'mpfr_fixed32p32_replace (REF(mpfr) yp, floatt2c(fixed32p32) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_sj_2exp (y[0], x, -32, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'fixed32p32_mpfr_replace (REF(fixed32p32) yp, floatt2c(mpfr) x)
{
  MPFR_DECL_INIT (tmp, 64);
  mpfr_mul_2exp (tmp, x[0], 32, ROUNDING);
  
  /* The number should be an integer now, and so the rounding mode
     does not matter. */
  *( int64_t * ) yp = (int64_t) mpfr_get_sj (tmp, MPFR_RNDZ);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_exrat_replace (REF(mpfr) yp, floatt2c(exrat) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_q (y[0], x[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'exrat_mpfr_replace (REF(exrat) yp, floatt2c(mpfr) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);
  mpfr_get_q (y[0], x[0]);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_exchange (REF(mpfr) yp, REF(mpfr) xp)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  floatt2c(mpfr) x = DEREF(mpfr, xp);
  mpfr_swap (y[0], x[0]);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_infinity_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_set_inf (z[0], 1);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_nan_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_set_nan (z[0]);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_huge_val_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_set_inf (z[0], 1);
}

m4_foreachq(`OP',`neg, abs, supported_unary_ops',`
atsvoid_t0ype
my_extern_prefix`'mpfr_`'OP`'_replace (REF(mpfr) zp, floatt2c(mpfr) x)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_`'OP (z[0], x[0], ROUNDING);
}
')dnl

m4_foreachq(`OP',`add, sub, mul, div, supported_binary_ops',`
atsvoid_t0ype
my_extern_prefix`'mpfr_`'OP`'_replace (REF(mpfr) zp, floatt2c(mpfr) x, floatt2c(mpfr) y)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_`'OP (z[0], x[0], y[0], ROUNDING);
}
')dnl

m4_foreachq(`OP',`supported_trinary_ops',`
atsvoid_t0ype
my_extern_prefix`'mpfr_`'OP`'_replace (REF(mpfr) zp, floatt2c(mpfr) x, floatt2c(mpfr) y, floatt2c(mpfr) w)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_`'OP (z[0], x[0], y[0], w[0], ROUNDING);
}
')dnl

atsvoid_t0ype
my_extern_prefix`'mpfr_fabs_replace (REF(mpfr) zp, floatt2c(mpfr) x)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_abs (z[0], x[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_reciprocal_replace (REF(mpfr) zp, floatt2c(mpfr) x)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_ui_div (z[0], 1, x[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_logp1_replace (REF(mpfr) zp, floatt2c(mpfr) x)
{
  my_extern_prefix`'mpfr_log1p_replace (zp, x);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_lgamma_replace (REF(mpfr) zp, floatt2c(mpfr) x)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  int sign;
  mpfr_lgamma (z[0], &sign, x[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_tgamma_replace (REF(mpfr) zp, floatt2c(mpfr) x)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_gamma (z[0], x[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_unsafe_strto_replace (REF(mpfr) zp, atstype_ptr nptr, atstype_ptr endptr)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_strtofr (z[0], (void *) nptr, (void *) endptr, 10, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_strto_replace (REF(mpfr) zp, REF(size) jp, atstype_string s, uintb2c(size) i)
{
  /* FIXME: THIS CANNOT HANDLE HEXADECIMAL INPUT. */
  /* FIXME: THIS CANNOT HANDLE HEXADECIMAL INPUT. */
  /* FIXME: THIS CANNOT HANDLE HEXADECIMAL INPUT. */
  /* FIXME: THIS CANNOT HANDLE HEXADECIMAL INPUT. */
  /* FIXME: THIS CANNOT HANDLE HEXADECIMAL INPUT. */

  floatt2c(mpfr) z = DEREF(mpfr, zp);
  uintb2c(size) *j = (void *) jp;
  char *startptr = (char *) (void *) s + i;
  char *endptr;
  mpfr_strtofr (z[0], startptr, &endptr, 10, ROUNDING);
  *j = i + (uintb2c(size)) (endptr - startptr);
}

m4_foreachq(`OP',`round, floor, ceil, trunc, roundeven',`
atsvoid_t0ype
my_extern_prefix`'mpfr_`'OP`'_replace (REF(mpfr) zp, floatt2c(mpfr) x)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_`'OP (z[0], x[0]);
}
')dnl

atsvoid_t0ype
my_extern_prefix`'mpfr_nearbyint_replace (REF(mpfr) zp, floatt2c(mpfr) x)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_rint (z[0], x[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_rint_replace (REF(mpfr) zp, floatt2c(mpfr) x)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_rint (z[0], x[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_nextup_replace (REF(mpfr) zp, floatt2c(mpfr) x)
{
  /* WARNING: THIS SETS NEXT-UP IN THE PRECISION OF zp. */
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_set (z[0], x[0], ROUNDING);
  mpfr_nextabove (z[0]);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_nextdown_replace (REF(mpfr) zp, floatt2c(mpfr) x)
{
  /* WARNING: THIS SETS NEXT-DOWN IN THE PRECISION OF zp. */
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_set (z[0], x[0], ROUNDING);
  mpfr_nextbelow (z[0]);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_compoundn_replace (REF(mpfr) zp, floatt2c(mpfr) x, intb2c(intmax) i)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_compound_si (z[0], x[0], i, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_rootn_replace (REF(mpfr) zp, floatt2c(mpfr) x, intb2c(intmax) i)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_rootn_si (z[0], x[0], i, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_pown_replace (REF(mpfr) zp, floatt2c(mpfr) x, intb2c(intmax) i)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_pow_sj (z[0], x[0], i, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mul_2exp_intmax_replace (REF(mpfr) zp,
                                                floatt2c(mpfr) x,
                                                intb2c(intmax) n)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  if (0 <= n)
    mpfr_mul_2ui (z[0], x[0], n, ROUNDING);
  else
    mpfr_div_2ui (z[0], x[0], -n, ROUNDING);
}

m4_foreachq(`CONST',`pi, euler, catalan',`
atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_`'m4_toupper(CONST)`'_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_const_`'CONST (z[0], ROUNDING);
}
')dnl

atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_LN2_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_const_log2 (z[0], ROUNDING);
}

#ifndef MY_EXTERN_PREFIX`'EXTRA_PREC
#define MY_EXTERN_PREFIX`'EXTRA_PREC 8
#endif

static inline uintmax_t
_add_extra_prec (uintmax_t prec)
{
  return (UINTMAX_MAX - MY_EXTERN_PREFIX`'EXTRA_PREC <= prec) ?
      UINTMAX_MAX : (prec + MY_EXTERN_PREFIX`'EXTRA_PREC);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_E_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_set_ui (z[0], 1, ROUNDING);
  mpfr_exp (z[0], z[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_LOG2E_replace (REF(mpfr) zp)
{
  /* We use the identity log2(e) = 1/ln(2). */
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  uintmax_t prec = mpfr_get_prec (z[0]);
  prec = _add_extra_prec (prec);
  mpfr_t x;
  mpfr_init2 (x, prec);
  mpfr_const_log2 (x, ROUNDING); /* Cache ln2 to higher precision. */
  mpfr_ui_div (z[0], 1, x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_LOG10E_replace (REF(mpfr) zp)
{
  /* We use the identity log10(e) = 1/ln(10). */
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  uintmax_t prec = mpfr_get_prec (z[0]);
  prec = _add_extra_prec (prec);
  mpfr_t x;
  mpfr_init2 (x, prec);
  mpfr_log_ui (x, 10, ROUNDING);
  mpfr_ui_div (z[0], 1, x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_LN10_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_log_ui (z[0], 10, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_PI_2_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  uintmax_t prec = mpfr_get_prec (z[0]);
  prec = _add_extra_prec (prec);
  mpfr_t x;
  mpfr_init2 (x, prec);
  mpfr_const_pi (x, ROUNDING);  /* Cache pi to higher precision. */
  mpfr_div_ui (z[0], x, 2, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_PI_4_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  uintmax_t prec = mpfr_get_prec (z[0]);
  prec = _add_extra_prec (prec);
  mpfr_t x;
  mpfr_init2 (x, prec);
  mpfr_const_pi (x, ROUNDING);  /* Cache pi to higher precision. */
  mpfr_div_ui (z[0], x, 4, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_1_PI_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  uintmax_t prec = mpfr_get_prec (z[0]);
  prec = _add_extra_prec (prec);
  mpfr_t x;
  mpfr_init2 (x, prec);
  mpfr_const_pi (x, ROUNDING);  /* Cache pi to higher precision. */
  mpfr_ui_div (z[0], 1, x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_2_PI_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  uintmax_t prec = mpfr_get_prec (z[0]);
  prec = _add_extra_prec (prec);
  mpfr_t x;
  mpfr_init2 (x, prec);
  mpfr_const_pi (x, ROUNDING);  /* Cache pi to higher precision. */
  mpfr_ui_div (z[0], 2, x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_2_SQRTPI_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  uintmax_t prec = mpfr_get_prec (z[0]);
  prec = _add_extra_prec (prec);
  mpfr_t x;
  mpfr_init2 (x, prec);
  mpfr_const_pi (x, ROUNDING);  /* Cache pi to higher precision. */
  mpfr_sqrt (x, x, ROUNDING);
  mpfr_ui_div (z[0], 2, x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_SQRT2_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  mpfr_sqrt_ui (z[0], 2, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_mathconst_SQRT1_2_replace (REF(mpfr) zp)
{
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  uintmax_t prec = mpfr_get_prec (z[0]);
  prec = _add_extra_prec (prec);
  mpfr_t x;
  mpfr_init2 (x, prec);
  mpfr_sqrt_ui (x, 2, ROUNDING);
  mpfr_ui_div (z[0], 1, x, ROUNDING);
}

%}
(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:
dnl

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
/* Creating an mpfr with a NaN value. */

static my_extern_prefix`'mpfr
_`'my_extern_prefix`'mpfr_init2 (mpfr_prec_t prec)
{
  my_extern_prefix`'mpfr_one_time_initialization ();
  floatt2c(mpfr) x = ATS_MALLOC (sizeof (my_extern_prefix`'mpfr_t));
  mpfr_init2 (x[0], prec);
  return x;
}

static my_extern_prefix`'mpfr
_`'my_extern_prefix`'mpfr_init (void)
{
  my_extern_prefix`'mpfr_one_time_initialization ();
  floatt2c(mpfr) x = ATS_MALLOC (sizeof (my_extern_prefix`'mpfr_t));
  mpfr_init (x[0]);
  return x;
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
  `fmod')

divert`'dnl

m4_foreachq(`OP',`neg, abs, fabs, reciprocal, logp1,
                  tgamma, lgamma,
                  supported_unary_ops',`
floatt2c(mpfr)
my_extern_prefix`'g0float_`'OP`'_mpfr (floatt2c(mpfr) x)
{
  floatt2c(mpfr) z = _`'my_extern_prefix`'mpfr_init ();
  my_extern_prefix`'mpfr_`'OP`'_replace (&z, x);
  return z;
}
')dnl

m4_foreachq(`OP',`add, sub, mul, div, supported_binary_ops',`
floatt2c(mpfr)
my_extern_prefix`'g0float_`'OP`'_mpfr (floatt2c(mpfr) x, floatt2c(mpfr) y)
{
  floatt2c(mpfr) z = _`'my_extern_prefix`'mpfr_init ();
  my_extern_prefix`'mpfr_`'OP`'_replace (&z, x, y);
  return z;
}
')dnl

floatt2c(mpfr)
my_extern_prefix`'g0float_unsafe_strto_mpfr (atstype_ptr nptr, atstype_ptr endptr)
{
  floatt2c(mpfr) z = _`'my_extern_prefix`'mpfr_init ();
  my_extern_prefix`'mpfr_unsafe_strto_replace (&z, nptr, endptr);
  return z;
}

/*------------------------------------------------------------------*/
/* Value-replacement. */

atsvoid_t0ype
my_extern_prefix`'mpfr_mpfr_replace (REF(mpfr) yp, floatt2c(mpfr) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set (y[0], x[0], ROUNDING);
}

atsvoid_t0ype
_`'my_extern_prefix`'mpfr_intmax_replace (REF(mpfr) yp, intb2c(intmax) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_sj (y[0], x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_float_replace (REF(mpfr) yp, floatt2c(float) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_flt (y[0], x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_double_replace (REF(mpfr) yp, floatt2c(double) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_d (y[0], x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_ldouble_replace (REF(mpfr) yp, floatt2c(ldouble) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_ld (y[0], x, ROUNDING);
}

FLOAT_SUPPORT_CHECK_FOR_MPFR(`float128')
atsvoid_t0ype
my_extern_prefix`'mpfr_float128_replace (REF(mpfr) yp, floatt2c(float128) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_float128 (y[0], x, ROUNDING);
}
END_FLOAT_SUPPORT_CHECK_FOR_MPFR(`float128')

FLOAT_SUPPORT_CHECK_FOR_MPFR(`decimal64')
atsvoid_t0ype
my_extern_prefix`'mpfr_decimal64_replace (REF(mpfr) yp, floatt2c(decimal64) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_decimal64 (y[0], x, ROUNDING);
}
END_FLOAT_SUPPORT_CHECK_FOR_MPFR(`decimal64')

FLOAT_SUPPORT_CHECK_FOR_MPFR(`decimal128')
atsvoid_t0ype
my_extern_prefix`'mpfr_decimal128_replace (REF(mpfr) yp, floatt2c(decimal128) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_decimal128 (y[0], x, ROUNDING);
}
END_FLOAT_SUPPORT_CHECK_FOR_MPFR(`decimal128')

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
my_extern_prefix`'mpfr_exrat_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  floatt2c(mpfr) y = DEREF(mpfr, yp);
  mpfr_set_q (y[0], x[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'exrat_mpfr_replace (REF(mpfr) yp, floatt2c(mpfr) x)
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
  floatt2c(mpfr) z = DEREF(mpfr, zp);
  uintb2c(size) *j = (void *) jp;
  char *startptr = (char *) (void *) s + i;
  char *endptr;
  mpfr_strtofr (z[0], startptr, &endptr, 10, ROUNDING);
  *j = i + (uintb2c(size)) (endptr - startptr);
}

%}
(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:
dnl

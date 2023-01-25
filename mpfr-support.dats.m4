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

#define ATS_PACKNAME "ats2-xprelude.mpfr-support"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

#include "xprelude/HATS/xprelude_sats.hats"
staload "xprelude/SATS/mpfr.sats"

//staload "xprelude/SATS/fixed32p32.sats"
//staload _ = "xprelude/DATS/fixed32p32.dats"

%{

/*------------------------------------------------------------------*/

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

#undef DEREF_EXRAT
#define DEREF_EXRAT(x) `((('floatt2c(exrat)` *) (x))[0])'

#undef DEREF_MPFR
#define DEREF_MPFR(x) `((('floatt2c(mpfr)` *) (x))[0])'

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

my_extern_prefix`'mpfr
my_extern_prefix`'_mpfr_make_prec_uintmax (uintb2c(uintmax) prec)
{
  if (prec < MPFR_PREC_MIN)
    prec = MPFR_PREC_MIN;
  else if (prec > MPFR_PREC_MAX)
    prec = MPFR_PREC_MAX;
  return _`'my_extern_prefix`'mpfr_init2 ((mpfr_prec_t) prec);
}

/*------------------------------------------------------------------*/
/* Replacing a value. */

atsvoid_t0ype
my_extern_prefix`'mpfr_mpfr_replace (atstype_ref yp, floatt2c(mpfr) x)
{
  floatt2c(mpfr) y = DEREF_MPFR (yp);
  mpfr_set (y[0], x[0], ROUNDING);
}

atsvoid_t0ype
_`'my_extern_prefix`'mpfr_intmax_replace (atstype_ref yp, intb2c(intmax) x)
{
  floatt2c(mpfr) y = DEREF_MPFR (yp);
  mpfr_set_sj (y[0], x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_float_replace (atstype_ref yp, floatt2c(float) x)
{
  floatt2c(mpfr) y = DEREF_MPFR (yp);
  mpfr_set_flt (y[0], x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_double_replace (atstype_ref yp, floatt2c(double) x)
{
  floatt2c(mpfr) y = DEREF_MPFR (yp);
  mpfr_set_d (y[0], x, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_ldouble_replace (atstype_ref yp, floatt2c(ldouble) x)
{
  floatt2c(mpfr) y = DEREF_MPFR (yp);
  mpfr_set_ld (y[0], x, ROUNDING);
}

FLOAT_SUPPORT_CHECK_FOR_MPFR(`float128')
atsvoid_t0ype
my_extern_prefix`'mpfr_float128_replace (atstype_ref yp, floatt2c(float128) x)
{
  floatt2c(mpfr) y = DEREF_MPFR (yp);
  mpfr_set_float128 (y[0], x, ROUNDING);
}
END_FLOAT_SUPPORT_CHECK_FOR_MPFR(`float128')

FLOAT_SUPPORT_CHECK_FOR_MPFR(`decimal64')
atsvoid_t0ype
my_extern_prefix`'mpfr_decimal64_replace (atstype_ref yp, floatt2c(decimal64) x)
{
  floatt2c(mpfr) y = DEREF_MPFR (yp);
  mpfr_set_decimal64 (y[0], x, ROUNDING);
}
END_FLOAT_SUPPORT_CHECK_FOR_MPFR(`decimal64')

FLOAT_SUPPORT_CHECK_FOR_MPFR(`decimal128')
atsvoid_t0ype
my_extern_prefix`'mpfr_decimal128_replace (atstype_ref yp, floatt2c(decimal128) x)
{
  floatt2c(mpfr) y = DEREF_MPFR (yp);
  mpfr_set_decimal128 (y[0], x, ROUNDING);
}
END_FLOAT_SUPPORT_CHECK_FOR_MPFR(`decimal128')

atsvoid_t0ype
my_extern_prefix`'mpfr_fixed32p32_replace (atstype_ref yp, floatt2c(fixed32p32) x)
{
  floatt2c(mpfr) y = DEREF_MPFR (yp);
  mpfr_set_sj_2exp (y[0], x, -32, ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'mpfr_exrat_replace (atstype_ref yp, floatt2c(exrat) x)
{
  floatt2c(mpfr) y = DEREF_MPFR (yp);
  mpfr_set_q (y[0], x[0], ROUNDING);
}

atsvoid_t0ype
my_extern_prefix`'exrat_mpfr_replace (atstype_ref yp, floatt2c(mpfr) x)
{
  floatt2c(exrat) y = DEREF_EXRAT (yp);
  mpfr_get_q (y[0], x[0]);
}

/*------------------------------------------------------------------*/

%}

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:
dnl

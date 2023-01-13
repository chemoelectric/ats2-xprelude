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

#define ATS_PACKNAME "ats2-xprelude.exrat-support"
#define ATS_EXTERN_PREFIX "ats2_xprelude_"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload "xprelude/SATS/exrat.sats"

staload "xprelude/SATS/fixed32p32.sats"
staload _ = "xprelude/DATS/fixed32p32.dats"

%{

#include <assert.h>
#include <stdint.h>
#include <`inttypes'.h>
#include <limits.h>

static void *
ats2_xprelude_exrat_support_malloc (size_t alloc_size)
{
  return ATS_MALLOC (alloc_size);
}

static void *
ats2_xprelude_exrat_support_realloc (void *p,
                                          size_t old_size,
                                          size_t new_size)
{
  return ATS_REALLOC (p, new_size);
}

static void
ats2_xprelude_exrat_support_free (void *p, size_t size)
{
  return ATS_MFREE (p);
}

volatile atomic_int ats2_xprelude_exrat_support_is_initialized = 0;

/* Use unsigned integers, so they will wrap around when they
   overflow. */
static volatile atomic_size_t ats2_xprelude_exrat_initialization_active = 0;
static volatile atomic_size_t ats2_xprelude_exrat_initialization_available = 0;

#define ats2_xprelude_exrat_support_pause() \
  do { /* nothing */ } while (0)

#if defined __GNUC__ && (defined __i386__ || defined __x86_64__)
/* Similar things can be done for other platforms and other
   compilers. */
#undef ats2_xprelude_exrat_support_pause
#define ats2_xprelude_exrat_support_pause() __builtin_ia32_pause ()
#endif

ats2_xprelude_inline atsvoid_t0ype
ats2_xprelude_exrat_initialization_obtain_lock (void)
{
  size_t my_ticket =
    atomic_fetch_add_explicit (&ats2_xprelude_exrat_initialization_available,
                               1, memory_order_seq_cst);

  while (my_ticket != atomic_load_explicit (&ats2_xprelude_exrat_initialization_active,
                                            memory_order_seq_cst))
    ats2_xprelude_exrat_support_pause ();

  atomic_thread_fence (memory_order_seq_cst);
}

ats2_xprelude_inline atsvoid_t0ype
ats2_xprelude_exrat_initialization_release_lock (void)
{
  atomic_thread_fence (memory_order_seq_cst);
  (void) atomic_fetch_add_explicit (&ats2_xprelude_exrat_initialization_active,
                                    1, memory_order_seq_cst);
}

static ats2_xprelude_mpq_t _ats2_xprelude_exrat_zero;
static ats2_xprelude_mpq_t _ats2_xprelude_exrat_one;
static ats2_xprelude_mpq_t _ats2_xprelude_exrat_onehalf;

static ats2_xprelude_mpz_t _ats2_xprelude_two_raised_32;
static ats2_xprelude_mpq_t _ats2_xprelude_exrat_two_raised_32;

atsvoid_t0ype
ats2_xprelude_exrat_support_initialize (void)
{
  ats2_xprelude_exrat_initialization_obtain_lock ();
  if (!atomic_load_explicit (&ats2_xprelude_exrat_support_is_initialized,
                             memory_order_acquire))
    {
      mp_set_memory_functions (ats2_xprelude_exrat_support_malloc,
                               ats2_xprelude_exrat_support_realloc,
                               ats2_xprelude_exrat_support_free);

      mpq_init (_ats2_xprelude_exrat_zero);
      mpq_init (_ats2_xprelude_exrat_one);
      mpq_init (_ats2_xprelude_exrat_onehalf);
      mpq_set_si (_ats2_xprelude_exrat_one, 1, 1);
      mpq_set_si (_ats2_xprelude_exrat_onehalf, 1, 2);

      mpz_init (_ats2_xprelude_two_raised_32);
      mpq_init (_ats2_xprelude_exrat_two_raised_32);
      mpz_ui_pow_ui (_ats2_xprelude_two_raised_32, 2, 32);
      mpq_set_z (_ats2_xprelude_exrat_two_raised_32, _ats2_xprelude_two_raised_32);

      atomic_store_explicit (&ats2_xprelude_exrat_support_is_initialized,
                             1, memory_order_release);
    }
  ats2_xprelude_exrat_initialization_release_lock ();
}

static atsvoid_t0ype
_ats2_xprelude_fprint_exrat (FILE *outf, floatt2c(exrat) x)
{
  ats2_xprelude_exrat_one_time_initialization ();
  gmp_fprintf (outf, "%Qd", x);
}

atsvoid_t0ype
ats2_xprelude_fprint_exrat (atstype_ref fref, floatt2c(exrat) x)
{
  _ats2_xprelude_fprint_exrat ((FILE *) fref, x);
}

atsvoid_t0ype
ats2_xprelude_print_exrat (floatt2c(exrat) x)
{
  _ats2_xprelude_fprint_exrat (stdout, x);
}

atsvoid_t0ype
ats2_xprelude_prerr_exrat (floatt2c(exrat) x)
{
  _ats2_xprelude_fprint_exrat (stderr, x);
}

static ats2_xprelude_exrat
_ats2_xprelude_exrat_init (void)
{
  ats2_xprelude_exrat_one_time_initialization ();
  floatt2c(exrat) x = ATS_MALLOC (sizeof (ats2_xprelude_mpq_t));
  mpq_init (x[0]);
  return x;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_exrat_make_ulint_ulint (atstype_ulint n,
                                              atstype_ulint d)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpq_set_ui (y[0], n, d);
  mpq_canonicalize (y[0]);
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_exrat_make_lint_ulint (intb2c(lint) n,
                                             atstype_ulint d)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpq_set_si (y[0], n, d);
  mpq_canonicalize (y[0]);
  return y;
}

atsvoid_t0ype
ats2_xprelude__g0float_exrat_make_from_string (atstype_string s,
                                               atstype_int base,
                                               atstype_ref p_y,
                                               atstype_ref p_status)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  int status = mpq_set_str (y[0], (const char *) s, base);
  if (status == 0)
    mpq_canonicalize (y[0]);
  *(floatt2c(exrat) *) p_y = y;
  *(atstype_int *) p_status = status;
}

atstype_string
ats2_xprelude_tostrptr_exrat_given_base (floatt2c(exrat) x,
                                         int base)
{
  ats2_xprelude_exrat_one_time_initialization ();
  return mpq_get_str (NULL, base, x[0]);
}

atstype_string
ats2_xprelude_tostring_exrat_given_base (floatt2c(exrat) x,
                                         int base)
{
  return ats2_xprelude_tostrptr_exrat_given_base (x, base);
}

atstype_string
ats2_xprelude_tostrptr_exrat_base10 (floatt2c(exrat) x)
{
  return ats2_xprelude_tostrptr_exrat_given_base (x, 10);
}

atstype_string
ats2_xprelude_tostring_exrat_base10 (floatt2c(exrat) x)
{
  return ats2_xprelude_tostring_exrat_given_base (x, 10);
}

ats2_xprelude_exrat
ats2_xprelude_g0int2float_lint_exrat (intb2c(lint) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpq_set_si (y[0], x, 1);
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0int2float_int64_exrat_32bit (atstype_int64 x)
{
  ats2_xprelude_exrat_one_time_initialization ();
  floatt2c(exrat) y;

  /* We assume INT64_MIN < -INT64_MAX implies int64_t is
     two’s-complement. */

  if (INT64_MIN < -INT64_MAX && x == INT64_MIN)
    {
      y = _ats2_xprelude_exrat_init ();
      mpz_mul_2exp (mpq_numref (y[0]),
                    mpq_numref (_ats2_xprelude_exrat_one), 63);
      mpq_neg (y[0], y[0]);
    }
  else if (x < 0)
    {
      y = ats2_xprelude_g0int2float_int64_exrat_32bit (-x);
      mpq_neg (y[0], y[0]);
    }
  else
    {
      uint64_t x0 = (x & ((UINT64_C(1) << 31) - 1));
      uint64_t x1 = ((x >> 31) & ((UINT64_C(1) << 31) - 1));
      uint64_t x2 = (x >> 62);
      y = _ats2_xprelude_exrat_init ();
      mpq_set_ui (y[0], x1, 1);
      mpz_mul_2exp (mpq_numref (y[0]), mpq_numref (y[0]), 31);
      mpz_add_ui (mpq_numref (y[0]), mpq_numref (y[0]), x0);
      mpz_t y2;
      mpz_init (y2);
      mpz_set_ui (y2, x2);
      mpz_mul_2exp (y2, y2, 62);
      mpz_add (mpq_numref (y[0]), mpq_numref (y[0]), y2);
    }    
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0int2float_int64_exrat (atstype_int64 x)
{
  return (sizeof (intb2c(lint)) < sizeof (atstype_int64)) ?
    ats2_xprelude_g0int2float_int64_exrat_32bit (x) :
    ats2_xprelude_g0int2float_lint_exrat ((intb2c(lint)) x);
}

ats2_xprelude_exrat
ats2_xprelude_g0int2float_llint_exrat_32bit (intb2c(llint) x)
{
  ats2_xprelude_exrat_one_time_initialization ();
  floatt2c(exrat) y;

  _Static_assert (CHAR_BIT * sizeof (intb2c(llint)) <= (31 * 3) + 1,
                  "intb2c(llint) is longer than 94 bits");

  /* We assume LLONG_MIN < -LLONG_MAX implies long long int is
     two’s-complement. */

  if (LLONG_MIN < -LLONG_MAX && x == LLONG_MIN)
    {
      y = _ats2_xprelude_exrat_init ();
      mpz_mul_2exp (mpq_numref (y[0]),
                    mpq_numref (_ats2_xprelude_exrat_one),
                    (CHAR_BIT * sizeof (long long int)) - 1);
      mpq_neg (y[0], y[0]);
    }
  else if (x < 0)
    {
      y = ats2_xprelude_g0int2float_llint_exrat_32bit (-x);
      mpq_neg (y[0], y[0]);
    }
  else
    {
      uint64_t x0 = (x & ((UINT64_C(1) << 31) - 1));
      uint64_t x1 = ((x >> 31) & ((UINT64_C(1) << 31) - 1));
      uint64_t x2 = (x >> 62);
      y = _ats2_xprelude_exrat_init ();
      mpq_set_ui (y[0], x1, 1);
      mpz_mul_2exp (mpq_numref (y[0]), mpq_numref (y[0]), 31);
      mpz_add_ui (mpq_numref (y[0]), mpq_numref (y[0]), x0);
      mpz_t y2;
      mpz_init (y2);
      mpz_set_ui (y2, x2);
      mpz_mul_2exp (y2, y2, 62);
      mpz_add (mpq_numref (y[0]), mpq_numref (y[0]), y2);
    }    
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0int2float_llint_exrat (intb2c(llint) x)
{
  return (sizeof (intb2c(lint)) < sizeof (intb2c(llint))) ?
    ats2_xprelude_g0int2float_llint_exrat_32bit (x) :
    ats2_xprelude_g0int2float_lint_exrat ((intb2c(lint)) x);
}

ats2_xprelude_exrat
ats2_xprelude_g0int2float_intmax_exrat_32bit (intb2c(intmax) x)
{
  ats2_xprelude_exrat_one_time_initialization ();
  floatt2c(exrat) y;

  _Static_assert (CHAR_BIT * sizeof (intb2c(intmax)) <= (31 * 3) + 1,
                  "intb2c(intmax) is longer than 94 bits");

  /* We assume INTMAX_MIN < -INTMAX_MAX implies intmax_t is
     two’s-complement. */

  if (INTMAX_MIN < -INTMAX_MAX && x == INTMAX_MIN)
    {
      y = _ats2_xprelude_exrat_init ();
      mpz_mul_2exp (mpq_numref (y[0]),
                    mpq_numref (_ats2_xprelude_exrat_one),
                    (CHAR_BIT * sizeof (intb2c(intmax))) - 1);
      mpq_neg (y[0], y[0]);
    }
  else if (x < 0)
    {
      y = ats2_xprelude_g0int2float_intmax_exrat_32bit (-x);
      mpq_neg (y[0], y[0]);
    }
  else
    {
      uint64_t x0 = (x & ((UINT64_C(1) << 31) - 1));
      uint64_t x1 = ((x >> 31) & ((UINT64_C(1) << 31) - 1));
      uint64_t x2 = (x >> 62);
      y = _ats2_xprelude_exrat_init ();
      mpq_set_ui (y[0], x1, 1);
      mpz_mul_2exp (mpq_numref (y[0]), mpq_numref (y[0]), 31);
      mpz_add_ui (mpq_numref (y[0]), mpq_numref (y[0]), x0);
      mpz_t y2;
      mpz_init (y2);
      mpz_set_ui (y2, x2);
      mpz_mul_2exp (y2, y2, 62);
      mpz_add (mpq_numref (y[0]), mpq_numref (y[0]), y2);
    }    
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0int2float_intmax_exrat (intb2c(intmax) x)
{
  return (sizeof (intb2c(lint)) < sizeof (intb2c(intmax))) ?
    ats2_xprelude_g0int2float_intmax_exrat_32bit (x) :
    ats2_xprelude_g0int2float_lint_exrat ((intb2c(lint)) x);
}

intb2c(lint)
ats2_xprelude_g0float2int_exrat_lint (floatt2c(exrat) x)
{
  ats2_xprelude_exrat_one_time_initialization ();

  mpz_t tmp;
  mpz_init (tmp);

  mpz_tdiv_q (tmp, mpq_numref (x[0]), mpq_denref (x[0]));

  return mpz_get_si (tmp);
}

ats2_xprelude_exrat
ats2_xprelude_g0float2float_double_exrat (floatt2c(double) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpq_set_d (y[0], x);
  return y;
}

static inline ats2_xprelude_exrat
_ats2_xprelude_g0float2float_fixed32p32_exrat_32bit (ats2_xprelude_fixed32p32 x)
{
  /* FIXME: I am not certain what happens here if x has the most
            negative value. Note, though, that one may consider that
            value an overflow. */

  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();

  uint64_t z = (x < 0) ? -x : x;
  uint32_t z0 = (int32_t) (z & ((INT64_C(1) << 32) - 1));
  uint32_t z1 = (int32_t) (z >> 32);

  mpz_t tmp;
  mpz_init (tmp);

  mpz_mul_ui (tmp, _ats2_xprelude_two_raised_32, z1);
  mpz_add_ui (tmp, tmp, z0);

  mpq_set_z (y[0], tmp);
  mpq_div (y[0], y[0], _ats2_xprelude_exrat_two_raised_32);

  if (x < 0)
    mpq_neg (y[0], y[0]);

  return y;
}

static inline ats2_xprelude_exrat
_ats2_xprelude_g0float2float_fixed32p32_exrat_64bit (ats2_xprelude_fixed32p32 x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpq_set_si (y[0], x, 1);
  mpq_div (y[0], y[0], _ats2_xprelude_exrat_two_raised_32);
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0float2float_fixed32p32_exrat (ats2_xprelude_fixed32p32 x)
{
  return (sizeof (long int) < sizeof (int64_t)) ?
    _ats2_xprelude_g0float2float_fixed32p32_exrat_32bit (x) :
    _ats2_xprelude_g0float2float_fixed32p32_exrat_64bit (x);
}

/* ats2_xprelude_g0float2float_fixed32p32_exrat_32bit exists to provide
   testing coverage of the 32-bit support on 64-bit systems. */
ats2_xprelude_exrat
ats2_xprelude_g0float2float_fixed32p32_exrat_32bit (ats2_xprelude_fixed32p32 x)
{
  return _ats2_xprelude_g0float2float_fixed32p32_exrat_32bit (x);
}

floatt2c(double)
ats2_xprelude_g0float2float_exrat_double (floatt2c(exrat) x)
{
  ats2_xprelude_exrat_one_time_initialization ();
  return mpq_get_d (x[0]);
}

static inline ats2_xprelude_fixed32p32
_ats2_xprelude_g0float2float_exrat_fixed32p32_32bit (floatt2c(exrat) x)
{
  /* FIXME: I am not certain what happens here if x has the most
            negative fixed-point value. Note, though, that one may
            consider that value an overflow. */

  ats2_xprelude_exrat_one_time_initialization ();

  mpq_t tmp;
  mpq_init (tmp);

  mpq_mul (tmp, x[0], _ats2_xprelude_exrat_two_raised_32);

  int sign = mpq_sgn (tmp);
  if (sign < 0)
    mpq_neg (tmp, tmp);

  mpz_t z0;
  mpz_t z1;
  mpz_init (z0);
  mpz_init (z1);

  mpz_tdiv_qr (z1, z0, mpq_numref (tmp), _ats2_xprelude_two_raised_32);
  uint64_t y1 = (uint32_t) mpz_get_ui (z1);
  uint64_t y0 = (uint32_t) mpz_get_ui (z0);
  uint64_t y = (y1 << 32) | y0;

  return (sign < 0) ? -y : y;
}

static inline ats2_xprelude_fixed32p32
_ats2_xprelude_g0float2float_exrat_fixed32p32_64bit (floatt2c(exrat) x)
{
  ats2_xprelude_exrat_one_time_initialization ();

  mpq_t tmp;
  mpq_init (tmp);

  mpq_mul (tmp, x[0], _ats2_xprelude_exrat_two_raised_32);
  return (int64_t) mpz_get_si (mpq_numref (tmp));
}

ats2_xprelude_fixed32p32
ats2_xprelude_g0float2float_exrat_fixed32p32 (floatt2c(exrat) x)
{
  return (sizeof (long int) < sizeof (int64_t)) ?
    _ats2_xprelude_g0float2float_exrat_fixed32p32_32bit (x) :
    _ats2_xprelude_g0float2float_exrat_fixed32p32_64bit (x);
}

/* ats2_xprelude_g0float2float_exrat_fixed32p32_32bit exists to provide
   testing coverage of the 32-bit support on 64-bit systems. */
ats2_xprelude_fixed32p32
ats2_xprelude_g0float2float_exrat_fixed32p32_32bit (floatt2c(exrat) x)
{
  return _ats2_xprelude_g0float2float_exrat_fixed32p32_32bit (x);
}

ats2_xprelude_exrat
ats2_xprelude_g0float2float_ldouble_exrat (floatt2c(ldouble) x)
{
  /* FIXME: This implementation is quite bad. */

  char numeral[100];

  snprintf (numeral, sizeof numeral, "%La", x);

  char *p = numeral;

  int is_negative = (p[0] == '-');
  p += is_negative;

  /* Skip the "0x". */
  assert (strncmp (p, "0x", 2) == 0);
  p += 2;
  assert (isxdigit (p[0]));

  /* Find the "p". */
  char *q = p + 1;
  while (q[0] != 'p' && q[0] != '\0')
    q += 1;
  assert (q[0] == 'p');

  q[0] = '\0';
  q += 1;
  int exponent = atoi (q);

  /* Is there a radix point? If so, remove it. */
  int exponent16 = 0;
  if (p[1] != '\0' && !isxdigit (p[1]))
    {
      exponent16 = strlen (p) - 2;
      memmove (p + 1, p + 2, strlen (p) - 1);
    }

  floatt2c(exrat) mantissa = _ats2_xprelude_exrat_init ();
  floatt2c(exrat) radix = _ats2_xprelude_exrat_init ();
  floatt2c(exrat) sixteen = _ats2_xprelude_exrat_init ();

  mpq_set_str (mantissa[0], p, 16);
  if (is_negative)
    mpq_neg (mantissa[0], mantissa[0]);

  mpq_set_ui (radix[0], FLT_RADIX, 1);
  mpq_set_ui (sixteen[0], 16, 1);

  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  if (0 <= exponent)
    y = (ats2_xprelude_g0float_mul_exrat
            (mantissa,
             ats2_xprelude_g0float_npow_exrat (radix, exponent)));
  else
    y = (ats2_xprelude_g0float_div_exrat
            (mantissa,
             ats2_xprelude_g0float_npow_exrat (radix, -exponent)));
  if (exponent16 != 0)
    y = (ats2_xprelude_g0float_div_exrat
          (y, ats2_xprelude_g0float_npow_exrat (sixteen, exponent16)));

  return y;
}

floatt2c(ldouble)
ats2_xprelude_g0float2float_exrat_ldouble (floatt2c(exrat) x)
{
  /* FIXME: This implementation is quite bad. */

  mpf_t temp;
  mpf_init2 (temp, sizeof (floatt2c(ldouble)) * CHAR_BIT);

  mpf_set_q (temp, x[0]);

  mp_exp_t exponent;
  char *mantissa = mpf_get_str (NULL, &exponent, 16, 0, temp);
  size_t n = strlen (mantissa);

  char numeral[n + 10];

  if (mantissa[0] == '-')
    snprintf (numeral, sizeof numeral, "-0x0.%sp0", mantissa + 1);
  else
    snprintf (numeral, sizeof numeral, "0x0.%sp0", mantissa);

  return strtold (numeral, NULL) * exp2l (4 * exponent);
}

ats2_xprelude_exrat
ats2_xprelude_g0float_neg_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpq_neg (y[0], x[0]);
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_abs_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpq_abs (y[0], x[0]);
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_fabs_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpq_abs (y[0], x[0]);
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_succ_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpq_add (y[0], x[0], _ats2_xprelude_exrat_one);
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_pred_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpq_sub (y[0], x[0], _ats2_xprelude_exrat_one);
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_add_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  floatt2c(exrat) z = _ats2_xprelude_exrat_init ();
  mpq_add (z[0], x[0], y[0]);
  return z;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_sub_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  floatt2c(exrat) z = _ats2_xprelude_exrat_init ();
  mpq_sub (z[0], x[0], y[0]);
  return z;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_min_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  floatt2c(exrat) z = _ats2_xprelude_exrat_init ();
  int cmp = mpq_cmp (x[0], y[0]);
  if (cmp <= 0)
    mpq_set (z[0], x[0]);
  else
    mpq_set (z[0], y[0]);
  return z;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_max_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  floatt2c(exrat) z = _ats2_xprelude_exrat_init ();
  int cmp = mpq_cmp (x[0], y[0]);
  if (cmp >= 0)
    mpq_set (z[0], x[0]);
  else
    mpq_set (z[0], y[0]);
  return z;
}

atstype_bool
ats2_xprelude_g0float_eq_exrat (floatt2c(exrat) x,
                                floatt2c(exrat) y)
{
  ats2_xprelude_exrat_one_time_initialization ();
  return (mpq_equal (x[0], y[0])) ? atsbool_true : atsbool_false;
}

atstype_bool
ats2_xprelude_g0float_neq_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  ats2_xprelude_exrat_one_time_initialization ();
  return (!(mpq_equal (x[0], y[0]))) ? atsbool_true : atsbool_false;
}

atstype_bool
ats2_xprelude_g0float_lt_exrat (floatt2c(exrat) x,
                                floatt2c(exrat) y)
{
  ats2_xprelude_exrat_one_time_initialization ();
  return (mpq_cmp (x[0], y[0]) < 0) ? atsbool_true : atsbool_false;
}

atstype_bool
ats2_xprelude_g0float_lte_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  ats2_xprelude_exrat_one_time_initialization ();
  return (mpq_cmp (x[0], y[0]) <= 0) ? atsbool_true : atsbool_false;
}

atstype_bool
ats2_xprelude_g0float_gt_exrat (floatt2c(exrat) x,
                                floatt2c(exrat) y)
{
  ats2_xprelude_exrat_one_time_initialization ();
  return (mpq_cmp (x[0], y[0]) > 0) ? atsbool_true : atsbool_false;
}

atstype_bool
ats2_xprelude_g0float_gte_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  ats2_xprelude_exrat_one_time_initialization ();
  return (mpq_cmp (x[0], y[0]) >= 0) ? atsbool_true : atsbool_false;
}

atstype_int
ats2_xprelude_g0float_compare_exrat (floatt2c(exrat) x,
                                     floatt2c(exrat) y)
{
  ats2_xprelude_exrat_one_time_initialization ();
  return (mpq_cmp (x[0], y[0]));
}

ats2_xprelude_exrat
ats2_xprelude_g0float_mul_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  floatt2c(exrat) z = _ats2_xprelude_exrat_init ();
  mpq_mul (z[0], x[0], y[0]);
  return z;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_div_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  floatt2c(exrat) z = _ats2_xprelude_exrat_init ();
  mpq_div (z[0], x[0], y[0]);
  return z;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_fma_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y,
                                 floatt2c(exrat) z)
{
  floatt2c(exrat) w = _ats2_xprelude_exrat_init ();
  mpq_mul (w[0], x[0], y[0]);
  mpq_add (w[0], w[0], z[0]);
  return w;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_round_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();

  mpz_t tmp;
  mpz_init (tmp);
  
  mpq_t x1;
  mpq_init (x1);

  if (0 <= mpq_sgn (x[0]))
    mpq_add (x1, x[0], _ats2_xprelude_exrat_onehalf);
  else
    mpq_sub (x1, x[0], _ats2_xprelude_exrat_onehalf);

  mpz_tdiv_q (tmp, mpq_numref (x1), mpq_denref (x1));

  mpq_set_z (y[0], tmp);

  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_nearbyint_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();

  mpz_t tmp;
  mpz_init (tmp);

  mpq_t xfloor;
  mpq_init (xfloor);

  mpq_t xdiff;
  mpq_init (xdiff);

  mpz_fdiv_q (tmp, mpq_numref (x[0]), mpq_denref (x[0]));
  int xfloor_is_odd = mpz_tstbit (tmp, 0);
  mpq_set_z (xfloor, tmp);

  mpq_sub (xdiff, x[0], xfloor);
  int cmp = mpq_cmp (xdiff, _ats2_xprelude_exrat_onehalf);

  if (cmp < 0)
    mpq_set (y[0], xfloor);
  else if (cmp > 0)
    mpq_add (y[0], xfloor, _ats2_xprelude_exrat_one);
  else if (xfloor_is_odd)
    mpq_add (y[0], xfloor, _ats2_xprelude_exrat_one);
  else
    mpq_set (y[0], xfloor);

  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_floor_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();

  mpz_t tmp;
  mpz_init (tmp);

  mpz_fdiv_q (tmp, mpq_numref (x[0]), mpq_denref (x[0]));
  mpq_set_z (y[0], tmp);

  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_ceil_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();

  mpz_t tmp;
  mpz_init (tmp);

  mpz_cdiv_q (tmp, mpq_numref (x[0]), mpq_denref (x[0]));
  mpq_set_z (y[0], tmp);

  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_trunc_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();

  mpz_t tmp;
  mpz_init (tmp);

  mpz_tdiv_q (tmp, mpq_numref (x[0]), mpq_denref (x[0]));
  mpq_set_z (y[0], tmp);

  return y;
}

ats2_xprelude_exrat
ats2_xprelude_g0float_npow_exrat (floatt2c(exrat) x,
                                  atstype_int n)
{
  floatt2c(exrat) z = _ats2_xprelude_exrat_init ();

  assert (0 <= n);

  mpq_t y;
  mpq_init (y);
  mpq_set (y, x[0]);

  mpq_t ysquare;
  mpq_init (ysquare);

  mpq_t accum;
  mpq_init (accum);
  mpq_set (accum, _ats2_xprelude_exrat_one);

  while (2 <= n)
    {
      int nhalf = (n >> 1);
      mpq_mul (ysquare, y, y);
      if (nhalf + nhalf != n)
        mpq_mul (accum, accum, y);
      n = nhalf;
      mpq_set (y, ysquare);
    }
  if (n == 1)
    mpq_mul (accum, accum, y);

  mpq_set (z[0], accum);

  return z;
}

ats2_xprelude_exrat
ats2_xprelude_exrat_numerator (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpz_set (mpq_numref (y[0]), mpq_numref (x[0]));
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_exrat_denominator (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpz_set (mpq_numref (y[0]), mpq_denref (x[0]));
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_exrat_mul_exp2 (floatt2c(exrat) x, atstype_ulint i)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpq_mul_2exp (y[0], x[0], i);
  return y;
}

ats2_xprelude_exrat
ats2_xprelude_exrat_div_exp2 (floatt2c(exrat) x, atstype_ulint i)
{
  floatt2c(exrat) y = _ats2_xprelude_exrat_init ();
  mpq_div_2exp (y[0], x[0], i);
  return y;
}

%}

extern fn
_g0float_exrat_make_from_string
          (s      : string,
           base   : int,
           y      : &exrat? >> exrat,
           status : &int? >> int)
    :<> void = "mac#%"

implement
g0float_exrat_make_string_opt_given_base (s, base) =
  let
    var y : exrat
    var status : int
    val () = _g0float_exrat_make_from_string (s, base, y, status)
  in
    if iseqz status then
      Some y
    else
      None ()
  end

implement
g0float_exrat_make_string_exn_given_base (s, base) =
  let
    var y : exrat
    var status : int
    val () = _g0float_exrat_make_from_string (s, base, y, status)
  in
    if iseqz status then
      y
    else
      $raise IllegalArgExn
        "g0float_exrat_make_string_exn:illegal-string"
  end

implement
g0float_exrat_make_string_opt_base10 s =
  g0float_exrat_make_string_opt_given_base (s, 10)

implement
g0float_exrat_make_string_exn_base10 s =
  g0float_exrat_make_string_exn_given_base (s, 10)

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:
dnl

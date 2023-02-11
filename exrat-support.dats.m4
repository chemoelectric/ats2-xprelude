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
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload "xprelude/SATS/exrat.sats"

staload "xprelude/SATS/fixed32p32.sats"
staload _ = "xprelude/DATS/fixed32p32.dats"

(*------------------------------------------------------------------*)
%{
dnl------------------------------------------------------------------

#include <assert.h>
#include <stdint.h>
#include <`inttypes'.h>
#include <limits.h>

extern atsvoid_t0ype my_extern_prefix`'gmp_support_initialize (void);

#ifndef my_extern_prefix`'boolc2ats
#define my_extern_prefix`'boolc2ats(B) \
  ((B) ? (atsbool_true) : (atsbool_false))
#endif

volatile atomic_int my_extern_prefix`'exrat_support_is_initialized = 0;

/* Use unsigned integers, so they will wrap around when they
   overflow. */
static volatile atomic_size_t my_extern_prefix`'exrat_initialization_active = 0;
static volatile atomic_size_t my_extern_prefix`'exrat_initialization_available = 0;

#define my_extern_prefix`'exrat_support_pause() \
  do { /* nothing */ } while (0)

#if defined __GNUC__ && (defined __i386__ || defined __x86_64__)
/* Similar things can be done for other platforms and other
   compilers. */
#undef my_extern_prefix`'exrat_support_pause
#define my_extern_prefix`'exrat_support_pause() __builtin_ia32_pause ()
#endif

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'exrat_initialization_obtain_lock (void)
{
  size_t my_ticket =
    atomic_fetch_add_explicit (&my_extern_prefix`'exrat_initialization_available,
                               1, memory_order_seq_cst);

  while (my_ticket != atomic_load_explicit (&my_extern_prefix`'exrat_initialization_active,
                                            memory_order_seq_cst))
    my_extern_prefix`'exrat_support_pause ();

  atomic_thread_fence (memory_order_seq_cst);
}

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'exrat_initialization_release_lock (void)
{
  atomic_thread_fence (memory_order_seq_cst);
  (void) atomic_fetch_add_explicit (&my_extern_prefix`'exrat_initialization_active,
                                    1, memory_order_seq_cst);
}

static my_extern_prefix`'mpq_t _`'my_extern_prefix`'exrat_zero;
static my_extern_prefix`'mpq_t _`'my_extern_prefix`'exrat_one;
static my_extern_prefix`'mpq_t _`'my_extern_prefix`'exrat_onehalf;

static my_extern_prefix`'mpz_t _`'my_extern_prefix`'two_raised_32;
static my_extern_prefix`'mpq_t _`'my_extern_prefix`'exrat_two_raised_32;

atsvoid_t0ype
my_extern_prefix`'exrat_support_initialize (void)
{
  /* Initialize exrat support. A ticket-lock is used to ensure this
     initialization is done but once. */

  my_extern_prefix`'exrat_initialization_obtain_lock ();
  if (!atomic_load_explicit (&my_extern_prefix`'exrat_support_is_initialized,
                             memory_order_acquire))
    {
      my_extern_prefix`'gmp_support_initialize ();

      mpq_init (_`'my_extern_prefix`'exrat_zero);
      mpq_init (_`'my_extern_prefix`'exrat_one);
      mpq_init (_`'my_extern_prefix`'exrat_onehalf);
      mpq_set_si (_`'my_extern_prefix`'exrat_one, 1, 1);
      mpq_set_si (_`'my_extern_prefix`'exrat_onehalf, 1, 2);

      mpz_init (_`'my_extern_prefix`'two_raised_32);
      mpq_init (_`'my_extern_prefix`'exrat_two_raised_32);
      mpz_ui_pow_ui (_`'my_extern_prefix`'two_raised_32, 2, 32);
      mpq_set_z (_`'my_extern_prefix`'exrat_two_raised_32, _`'my_extern_prefix`'two_raised_32);

      atomic_store_explicit (&my_extern_prefix`'exrat_support_is_initialized,
                             1, memory_order_release);
    }
  my_extern_prefix`'exrat_initialization_release_lock ();
}

static atsvoid_t0ype
_`'my_extern_prefix`'fprint_exrat (FILE *outf, floatt2c(exrat) x)
{
  gmp_fprintf (outf, "%Qd", x[0]);
}

atsvoid_t0ype
my_extern_prefix`'fprint_exrat (atstype_ref fref, floatt2c(exrat) x)
{
  _`'my_extern_prefix`'fprint_exrat ((FILE *) fref, x);
}

atsvoid_t0ype
my_extern_prefix`'print_exrat (floatt2c(exrat) x)
{
  _`'my_extern_prefix`'fprint_exrat (stdout, x);
}

atsvoid_t0ype
my_extern_prefix`'prerr_exrat (floatt2c(exrat) x)
{
  _`'my_extern_prefix`'fprint_exrat (stderr, x);
}

static my_extern_prefix`'exrat
_`'my_extern_prefix`'exrat_init (void)
{
  my_extern_prefix`'exrat_one_time_initialization ();
  floatt2c(exrat) x = ATS_MALLOC (sizeof (my_extern_prefix`'mpq_t));
  mpq_init (x[0]);
  return x;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_exrat_make_ulint_ulint (atstype_ulint n,
                                                  atstype_ulint d)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  mpq_set_ui (y[0], n, d);
  mpq_canonicalize (y[0]);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_exrat_make_lint_ulint (intb2c(lint) n,
                                                 atstype_ulint d)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  mpq_set_si (y[0], n, d);
  mpq_canonicalize (y[0]);
  return y;
}

atsvoid_t0ype
my_extern_prefix`'_g0float_exrat_make_from_string (atstype_string s,
                                                   atstype_int base,
                                                   REF(exrat) p_y,
                                                   REF(int) p_status)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  int status = mpq_set_str (y[0], (const char *) s, base);
  if (status == 0)
    mpq_canonicalize (y[0]);
  *(floatt2c(exrat) *) p_y = y;
  *(atstype_int *) p_status = status;
}

atstype_string
my_extern_prefix`'tostrptr_exrat_given_base (floatt2c(exrat) x,
                                             int base)
{
  return mpq_get_str (NULL, base, x[0]);
}

atstype_string
my_extern_prefix`'tostring_exrat_given_base (floatt2c(exrat) x,
                                             int base)
{
  return my_extern_prefix`'tostrptr_exrat_given_base (x, base);
}

atstype_string
my_extern_prefix`'tostrptr_exrat_base10 (floatt2c(exrat) x)
{
  return my_extern_prefix`'tostrptr_exrat_given_base (x, 10);
}

atstype_string
my_extern_prefix`'tostring_exrat_base10 (floatt2c(exrat) x)
{
  return my_extern_prefix`'tostring_exrat_given_base (x, 10);
}

my_extern_prefix`'exrat
my_extern_prefix`'g0int2float_lint_exrat (intb2c(lint) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  if (x != 0)
    mpz_set_si (mpq_numref (y[0]), x);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0int2float_int64_exrat_32bit (atstype_int64 x)
{
  my_extern_prefix`'exrat_one_time_initialization ();
  floatt2c(exrat) y;

  /* We assume INT64_MIN < -INT64_MAX implies int64_t is
     two’s-complement. */

  if (INT64_MIN < -INT64_MAX && x == INT64_MIN)
    {
      y = _`'my_extern_prefix`'exrat_init ();
      mpz_mul_2exp (mpq_numref (y[0]),
                    mpq_numref (_`'my_extern_prefix`'exrat_one), 63);
      mpq_neg (y[0], y[0]);
    }
  else if (x < 0)
    {
      y = my_extern_prefix`'g0int2float_int64_exrat_32bit (-x);
      mpq_neg (y[0], y[0]);
    }
  else
    {
      uint64_t x0 = (x & ((UINT64_C(1) << 31) - 1));
      uint64_t x1 = ((x >> 31) & ((UINT64_C(1) << 31) - 1));
      uint64_t x2 = (x >> 62);
      y = _`'my_extern_prefix`'exrat_init ();
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

my_extern_prefix`'exrat
my_extern_prefix`'g0int2float_int64_exrat (atstype_int64 x)
{
  return (sizeof (intb2c(lint)) < sizeof (atstype_int64)) ?
    my_extern_prefix`'g0int2float_int64_exrat_32bit (x) :
    my_extern_prefix`'g0int2float_lint_exrat ((intb2c(lint)) x);
}

my_extern_prefix`'exrat
my_extern_prefix`'g0int2float_llint_exrat_32bit (intb2c(llint) x)
{
  my_extern_prefix`'exrat_one_time_initialization ();
  floatt2c(exrat) y;

  _Static_assert (CHAR_BIT * sizeof (intb2c(llint)) <= (31 * 3) + 1,
                  "intb2c(llint) is longer than 94 bits");

  /* We assume LLONG_MIN < -LLONG_MAX implies long long int is
     two’s-complement. */

  if (LLONG_MIN < -LLONG_MAX && x == LLONG_MIN)
    {
      y = _`'my_extern_prefix`'exrat_init ();
      mpz_mul_2exp (mpq_numref (y[0]),
                    mpq_numref (_`'my_extern_prefix`'exrat_one),
                    (CHAR_BIT * sizeof (long long int)) - 1);
      mpq_neg (y[0], y[0]);
    }
  else if (x < 0)
    {
      y = my_extern_prefix`'g0int2float_llint_exrat_32bit (-x);
      mpq_neg (y[0], y[0]);
    }
  else
    {
      uint64_t x0 = (x & ((UINT64_C(1) << 31) - 1));
      uint64_t x1 = ((x >> 31) & ((UINT64_C(1) << 31) - 1));
      uint64_t x2 = (x >> 62);
      y = _`'my_extern_prefix`'exrat_init ();
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

my_extern_prefix`'exrat
my_extern_prefix`'g0int2float_llint_exrat (intb2c(llint) x)
{
  return (sizeof (intb2c(lint)) < sizeof (intb2c(llint))) ?
    my_extern_prefix`'g0int2float_llint_exrat_32bit (x) :
    my_extern_prefix`'g0int2float_lint_exrat ((intb2c(lint)) x);
}

my_extern_prefix`'exrat
my_extern_prefix`'g0int2float_intmax_exrat_32bit (intb2c(intmax) x)
{
  my_extern_prefix`'exrat_one_time_initialization ();
  floatt2c(exrat) y;

  _Static_assert (CHAR_BIT * sizeof (intb2c(intmax)) <= (31 * 3) + 1,
                  "intb2c(intmax) is longer than 94 bits");

  /* We assume INTMAX_MIN < -INTMAX_MAX implies intmax_t is
     two’s-complement. */

  if (INTMAX_MIN < -INTMAX_MAX && x == INTMAX_MIN)
    {
      y = _`'my_extern_prefix`'exrat_init ();
      mpz_mul_2exp (mpq_numref (y[0]),
                    mpq_numref (_`'my_extern_prefix`'exrat_one),
                    (CHAR_BIT * sizeof (intb2c(intmax))) - 1);
      mpq_neg (y[0], y[0]);
    }
  else if (x < 0)
    {
      y = my_extern_prefix`'g0int2float_intmax_exrat_32bit (-x);
      mpq_neg (y[0], y[0]);
    }
  else
    {
      uint64_t x0 = (x & ((UINT64_C(1) << 31) - 1));
      uint64_t x1 = ((x >> 31) & ((UINT64_C(1) << 31) - 1));
      uint64_t x2 = (x >> 62);
      y = _`'my_extern_prefix`'exrat_init ();
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

my_extern_prefix`'exrat
my_extern_prefix`'g0int2float_intmax_exrat (intb2c(intmax) x)
{
  return (sizeof (intb2c(lint)) < sizeof (intb2c(intmax))) ?
    my_extern_prefix`'g0int2float_intmax_exrat_32bit (x) :
    my_extern_prefix`'g0int2float_lint_exrat ((intb2c(lint)) x);
}

intb2c(lint)
my_extern_prefix`'g0float2int_exrat_lint (floatt2c(exrat) x)
{
  mpz_t tmp;
  mpz_init (tmp);

  mpz_tdiv_q (tmp, mpq_numref (x[0]), mpq_denref (x[0]));

  return mpz_get_si (tmp);
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float2float_double_exrat (floatt2c(double) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  mpq_set_d (y[0], x);
  return y;
}

static inline my_extern_prefix`'exrat
_`'my_extern_prefix`'g0float2float_fixed32p32_exrat_32bit (my_extern_prefix`'fixed32p32 x)
{
  /* FIXME: I am not certain what happens here if x has the most
            negative value. Note, though, that one may consider that
            value an overflow. */

  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();

  uint64_t z = (x < 0) ? -x : x;
  uint32_t z0 = (int32_t) (z & ((INT64_C(1) << 32) - 1));
  uint32_t z1 = (int32_t) (z >> 32);

  mpz_t tmp;
  mpz_init (tmp);

  mpz_mul_ui (tmp, _`'my_extern_prefix`'two_raised_32, z1);
  mpz_add_ui (tmp, tmp, z0);

  mpq_set_z (y[0], tmp);
  mpq_div (y[0], y[0], _`'my_extern_prefix`'exrat_two_raised_32);

  if (x < 0)
    mpq_neg (y[0], y[0]);

  return y;
}

static inline my_extern_prefix`'exrat
_`'my_extern_prefix`'g0float2float_fixed32p32_exrat_64bit (my_extern_prefix`'fixed32p32 x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  mpq_set_si (y[0], x, 1);
  mpq_div (y[0], y[0], _`'my_extern_prefix`'exrat_two_raised_32);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float2float_fixed32p32_exrat (my_extern_prefix`'fixed32p32 x)
{
  return (sizeof (long int) < sizeof (int64_t)) ?
    _`'my_extern_prefix`'g0float2float_fixed32p32_exrat_32bit (x) :
    _`'my_extern_prefix`'g0float2float_fixed32p32_exrat_64bit (x);
}

/* my_extern_prefix`'g0float2float_fixed32p32_exrat_32bit exists to provide
   testing coverage of the 32-bit support on 64-bit systems. */
my_extern_prefix`'exrat
my_extern_prefix`'g0float2float_fixed32p32_exrat_32bit (my_extern_prefix`'fixed32p32 x)
{
  return _`'my_extern_prefix`'g0float2float_fixed32p32_exrat_32bit (x);
}

floatt2c(double)
my_extern_prefix`'g0float2float_exrat_double (floatt2c(exrat) x)
{
  return mpq_get_d (x[0]);
}

static inline my_extern_prefix`'fixed32p32
_`'my_extern_prefix`'g0float2float_exrat_fixed32p32_32bit (floatt2c(exrat) x)
{
  /* FIXME: I am not certain what happens here if x has the most
            negative fixed-point value. Note, though, that one may
            consider that value an overflow. */

  mpq_t tmp;
  mpq_init (tmp);

  mpq_mul (tmp, x[0], _`'my_extern_prefix`'exrat_two_raised_32);

  int sign = mpq_sgn (tmp);
  if (sign < 0)
    mpq_neg (tmp, tmp);

  mpz_t z0;
  mpz_t z1;
  mpz_init (z0);
  mpz_init (z1);

  mpz_tdiv_qr (z1, z0, mpq_numref (tmp), _`'my_extern_prefix`'two_raised_32);
  uint64_t y1 = (uint32_t) mpz_get_ui (z1);
  uint64_t y0 = (uint32_t) mpz_get_ui (z0);
  uint64_t y = (y1 << 32) | y0;

  return (sign < 0) ? -y : y;
}

static inline my_extern_prefix`'fixed32p32
_`'my_extern_prefix`'g0float2float_exrat_fixed32p32_64bit (floatt2c(exrat) x)
{
  mpq_t tmp;
  mpq_init (tmp);

  mpq_mul (tmp, x[0], _`'my_extern_prefix`'exrat_two_raised_32);
  return (int64_t) mpz_get_si (mpq_numref (tmp));
}

my_extern_prefix`'fixed32p32
my_extern_prefix`'g0float2float_exrat_fixed32p32 (floatt2c(exrat) x)
{
  return (sizeof (long int) < sizeof (int64_t)) ?
    _`'my_extern_prefix`'g0float2float_exrat_fixed32p32_32bit (x) :
    _`'my_extern_prefix`'g0float2float_exrat_fixed32p32_64bit (x);
}

/* my_extern_prefix`'g0float2float_exrat_fixed32p32_32bit exists to provide
   testing coverage of the 32-bit support on 64-bit systems. */
my_extern_prefix`'fixed32p32
my_extern_prefix`'g0float2float_exrat_fixed32p32_32bit (floatt2c(exrat) x)
{
  return _`'my_extern_prefix`'g0float2float_exrat_fixed32p32_32bit (x);
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float2float_ldouble_exrat (floatt2c(ldouble) x)
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

  floatt2c(exrat) mantissa = _`'my_extern_prefix`'exrat_init ();
  floatt2c(exrat) radix = _`'my_extern_prefix`'exrat_init ();
  floatt2c(exrat) sixteen = _`'my_extern_prefix`'exrat_init ();

  mpq_set_str (mantissa[0], p, 16);
  if (is_negative)
    mpq_neg (mantissa[0], mantissa[0]);

  mpq_set_ui (radix[0], FLT_RADIX, 1);
  mpq_set_ui (sixteen[0], 16, 1);

  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  if (0 <= exponent)
    y = (my_extern_prefix`'g0float_mul_exrat
            (mantissa,
             my_extern_prefix`'g0float_npow_exrat (radix, exponent)));
  else
    y = (my_extern_prefix`'g0float_div_exrat
            (mantissa,
             my_extern_prefix`'g0float_npow_exrat (radix, -exponent)));
  if (exponent16 != 0)
    y = (my_extern_prefix`'g0float_div_exrat
          (y, my_extern_prefix`'g0float_npow_exrat (sixteen, exponent16)));

  return y;
}

floatt2c(ldouble)
my_extern_prefix`'g0float2float_exrat_ldouble (floatt2c(exrat) x)
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

my_extern_prefix`'exrat
my_extern_prefix`'g0float_neg_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  mpq_neg (y[0], x[0]);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_reciprocal_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  mpq_inv (y[0], x[0]);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_abs_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  mpq_abs (y[0], x[0]);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_fabs_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  mpq_abs (y[0], x[0]);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_succ_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  mpq_add (y[0], x[0], _`'my_extern_prefix`'exrat_one);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_pred_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  mpq_sub (y[0], x[0], _`'my_extern_prefix`'exrat_one);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_add_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  mpq_add (z[0], x[0], y[0]);
  return z;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_sub_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  mpq_sub (z[0], x[0], y[0]);
  return z;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_min_exrat (floatt2c(exrat) x,
                                     floatt2c(exrat) y)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  my_extern_prefix`'exrat_min_replace (&z, x, y);
  return z;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_max_exrat (floatt2c(exrat) x,
                                     floatt2c(exrat) y)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  my_extern_prefix`'exrat_max_replace (&z, x, y);
  return z;
}

atstype_bool
my_extern_prefix`'g0float_eq_exrat (floatt2c(exrat) x,
                                    floatt2c(exrat) y)
{
  return my_extern_prefix`'boolc2ats (mpq_equal (x[0], y[0]));
}

atstype_bool
my_extern_prefix`'g0float_neq_exrat (floatt2c(exrat) x,
                                     floatt2c(exrat) y)
{
  return my_extern_prefix`'boolc2ats (!(mpq_equal (x[0], y[0])));
}

atstype_bool
my_extern_prefix`'g0float_lt_exrat (floatt2c(exrat) x,
                                    floatt2c(exrat) y)
{
  return my_extern_prefix`'boolc2ats (mpq_cmp (x[0], y[0]) < 0);
}

atstype_bool
my_extern_prefix`'g0float_lte_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  return my_extern_prefix`'boolc2ats (mpq_cmp (x[0], y[0]) <= 0);
}

atstype_bool
my_extern_prefix`'g0float_gt_exrat (floatt2c(exrat) x,
                                floatt2c(exrat) y)
{
  return my_extern_prefix`'boolc2ats (mpq_cmp (x[0], y[0]) > 0);
}

atstype_bool
my_extern_prefix`'g0float_gte_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  return my_extern_prefix`'boolc2ats (mpq_cmp (x[0], y[0]) >= 0);
}

atstype_int
my_extern_prefix`'g0float_compare_exrat (floatt2c(exrat) x,
                                     floatt2c(exrat) y)
{
  return (mpq_cmp (x[0], y[0]));
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_mul_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  mpq_mul (z[0], x[0], y[0]);
  return z;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_div_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  mpq_div (z[0], x[0], y[0]);
  return z;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_fma_exrat (floatt2c(exrat) x,
                                 floatt2c(exrat) y,
                                 floatt2c(exrat) z)
{
  floatt2c(exrat) w = _`'my_extern_prefix`'exrat_init ();
  mpq_mul (w[0], x[0], y[0]);
  mpq_add (w[0], w[0], z[0]);
  return w;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_round_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  my_extern_prefix`'exrat_round_replace (&y, x);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_nearbyint_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  my_extern_prefix`'exrat_nearbyint_replace (&y, x);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_floor_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  my_extern_prefix`'exrat_floor_replace (&y, x);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_ceil_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  my_extern_prefix`'exrat_ceil_replace (&y, x);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_trunc_exrat (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  my_extern_prefix`'exrat_trunc_replace (&y, x);
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'g0float_npow_exrat (floatt2c(exrat) x,
                                      intb2c(int) n)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  my_extern_prefix`'exrat_npow_replace (&z, x, n);
  return z;
}

my_extern_prefix`'exrat
my_extern_prefix`'_g0float_intmax_pow_exrat (floatt2c(exrat) x,
                                             intb2c(intmax) n)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  my_extern_prefix`'exrat_intmax_pow_replace (&z, x, n);
  return z;
}

my_extern_prefix`'exrat
my_extern_prefix`'exrat_numerator (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  mpz_set (mpq_numref (y[0]), mpq_numref (x[0]));
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'exrat_denominator (floatt2c(exrat) x)
{
  floatt2c(exrat) y = _`'my_extern_prefix`'exrat_init ();
  mpz_set (mpq_numref (y[0]), mpq_denref (x[0]));
  return y;
}

my_extern_prefix`'exrat
my_extern_prefix`'_g0float_mul_2exp_intmax_exrat (floatt2c(exrat) x, intb2c(intmax) n)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  my_extern_prefix`'exrat_mul_2exp_intmax_replace (&z, x, n);
  return z;
}


floatt2c(exrat)
my_extern_prefix`'exrat_numerator_root (floatt2c(exrat) x, intb2c(ulint) i)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  mpz_root (mpq_numref (z[0]), mpq_numref (x[0]), i);
  return z;
}

floatt2c(exrat)
my_extern_prefix`'exrat_numerator_sqrt (floatt2c(exrat) x)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  mpz_sqrt (mpq_numref (z[0]), mpq_numref (x[0]));
  return z;
}

atsvoid_t0ype
my_extern_prefix`'_exrat_numerator_rootrem (REF(exrat) qp, REF(exrat) rp,
                                            floatt2c(exrat) x, intb2c(ulint) n)
{
  floatt2c(exrat) q = DEREF(exrat, qp);
  floatt2c(exrat) r = DEREF(exrat, rp);
  mpz_rootrem (mpq_numref (q[0]), mpq_numref (r[0]),
               mpq_numref (x[0]), n);
}

atsvoid_t0ype
my_extern_prefix`'_exrat_numerator_sqrtrem (REF(exrat) qp, REF(exrat) rp,
                                            floatt2c(exrat) x)
{
  floatt2c(exrat) q = DEREF(exrat, qp);
  floatt2c(exrat) r = DEREF(exrat, rp);
  mpz_sqrtrem (mpq_numref (q[0]), mpq_numref (r[0]),
               mpq_numref (x[0]));
}

floatt2c(exrat)
my_extern_prefix`'exrat_numerator_gcd (floatt2c(exrat) x, floatt2c(exrat) y)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  mpz_gcd (mpq_numref (z[0]), mpq_numref (x[0]), mpq_numref (y[0]));
  return z;
}

floatt2c(exrat)
my_extern_prefix`'exrat_numerator_lcm (floatt2c(exrat) x, floatt2c(exrat) y)
{
  floatt2c(exrat) z = _`'my_extern_prefix`'exrat_init ();
  mpz_lcm (mpq_numref (z[0]), mpq_numref (x[0]), mpq_numref (y[0]));
  return z;
}

floatt2c(exrat)
my_extern_prefix`'_exrat_numerator_gcdext (REF(exrat) gp, REF(exrat) sp, REF(exrat) tp,
                                           floatt2c(exrat) a, floatt2c(exrat) b)
{
  floatt2c(exrat) g = DEREF(exrat, gp);
  floatt2c(exrat) s = DEREF(exrat, sp);
  floatt2c(exrat) t = DEREF(exrat, tp);
  mpz_gcdext (mpq_numref (g[0]), mpq_numref (s[0]), mpq_numref (t[0]),
              mpq_numref (a[0]), mpq_numref (b[0]));
}

atsvoid_t0ype
my_extern_prefix`'_exrat_numerator_modular_inverse (REF(bool) successp, REF(exrat) zp,
                                                    floatt2c(exrat) x, floatt2c(exrat) y)
{
  atstype_bool *success = (void *) successp;
  floatt2c(exrat) z = DEREF(exrat, zp);
  if (mpz_sgn (mpq_numref (y[0])) == 0)
    *success = atsbool_false;
  else
    *success = (mpz_invert (mpq_numref (z[0]), mpq_numref (x[0]), mpq_numref (y[0])) != 0);
}

atsvoid_t0ype
my_extern_prefix`'_exrat_numerator_remove_factor (REF(exrat) zp, REF(uintmax) np,
                                                  floatt2c(exrat) x, floatt2c(exrat) y)
{
  floatt2c(exrat) z = DEREF(exrat, zp);
  uintb2c(uintmax) *n = (void *) np;
  *n = mpz_remove (mpq_numref (z[0]), mpq_numref (x[0]), mpq_numref (y[0]));
}

/*------------------------------------------------------------------*/
/* Value-replacement. */

atsvoid_t0ype
my_extern_prefix`'exrat_exrat_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);
  mpq_set (y[0], x[0]);
}

atsvoid_t0ype
my_extern_prefix`'exrat_exchange (REF(exrat) yp, REF(exrat) xp)
{
  floatt2c(exrat) y = DEREF(exrat, yp);
  floatt2c(exrat) x = DEREF(exrat, xp);
  mpq_swap (y[0], x[0]);
}

atsvoid_t0ype
my_extern_prefix`'exrat_lint_replace (REF(exrat) yp, floatt2c(lint) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);
  mpq_set_si (y[0], x, 1);
}

atsvoid_t0ype
my_extern_prefix`'exrat_double_replace (REF(exrat) yp, floatt2c(double) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);
  mpq_set_d (y[0], x);
}

m4_foreachq(FLT1,`float,double',`
atsvoid_t0ype
my_extern_prefix`'FLT1`'_exrat_replace (REF(FLT1) yp, floatt2c(exrat) x)
{
  floatt2c(FLT1) *y = (void *) yp;
  *y = my_extern_prefix`'g0float2float_exrat_`'FLT1 (x);
}
')dnl

m4_foreachq(`OP',`abs, neg',`
atsvoid_t0ype
my_extern_prefix`'exrat_`'OP`'_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);
  mpq_`'OP (y[0], x[0]);
}
')dnl

atsvoid_t0ype
my_extern_prefix`'exrat_fabs_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  my_extern_prefix`'exrat_abs_replace (yp, x);
}

atsvoid_t0ype
my_extern_prefix`'exrat_reciprocal_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);
  mpq_inv (y[0], x[0]);
}

atsvoid_t0ype
my_extern_prefix`'exrat_succ_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);
  mpq_add (y[0], x[0], _`'my_extern_prefix`'exrat_one);
}

atsvoid_t0ype
my_extern_prefix`'exrat_pred_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);
  mpq_sub (y[0], x[0], _`'my_extern_prefix`'exrat_one);
}

m4_foreachq(`OP',`add, sub, mul, div',`
atsvoid_t0ype
my_extern_prefix`'exrat_`'OP`'_replace (REF(exrat) zp,
                                        floatt2c(exrat) x,
                                        floatt2c(exrat) y)
{
  floatt2c(exrat) z = DEREF(exrat, zp);
  mpq_`'OP (z[0], x[0], y[0]);
}
')dnl

atsvoid_t0ype
my_extern_prefix`'exrat_min_replace (REF(exrat) zp,
                                     floatt2c(exrat) x,
                                     floatt2c(exrat) y)
{
  floatt2c(exrat) z = DEREF(exrat, zp);
  int cmp = mpq_cmp (x[0], y[0]);
  if (cmp <= 0)
    mpq_set (z[0], x[0]);
  else
    mpq_set (z[0], y[0]);
}

atsvoid_t0ype
my_extern_prefix`'exrat_max_replace (REF(exrat) zp,
                                     floatt2c(exrat) x,
                                     floatt2c(exrat) y)
{
  floatt2c(exrat) z = DEREF(exrat, zp);
  int cmp = mpq_cmp (x[0], y[0]);
  if (cmp >= 0)
    mpq_set (z[0], x[0]);
  else
    mpq_set (z[0], y[0]);
}

m4_foreachq(`OP',`fma',`
atsvoid_t0ype
my_extern_prefix`'exrat_`'OP`'_replace (REF(exrat) wp,
                                        floatt2c(exrat) x,
                                        floatt2c(exrat) y,
                                        floatt2c(exrat) z)
{
  floatt2c(exrat) w = DEREF(exrat, wp);
  mpq_mul (w[0], x[0], y[0]);
  mpq_add (w[0], w[0], z[0]);
}
')dnl

atsvoid_t0ype
my_extern_prefix`'exrat_round_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);

  mpz_t tmp;
  mpz_init (tmp);
  
  mpq_t x1;
  mpq_init (x1);

  if (0 <= mpq_sgn (x[0]))
    mpq_add (x1, x[0], _`'my_extern_prefix`'exrat_onehalf);
  else
    mpq_sub (x1, x[0], _`'my_extern_prefix`'exrat_onehalf);

  mpz_tdiv_q (tmp, mpq_numref (x1), mpq_denref (x1));

  mpq_set_z (y[0], tmp);
}

atsvoid_t0ype
my_extern_prefix`'exrat_nearbyint_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);

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
  int cmp = mpq_cmp (xdiff, _`'my_extern_prefix`'exrat_onehalf);

  if (cmp < 0)
    mpq_set (y[0], xfloor);
  else if (cmp > 0)
    mpq_add (y[0], xfloor, _`'my_extern_prefix`'exrat_one);
  else if (xfloor_is_odd)
    mpq_add (y[0], xfloor, _`'my_extern_prefix`'exrat_one);
  else
    mpq_set (y[0], xfloor);
}

atsvoid_t0ype
my_extern_prefix`'exrat_rint_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  my_extern_prefix`'exrat_nearbyint_replace (yp, x);
}

atsvoid_t0ype
my_extern_prefix`'exrat_floor_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);

  mpz_t tmp;
  mpz_init (tmp);

  mpz_fdiv_q (tmp, mpq_numref (x[0]), mpq_denref (x[0]));
  mpq_set_z (y[0], tmp);
}

atsvoid_t0ype
my_extern_prefix`'exrat_ceil_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);

  mpz_t tmp;
  mpz_init (tmp);

  mpz_cdiv_q (tmp, mpq_numref (x[0]), mpq_denref (x[0]));
  mpq_set_z (y[0], tmp);
}

atsvoid_t0ype
my_extern_prefix`'exrat_trunc_replace (REF(exrat) yp, floatt2c(exrat) x)
{
  floatt2c(exrat) y = DEREF(exrat, yp);

  mpz_t tmp;
  mpz_init (tmp);

  mpz_tdiv_q (tmp, mpq_numref (x[0]), mpq_denref (x[0]));
  mpq_set_z (y[0], tmp);
}

atsvoid_t0ype
my_extern_prefix`'exrat_npow_replace (REF(exrat) zp,
                                      floatt2c(exrat) x,
                                      intb2c(int) n)
{
  assert (0 <= n);

  floatt2c(exrat) z = DEREF(exrat, zp);

  mpq_t y;
  mpq_init (y);
  mpq_set (y, x[0]);

  mpq_t ysquare;
  mpq_init (ysquare);

  mpq_t accum;
  mpq_init (accum);
  mpq_set (accum, _`'my_extern_prefix`'exrat_one);

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
}

atsvoid_t0ype
my_extern_prefix`'exrat_intmax_pow_replace (REF(exrat) zp,
                                            floatt2c(exrat) x,
                                            intb2c(intmax) n)
{
  floatt2c(exrat) z = DEREF(exrat, zp);

  mpq_t y;
  mpq_init (y);
  if (0 <= n)
    mpq_set (y, x[0]);
  else
    {
      n = -n;
      mpq_inv (y, x[0]);
    }

  mpq_t ysquare;
  mpq_init (ysquare);

  mpq_t accum;
  mpq_init (accum);
  mpq_set (accum, _`'my_extern_prefix`'exrat_one);

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
}

atsvoid_t0ype
my_extern_prefix`'exrat_mul_2exp_intmax_replace (REF(exrat) zp,
                                                 floatt2c(exrat) x,
                                                 intb2c(intmax) n)
{
  floatt2c(exrat) z = DEREF(exrat, zp);
  if (0 <= n)
    mpq_mul_2exp (z[0], x[0], (mp_bitcnt_t) n);
  else
    mpq_div_2exp (z[0], x[0], (mp_bitcnt_t) -n);
}

dnl------------------------------------------------------------------
%}
(*------------------------------------------------------------------*)

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

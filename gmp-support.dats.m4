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

#define ATS_PACKNAME "ats2-xprelude.gmp-support"
#define ATS_EXTERN_PREFIX "my_extern_prefix"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

%{#
#include <stdatomic.h>
#include <gmp.h>
%}

(*------------------------------------------------------------------*)

%{

my_extern_prefix`'function_malloc static void *
my_extern_prefix`'gmp_support_malloc (size_t alloc_size)
{
  return ATS_MALLOC (alloc_size);
}

static void *
my_extern_prefix`'gmp_support_realloc (void *p,
                                          size_t old_size,
                                          size_t new_size)
{
  return ATS_REALLOC (p, new_size);
}

static void
my_extern_prefix`'gmp_support_free (void *p, size_t size)
{
  return ATS_MFREE (p);
}

volatile atomic_int my_extern_prefix`'gmp_support_is_initialized = 0;

atsvoid_t0ype
my_extern_prefix`'mark_gmp_initialized (void)
{
  my_extern_prefix`'gmp_support_is_initialized = 1;
}

/* Use unsigned integers, so they will wrap around when they
   overflow. */
static volatile atomic_size_t my_extern_prefix`'gmp_initialization_active = 0;
static volatile atomic_size_t my_extern_prefix`'gmp_initialization_available = 0;

#define my_extern_prefix`'gmp_support_pause() \
  do { /* nothing */ } while (0)

#if defined __GNUC__ && (defined __i386__ || defined __x86_64__)
/* Similar things can be done for other platforms and other
   compilers. */
#undef my_extern_prefix`'gmp_support_pause
#define my_extern_prefix`'gmp_support_pause() __builtin_ia32_pause ()
#endif

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'gmp_initialization_obtain_lock (void)
{
  size_t my_ticket =
    atomic_fetch_add_explicit (&my_extern_prefix`'gmp_initialization_available,
                               1, memory_order_seq_cst);

  while (my_ticket != atomic_load_explicit (&my_extern_prefix`'gmp_initialization_active,
                                            memory_order_seq_cst))
    my_extern_prefix`'gmp_support_pause ();

  atomic_thread_fence (memory_order_seq_cst);
}

my_extern_prefix`'inline atsvoid_t0ype
my_extern_prefix`'gmp_initialization_release_lock (void)
{
  atomic_thread_fence (memory_order_seq_cst);
  (void) atomic_fetch_add_explicit (&my_extern_prefix`'gmp_initialization_active,
                                    1, memory_order_seq_cst);
}

atsvoid_t0ype
my_extern_prefix`'gmp_support_initialize (void)
{
  /* Set the memory allocation for GMP, to whatever the ATS program is
     compiled to use. A ticket-lock is used to ensure this
     initialization is done but once. */

  my_extern_prefix`'gmp_initialization_obtain_lock ();
  if (!atomic_load_explicit (&my_extern_prefix`'gmp_support_is_initialized,
                             memory_order_acquire))
    {
      mp_set_memory_functions (my_extern_prefix`'gmp_support_malloc,
                               my_extern_prefix`'gmp_support_realloc,
                               my_extern_prefix`'gmp_support_free);

      atomic_store_explicit (&my_extern_prefix`'gmp_support_is_initialized,
                             1, memory_order_release);
    }
  my_extern_prefix`'gmp_initialization_release_lock ();
}

%}

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:
dnl

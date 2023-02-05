(*
  Copyright © 2022, 2023 Barry Schwartz

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

#define ATS_PACKNAME "ats2-xprelude.fixed32p32_square_root"
#define ATS_EXTERN_PREFIX "my_extern_prefix`'fixed32p32_square_root_"

#include "share/atspre_staload.hats"
#include "xprelude/HATS/xprelude.hats"

staload "xprelude/SATS/fixed32p32.sats"
staload _ = "xprelude/DATS/fixed32p32.dats"

(*------------------------------------------------------------------*)

%{^

#include <stdlib.h>
#include <stdint.h>
#include <limits.h>

#define MASK ((UINT64_C(1) << 32) - 1)

static inline my_extern_prefix`'fixed32p32
my_extern_prefix`'fixed32p32_square_root__sqrt_initial_estimate
  (my_extern_prefix`'fixed32p32 x)
{
  /* Use as initial estimate 2**(floor((log2(n) / 2)) + 1), where n is
     x rounded up. The initial estimate should not be smaller than the
     actual square root. */

  uint32_t n = (uint32_t) (x >> 32) + ((x & MASK) != 0);

  _Static_assert ((CHAR_BIT * sizeof (unsigned long)) >= 32,
                  "uint32_t is longer than an unsigned long,"
                  " which seems strange");
#if defined __GNUC__
  const int bitsize =
    32 - (__builtin_clzl (n) - ((CHAR_BIT * sizeof (unsigned long)) - 32));
#else
  /* Convert the leading zeros problem to a trailing ones problem, and
     then count trailing ones by de Bruijn sequence. See:

     {{cite web
      | title       = Bit Twiddling Hacks
      | url         = https://graphics.stanford.edu/~seander/bithacks.html
      | date        = 2023-01-14
      | archiveurl  = http://archive.today/GNADt
      | archivedate = 2023-01-14 }}

     where essentially the same method is used to count trailing
     zeros. */

  /* Fill in low bits with ones. */
  n |= n >> 1; 
  n |= n >> 2;
  n |= n >> 4;
  n |= n >> 8;
  n |= n >> 16;

  const int bitsize =
    "\0\1\34\2\35\16\30\3\36\26\24\17\31\21\4\10\37\33\15\27\25\23\20\7\32\14\22\6\13\5\12\11"
    [((~n & (n + 1)) * UINT32_C(0x077CB531)) >> 27];
#endif

  return ((my_extern_prefix`'fixed32p32) 1) << (((bitsize - 1) >> 1) + 33);
}

%}

(*------------------------------------------------------------------*)

extern fn
_sqrt_initial_estimate :
  fixed32p32 -<> fixed32p32 = "mac#%"

implement
g0float_sqrt_fixed32p32 x =
  if iseqz x then
    x
  else if isltz x then
    $effmask_all
    begin
      prerr! ("error: square root of negative fixed32p32: ",
              x, "\n");
      exit 1
    end
  else
    let
      val eps = g0i2f 512 * epsilon<fix32p32knd> ()
      and one_half = g0int2float<intknd,fix32p32knd> 1 / g0i2f 2

      (* Heron’s method. *)
      macdef step y = one_half * (,(y) + (x / ,(y)))

      fun
      loop (y0 : fixed32p32,
            y1 : fixed32p32)
          :<!ntm> fixed32p32 =
        let
          val diff = y1 - y0
        in
          if iseqz diff then
            y1
          else if abs diff <= eps then
            step y1
          else
            loop (y1, step y1)
        end

      val y0 = _sqrt_initial_estimate x
    in
      $effmask_ntm loop (y0, step y0)
    end

(*------------------------------------------------------------------*)
dnl
dnl local variables:
dnl mode: ATS
dnl end:

/*
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
*/
include(`common-macros.m4')m4_include(`ats2-xprelude-macros.m4')
/*------------------------------------------------------------------*/

#if defined my_extern_prefix`'function_always_inline
/* Do nothing. */
#elif defined __GNUC__
#define my_extern_prefix`'function_always_inline [[gnu::always_inline]]
#else
#define my_extern_prefix`'function_always_inline
#endif

#if defined my_extern_prefix`'function_const
/* Do nothing. */
#elif defined __GNUC__
#define my_extern_prefix`'function_const [[gnu::const]]
#else
#define my_extern_prefix`'function_const
#endif

#if defined my_extern_prefix`'function_deprecated
/* Do nothing. */
#elif defined __GNUC__
#define my_extern_prefix`'function_deprecated [[gnu::deprecated]]
#else
#define my_extern_prefix`'function_deprecated
#endif

#if defined my_extern_prefix`'function_flatten
/* Do nothing. */
#elif defined __GNUC__
#define my_extern_prefix`'function_flatten [[gnu::flatten]]
#else
#define my_extern_prefix`'function_flatten
#endif

#if defined my_extern_prefix`'function_malloc
/* Do nothing. */
#elif defined __GNUC__
#define my_extern_prefix`'function_malloc [[gnu::malloc]]
#else
#define my_extern_prefix`'function_malloc
#endif

#if defined my_extern_prefix`'function_pure
/* Do nothing. */
#elif defined __GNUC__
#define my_extern_prefix`'function_pure [[gnu::pure]]
#else
#define my_extern_prefix`'function_pure
#endif

#ifndef my_extern_prefix`'inline
#define my_extern_prefix`'inline ATSinline ()
/* You might prefer to be stricter that a function should be inlined: */
/* #define my_extern_prefix`'inline my_extern_prefix`'function_always_inline ATSinline () */
#endif

#ifndef my_extern_prefix`'extern
#define my_extern_prefix`'extern extern
#endif

#ifndef my_extern_prefix`'pure_inline
#define my_extern_prefix`'pure_inline my_extern_prefix`'function_pure my_extern_prefix`'inline
#endif

#ifndef my_extern_prefix`'const_inline
#define my_extern_prefix`'const_inline my_extern_prefix`'function_const my_extern_prefix`'inline
#endif

#ifndef my_extern_prefix`'pure_extern
#define my_extern_prefix`'pure_extern my_extern_prefix`'function_pure my_extern_prefix`'extern
#endif

#ifndef my_extern_prefix`'const_extern
#define my_extern_prefix`'const_extern my_extern_prefix`'function_const my_extern_prefix`'extern
#endif

/*------------------------------------------------------------------*/
dnl
dnl local variables:
dnl mode: C
dnl end:

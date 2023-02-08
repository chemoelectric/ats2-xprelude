#
# Copyright © 2022, 2023 Barry Schwartz
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License, as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received copies of the GNU General Public License
# along with this program. If not, see
# <https://www.gnu.org/licenses/>.
#

.DELETE_ON_ERROR:

ACLOCAL_AMFLAGS = -I m4 --install
AUTOMAKE_OPTIONS =
AUTOMAKE_OPTIONS += foreign
AUTOMAKE_OPTIONS += subdir-objects
AUTOMAKE_OPTIONS += -Wno-portability

include $(top_srcdir)/aminclude_static.am
@GNU@ include $(top_srcdir)/silent-rules.mk
@GNU@ -include ats-dependencies/*.mk

EXTRA_DIST =
MOSTLYCLEANFILES =
CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
AM_M4FLAGS =
AM_CPPFLAGS =
AM_CFLAGS =
AM_LDFLAGS =
LDADD =
bin_PROGRAMS =
lib_LTLIBRARIES =
EXTRA_PROGRAMS =
TESTS =

nobase_dist_pkginclude_HEADERS =
nobase_nodist_pkginclude_HEADERS =
dist_libats2_xprelude_la_SOURCES =
nodist_libats2_xprelude_la_SOURCES =
libats2_xprelude_la_LIBADD =
nodist_pkgconfig_DATA =

EXTRA_DIST += autogen.sh
EXTRA_DIST += $(srcdir)/silent-rules.mk
EXTRA_DIST += COPYING
EXTRA_DIST += INSTALL
EXTRA_DIST += README
EXTRA_DIST += AUTHORS

DISTCLEANFILES += Makefile
DISTCLEANFILES += GNUmakefile

AM_CPPFLAGS += -I$(builddir)
AM_CPPFLAGS += -I$(srcdir)
AM_CPPFLAGS += -I$(PATSHOME)
AM_CPPFLAGS += -I$(PATSHOME)/ccomp/runtime/

LDADD += $(CODE_COVERAGE_LIBS)

CODE_COVERAGE_IGNORE_PATTERN =
CODE_COVERAGE_IGNORE_PATTERN += /usr/include/*
CODE_COVERAGE_IGNORE_PATTERN += /usr/include/*/*
CODE_COVERAGE_IGNORE_PATTERN += $(PATSHOME)/ccomp/runtime/*
CODE_COVERAGE_IGNORE_PATTERN += $(PATSHOME)/prelude/CATS/*

clean-local: code-coverage-clean tests-clean xats-c-clean
distclean-local: code-coverage-dist-clean ats-includes-distclean

#--------------------------------------------------------------------------

AM_M4FLAGS += -DTOP_SRCDIR='$(top_srcdir)'

TOTAL_M4FLAGS =
TOTAL_M4FLAGS += $(AM_M4FLAGS)
TOTAL_M4FLAGS += $(M4FLAGS)
TOTAL_M4FLAGS += $(XM4FLAGS)

M4DEPS =
M4DEPS += common-macros.m4
M4DEPS += ats2-xprelude-macros.m4

%: %.m4 $(M4DEPS)
	@$(MKDIR_P) $(@D)
	$(call v,M4)$(M4) $(TOTAL_M4FLAGS) $(<) > $(@)

%.c: %.c.m4 $(M4DEPS)
	@$(MKDIR_P) $(@D)
	$(call v,M4)$(M4) $(TOTAL_M4FLAGS) $(<) > $(@)

@GNU@ define make-compiling-implementations =
@GNU@ $(1): $(addsuffix .m4, $(1)) $(M4DEPS)
@GNU@	@$$(MKDIR_P) $$(@D)
@GNU@	$$(call v,M4)$$(M4) -DCOMPILING_IMPLEMENTATIONS=yes $$(TOTAL_M4FLAGS) $$(<) > $$(@)
@GNU@ endef

#--------------------------------------------------------------------------

PATSOPT_DEPS =

AM_PATSOPTFLAGS =
AM_PATSOPTFLAGS += -IATS $(builddir)
AM_PATSOPTFLAGS += -IATS $(srcdir)

TOTAL_PATSOPTFLAGS =
TOTAL_PATSOPTFLAGS += $(AM_PATSOPTFLAGS)
TOTAL_PATSOPTFLAGS += $(PATSOPTFLAGS)
TOTAL_PATSOPTFLAGS += $(XPATSOPTFLAGS)

TESTS_PATSOPTFLAGS =
TESTS_PATSOPTFLAGS += -IATS $(builddir)/tests
TESTS_PATSOPTFLAGS += -IATS $(srcdir)/tests

@GNU@ define write-dependencies-file =
@GNU@	$(MKDIR_P) ats-dependencies && \
@GNU@		echo $(1): $(shell ./list-ats-dependencies $(2)) \
@GNU@			> ats-dependencies/`echo $(@) | $(SED) 's|/|_057_|g'`.mk
@GNU@ endef

.PHONY: ats-includes-distclean
ats-includes-distclean:
	-rm -f -R ats-dependencies

if DEPENDENCY_TRACKING

%_sats.c: %.sats $(PATSOPT_DEPS) list-ats-dependencies
	@$(call write-dependencies-file,$(@),$(<))
	@$(MKDIR_P) $(@D)
	$(call v,PATSOPT)$(PATSOPT) -o $(@) $(TOTAL_PATSOPTFLAGS) -s $(<)

%_dats.c: %.dats $(PATSOPT_DEPS) list-ats-dependencies
	@$(call write-dependencies-file,$(@),$(<))
	@$(MKDIR_P) $(@D)
	$(call v,PATSOPT)$(PATSOPT) -o $(@) $(TOTAL_PATSOPTFLAGS) -d $(<)

%_tests.c: %.dats $(PATSOPT_DEPS) list-ats-dependencies
	@$(call write-dependencies-file,$(@),$(<))
	@$(MKDIR_P) $(@D)
	$(call v,PATSOPT)$(PATSOPT) -o $(@) $(TOTAL_PATSOPTFLAGS) \
			$(TESTS_PATSOPTFLAGS) -d $(<)

else !DEPENDENCY_TRACKING

%_sats.c: %.sats $(PATSOPT_DEPS)
	@$(MKDIR_P) $(@D)
	$(call v,PATSOPT)$(PATSOPT) -o $(@) $(TOTAL_PATSOPTFLAGS) -s $(<)

%_dats.c: %.dats $(PATSOPT_DEPS)
	@$(MKDIR_P) $(@D)
	$(call v,PATSOPT)$(PATSOPT) -o $(@) $(TOTAL_PATSOPTFLAGS) -d $(<)

%_tests.c: %.dats $(PATSOPT_DEPS)
	@$(MKDIR_P) $(@D)
	$(call v,PATSOPT)$(PATSOPT) -o $(@) $(TOTAL_PATSOPTFLAGS) \
			$(TESTS_PATSOPTFLAGS) -d $(<)

endif !DEPENDENCY_TRACKING

%_genprog.c: %.dats $(PATSOPT_DEPS)
	@$(MKDIR_P) $(@D)
	$(call v,PATSOPT)$(PATSOPT) -o $(@) $(TOTAL_PATSOPTFLAGS) -d $(<)

%_depsprog.c: %.dats $(PATSOPT_DEPS)
	@$(MKDIR_P) $(@D)
	$(call v,PATSOPT)$(PATSOPT) -o $(@) $(TOTAL_PATSOPTFLAGS) -d $(<)

#--------------------------------------------------------------------------
#
# ATS2 libraries go here.
#

lib_LTLIBRARIES += libats2-xprelude.la

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

XPRELUDE_HATS =

XPRELUDE_HATS += xprelude/HATS/xprelude_sats.hats
XPRELUDE_HATS += xprelude/HATS/xprelude_dats.hats
XPRELUDE_HATS += xprelude/HATS/xprelude.hats

EXTRA_DIST += $(addsuffix .m4, $(XPRELUDE_HATS))
BUILT_SOURCES += $(XPRELUDE_HATS) 
CLEANFILES += $(XPRELUDE_HATS)

nobase_nodist_pkginclude_HEADERS += $(XPRELUDE_HATS)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ARITH_PRF_SATS = xprelude/SATS/arith_prf.sats
ARITH_PRF_DATS = xprelude/DATS/arith_prf.dats
ARITH_PRF_SATS_C = xprelude/SATS/arith_prf_sats.c
ARITH_PRF_DATS_C = xprelude/DATS/arith_prf_dats.c

ARITH_PRF_SRC = $(ARITH_PRF_SATS) $(ARITH_PRF_DATS)
EXTRA_DIST += $(addsuffix .m4, $(ARITH_PRF_SRC))
BUILT_SOURCES += $(ARITH_PRF_SRC)
CLEANFILES += $(ARITH_PRF_SRC)

nobase_nodist_pkginclude_HEADERS += $(ARITH_PRF_SRC)

nodist_libats2_xprelude_la_SOURCES += $(ARITH_PRF_SATS_C)
nodist_libats2_xprelude_la_SOURCES += $(ARITH_PRF_DATS_C)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INTEGER_SATS = xprelude/SATS/integer.sats
INTEGER_DATS = xprelude/DATS/integer.dats
INTEGER_CATS = xprelude/CATS/integer.cats
INTEGER_SATS_C = xprelude/SATS/integer_sats.c
INTEGER_DATS_C = xprelude/DATS/integer_dats.c

INTEGER_SUPPORT_DATS =
INTEGER_SUPPORT_DATS += ipow.dats
INTEGER_SUPPORT_DATS += integer-implementations.dats

INTEGER_SUPPORT_DATS_C =
INTEGER_SUPPORT_DATS_C += ipow_dats.c
INTEGER_SUPPORT_DATS_C += integer-implementations_dats.c

integer-implementations.dats: $(addsuffix .m4, $(INTEGER_DATS))
$(eval $(call make-compiling-implementations, integer-implementations.dats))

INTEGER_SRC = $(INTEGER_SATS) $(INTEGER_DATS) $(INTEGER_CATS)
EXTRA_DIST += $(addsuffix .m4, $(INTEGER_SRC))
EXTRA_DIST += $(addsuffix .m4, $(INTEGER_SUPPORT_DATS))
BUILT_SOURCES += $(INTEGER_SRC)
BUILT_SOURCES += $(INTEGER_SUPPORT_DATS)
CLEANFILES += $(INTEGER_SRC)
CLEANFILES += $(INTEGER_SUPPORT_DATS)

nobase_nodist_pkginclude_HEADERS += $(INTEGER_SRC)

nodist_libats2_xprelude_la_SOURCES += $(INTEGER_SATS_C)
nodist_libats2_xprelude_la_SOURCES += $(INTEGER_DATS_C)
nodist_libats2_xprelude_la_SOURCES += $(INTEGER_SUPPORT_DATS_C)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

FLOAT_SATS = xprelude/SATS/float.sats
FLOAT_DATS = xprelude/DATS/float.dats
FLOAT_CATS = xprelude/CATS/float.cats
FLOAT_SATS_C = xprelude/SATS/float_sats.c
FLOAT_DATS_C = xprelude/DATS/float_dats.c

FLOAT_SUPPORT_DATS =
FLOAT_SUPPORT_DATS += strfrom-support.dats
FLOAT_SUPPORT_DATS += strto-support.dats
FLOAT_SUPPORT_DATS += float-implementations.dats

FLOAT_SUPPORT_DATS_C =
FLOAT_SUPPORT_DATS_C += strfrom-support_dats.c
FLOAT_SUPPORT_DATS_C += strto-support_dats.c
FLOAT_SUPPORT_DATS_C += float-implementations_dats.c

strfrom-support.dats: $(addsuffix .m4, $(FLOAT_DATS))
float-implementations.dats: $(addsuffix .m4, $(FLOAT_DATS))
$(eval $(call make-compiling-implementations, float-implementations.dats))

FLOAT_SRC = $(FLOAT_SATS) $(FLOAT_DATS) $(FLOAT_CATS)
EXTRA_DIST += $(addsuffix .m4, $(FLOAT_SRC) $(FLOAT_SUPPORT_DATS) float-strto.c)
BUILT_SOURCES += $(FLOAT_SRC) $(FLOAT_SUPPORT_DATS) float-strto.c
CLEANFILES += $(FLOAT_SRC) $(FLOAT_SUPPORT_DATS) float-strto.c

strto-support_dats.$(OBJEXT): strto-support_dats.c float-strto.c config.h

nobase_nodist_pkginclude_HEADERS += $(FLOAT_SRC)

nodist_libats2_xprelude_la_SOURCES += $(FLOAT_SATS_C)
nodist_libats2_xprelude_la_SOURCES += $(FLOAT_DATS_C)
nodist_libats2_xprelude_la_SOURCES += $(FLOAT_SUPPORT_DATS_C)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

FIXED32P32_SATS = xprelude/SATS/fixed32p32.sats
FIXED32P32_DATS = xprelude/DATS/fixed32p32.dats
FIXED32P32_CATS = xprelude/CATS/fixed32p32.cats
FIXED32P32_SATS_C = xprelude/SATS/fixed32p32_sats.c
FIXED32P32_DATS_C = xprelude/DATS/fixed32p32_dats.c

FIXED32P32_SUPPORT_DATS =
FIXED32P32_SUPPORT_DATS += fixed32p32_square_root.dats
FIXED32P32_SUPPORT_DATS += tostrptr_fixed32p32.dats
FIXED32P32_SUPPORT_DATS += fixed32p32-implementations.dats

FIXED32P32_SUPPORT_DATS_C =
FIXED32P32_SUPPORT_DATS_C += fixed32p32_square_root_dats.c
FIXED32P32_SUPPORT_DATS_C += tostrptr_fixed32p32_dats.c
FIXED32P32_SUPPORT_DATS_C += fixed32p32-implementations_dats.c

FIXED32P32_SUPPORT_C =
FIXED32P32_SUPPORT_C += fixed32p32_multiplication.c
FIXED32P32_SUPPORT_C += fixed32p32_division.c

fixed32p32-implementations.dats : $(addsuffix .m4, $(FIXED32P32_DATS))
$(eval $(call make-compiling-implementations, fixed32p32-implementations.dats))

FIXED32P32_SRC = $(FIXED32P32_SATS) $(FIXED32P32_DATS) $(FIXED32P32_CATS)
EXTRA_DIST += $(addsuffix .m4, $(FIXED32P32_SRC))
EXTRA_DIST += $(addsuffix .m4, $(FIXED32P32_SUPPORT_DATS))
EXTRA_DIST += $(addsuffix .m4, $(FIXED32P32_SUPPORT_C))
BUILT_SOURCES += $(FIXED32P32_SRC)
BUILT_SOURCES += $(FIXED32P32_SUPPORT_DATS)
BUILT_SOURCES += $(FIXED32P32_SUPPORT_C)
CLEANFILES += $(FIXED32P32_SRC)
CLEANFILES += $(FIXED32P32_SUPPORT_DATS)
CLEANFILES += $(FIXED32P32_SUPPORT_C)

nobase_nodist_pkginclude_HEADERS += $(FIXED32P32_SRC)

nodist_libats2_xprelude_la_SOURCES += $(FIXED32P32_SATS_C)
nodist_libats2_xprelude_la_SOURCES += $(FIXED32P32_DATS_C)
nodist_libats2_xprelude_la_SOURCES += $(FIXED32P32_SUPPORT_DATS_C)
nodist_libats2_xprelude_la_SOURCES += $(FIXED32P32_SUPPORT_C)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GMP_SUPPORT_DATS =
GMP_SUPPORT_DATS += gmp-support.dats

GMP_SUPPORT_DATS_C =
GMP_SUPPORT_DATS_C += gmp-support_dats.c

EXTRA_DIST += $(addsuffix .m4, $(GMP_SUPPORT_DATS))
BUILT_SOURCES += $(GMP_SUPPORT_DATS)
CLEANFILES += $(GMP_SUPPORT_DATS)

if WITH_GMP
nodist_libats2_xprelude_la_SOURCES += $(GMP_SUPPORT_DATS_C)
endif WITH_GMP

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

EXRAT_SATS = xprelude/SATS/exrat.sats
EXRAT_DATS = xprelude/DATS/exrat.dats
EXRAT_CATS = xprelude/CATS/exrat.cats
EXRAT_SATS_C = xprelude/SATS/exrat_sats.c
EXRAT_DATS_C = xprelude/DATS/exrat_dats.c

EXRAT_SUPPORT_DATS =
EXRAT_SUPPORT_DATS += exrat-support.dats
EXRAT_SUPPORT_DATS += exrat-implementations.dats

EXRAT_SUPPORT_DATS_C =
EXRAT_SUPPORT_DATS_C += exrat-support_dats.c
EXRAT_SUPPORT_DATS_C += exrat-implementations_dats.c

EXRAT_SRC = $(EXRAT_SATS) $(EXRAT_DATS) $(EXRAT_CATS)
EXTRA_DIST += $(addsuffix .m4, $(EXRAT_SRC) $(EXRAT_SUPPORT_DATS))
BUILT_SOURCES += $(EXRAT_SRC) $(EXRAT_SUPPORT_DATS)
CLEANFILES += $(EXRAT_SRC) $(EXRAT_SUPPORT_DATS)

exrat-implementations.dats : $(addsuffix .m4, $(EXRAT_DATS))
$(eval $(call make-compiling-implementations, exrat-implementations.dats))

if ENABLE_EXRAT

nobase_nodist_pkginclude_HEADERS += $(EXRAT_SRC)

nodist_libats2_xprelude_la_SOURCES += $(EXRAT_SATS_C)
nodist_libats2_xprelude_la_SOURCES += $(EXRAT_DATS_C)
nodist_libats2_xprelude_la_SOURCES += $(EXRAT_SUPPORT_DATS_C)

endif ENABLE_EXRAT

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

BISECTION_ITERATOR_SATS = xprelude/SATS/bisection_iterator.sats
BISECTION_ITERATOR_DATS = xprelude/DATS/bisection_iterator.dats
BISECTION_ITERATOR_SATS_C = xprelude/SATS/bisection_iterator_sats.c
BISECTION_ITERATOR_DATS_C = xprelude/DATS/bisection_iterator_dats.c

BISECTION_ITERATOR_SUPPORT_DATS =
BISECTION_ITERATOR_SUPPORT_DATS += bisection_iterator-support.dats

BISECTION_ITERATOR_SUPPORT_DATS_C =
BISECTION_ITERATOR_SUPPORT_DATS_C += bisection_iterator-support_dats.c

BISECTION_ITERATOR_SRC =
BISECTION_ITERATOR_SRC += $(BISECTION_ITERATOR_SATS)
BISECTION_ITERATOR_SRC += $(BISECTION_ITERATOR_DATS)
EXTRA_DIST += $(addsuffix .m4, $(BISECTION_ITERATOR_SRC) $(BISECTION_ITERATOR_SUPPORT_DATS))
BUILT_SOURCES += $(BISECTION_ITERATOR_SRC) $(BISECTION_ITERATOR_SUPPORT_DATS)
CLEANFILES += $(BISECTION_ITERATOR_SRC) $(BISECTION_ITERATOR_SUPPORT_DATS)

if ENABLE_BISECTION_ITERATOR

nobase_nodist_pkginclude_HEADERS += $(BISECTION_ITERATOR_SRC)

nodist_libats2_xprelude_la_SOURCES += $(BISECTION_ITERATOR_SATS_C)
nodist_libats2_xprelude_la_SOURCES += $(BISECTION_ITERATOR_DATS_C)
nodist_libats2_xprelude_la_SOURCES += $(BISECTION_ITERATOR_SUPPORT_DATS_C)

endif ENABLE_BISECTION_ITERATOR

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

MPFR_SATS = xprelude/SATS/mpfr.sats
MPFR_DATS = xprelude/DATS/mpfr.dats
MPFR_CATS = xprelude/CATS/mpfr.cats
MPFR_SATS_C = xprelude/SATS/mpfr_sats.c
MPFR_DATS_C = xprelude/DATS/mpfr_dats.c

MPFR_SUPPORT_DATS =
MPFR_SUPPORT_DATS += mpfr-support.dats
MPFR_SUPPORT_DATS += mpfr-implementations.dats

MPFR_SUPPORT_DATS_C =
MPFR_SUPPORT_DATS_C += mpfr-support_dats.c
MPFR_SUPPORT_DATS_C += mpfr-implementations_dats.c

MPFR_SRC = $(MPFR_SATS) $(MPFR_DATS) $(MPFR_CATS)
EXTRA_DIST += $(addsuffix .m4, $(MPFR_SRC) $(MPFR_SUPPORT_DATS))
BUILT_SOURCES += $(MPFR_SRC) $(MPFR_SUPPORT_DATS)
CLEANFILES += $(MPFR_SRC) $(MPFR_SUPPORT_DATS)
CLEANFILES += tests/mpfr-fprint_val.out

mpfr-implementations.dats: $(addsuffix .m4, $(MPFR_DATS))
$(eval $(call make-compiling-implementations, mpfr-implementations.dats))

if ENABLE_MPFR

nobase_nodist_pkginclude_HEADERS += $(MPFR_SRC)

nodist_libats2_xprelude_la_SOURCES += $(MPFR_SATS_C)
nodist_libats2_xprelude_la_SOURCES += $(MPFR_DATS_C)
nodist_libats2_xprelude_la_SOURCES += $(MPFR_SUPPORT_DATS_C)

endif ENABLE_MPFR

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SORT_SATS =
SORT_DATS =
SORT_SATS_C =
SORT_DATS_C =

SORT_SATS += xprelude/SATS/sort.sats
SORT_DATS += xprelude/DATS/sort.dats
SORT_SATS_C += xprelude/SATS/sort_sats.c
SORT_DATS_C += xprelude/DATS/sort_dats.c

SORT_SRC = $(SORT_SATS) $(SORT_DATS)
EXTRA_DIST += $(addsuffix .m4, $(SORT_SRC))
BUILT_SOURCES += $(SORT_SRC)
CLEANFILES += $(SORT_SRC)

nobase_nodist_pkginclude_HEADERS += $(SORT_SRC)

nodist_libats2_xprelude_la_SOURCES += $(SORT_SATS_C)
nodist_libats2_xprelude_la_SOURCES += $(SORT_DATS_C)

SORT_HATS =
SORT_HATS += xprelude/HATS/sort_dats.hats
SORT_HATS += xprelude/HATS/sort.hats
EXTRA_DIST += $(addsuffix .m4, $(SORT_HATS))
BUILT_SOURCES += $(SORT_HATS) 
CLEANFILES += $(SORT_HATS)

nobase_nodist_pkginclude_HEADERS += $(SORT_HATS)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Make %.o files depend on %.c files.
$(foreach source_file, \
	$(nodist_libats2_xprelude_la_SOURCES), \
	$(eval $(patsubst %.c,%.$(OBJEXT),$(source_file)): $(source_file)))

xats-c-clean:
	-rm -f xprelude/SATS/*_sats.c
	-rm -f xprelude/DATS/*_dats.c
	-rm -f ./*_sats.c
	-rm -f ./*_dats.c

#--------------------------------------------------------------------------
#
# Tests go here.
#

TEST_CFLAGS = $(AM_CFLAGS) $(ATS_MEMALLOC_CFLAGS) -D$(ATS_MEMALLOC)
TEST_LIBS = libats2-xprelude.la $(LIBS) -lm $(ATS_MEMALLOC_LIBS)

EXTRA_DIST += tests/test-integer.dats
TESTS += tests/test-integer
nodist_tests_test_integer_SOURCES = tests/test-integer_tests.c
tests_test_integer_CFLAGS = $(TEST_CFLAGS)
tests_test_integer_LDADD = $(TEST_LIBS)

EXTRA_DIST += tests/test-float.dats
TESTS += tests/test-float
nodist_tests_test_float_SOURCES = tests/test-float_tests.c
tests_test_float_CFLAGS = $(TEST_CFLAGS)
tests_test_float_LDADD = $(TEST_LIBS)

EXTRA_DIST += tests/test-float128.dats
if HAVE_FLOAT128
TESTS += tests/test-float128
nodist_tests_test_float128_SOURCES = tests/test-float128_tests.c
tests_test_float128_CFLAGS = $(TEST_CFLAGS)
tests_test_float128_LDADD = $(TEST_LIBS)
endif HAVE_FLOAT128

EXTRA_DIST += tests/test-fixed32p32.dats
TESTS += tests/test-fixed32p32
nodist_tests_test_fixed32p32_SOURCES = tests/test-fixed32p32_tests.c
tests_test_fixed32p32_CFLAGS = $(TEST_CFLAGS)
tests_test_fixed32p32_LDADD = $(TEST_LIBS)

EXTRA_DIST += tests/test-exrat.dats
if ENABLE_EXRAT
TESTS += tests/test-exrat
nodist_tests_test_exrat_SOURCES = tests/test-exrat_tests.c
tests_test_exrat_CFLAGS = $(TEST_CFLAGS)
tests_test_exrat_LDADD = $(TEST_LIBS)
endif ENABLE_EXRAT

EXTRA_DIST += tests/test-bisection_iterator.dats
if ENABLE_BISECTION_ITERATOR
TESTS += tests/test-bisection_iterator
nodist_tests_test_bisection_iterator_SOURCES = tests/test-bisection_iterator_tests.c
tests_test_bisection_iterator_CFLAGS = $(TEST_CFLAGS)
tests_test_bisection_iterator_LDADD = $(TEST_LIBS)
endif ENABLE_BISECTION_ITERATOR

EXTRA_DIST += tests/test-mpfr.dats
if ENABLE_MPFR
if ENABLE_EXRAT		  # Currently you need exrat to run the mpfr test.
TESTS += tests/test-mpfr
nodist_tests_test_mpfr_SOURCES = tests/test-mpfr_tests.c
tests_test_mpfr_CFLAGS = $(TEST_CFLAGS)
tests_test_mpfr_LDADD = $(TEST_LIBS)
endif ENABLE_EXRAT
endif ENABLE_MPFR

EXTRA_DIST += tests/test-sort.dats
TESTS += tests/test-sort
nodist_tests_test_sort_SOURCES = tests/test-sort_tests.c
tests_test_sort_CFLAGS = $(TEST_CFLAGS)
tests_test_sort_LDADD = $(TEST_LIBS)

EXTRA_PROGRAMS += $(TESTS)

tests-clean:
	-rm -f tests/*.$(OBJEXT)
	-rm -f $(addsuffix _tests.c,$(TESTS))
CLEANFILES += $(TESTS)

#--------------------------------------------------------------------------
#
# Pkg-config support.
#

nodist_pkgconfig_DATA += ats2-xprelude.pc

#--------------------------------------------------------------------------
#
# Computation of dependencies.
#

EXTRA_PROGRAMS += list-ats-dependencies
EXTRA_DIST += list-ats-dependencies.dats
CLEANFILES += list-ats-dependencies
CLEANFILES += list-ats-dependencies_depsprog.c

nodist_list_ats_dependencies_SOURCES =
nodist_list_ats_dependencies_SOURCES += list-ats-dependencies_depsprog.c
list_ats_dependencies_CPPFLAGS =
list_ats_dependencies_CPPFLAGS += $(AM_CPPFLAGS)
list_ats_dependencies_CPPFLAGS += -DATS_MEMALLOC_LIBC
list_ats_dependencies_DEPENDENCIES =
list_ats_dependencies_DEPENDENCIES += list-ats-dependencies.dats
list_ats_dependencies_LDADD =
list_ats_dependencies_LDADD += -L'$(PATSHOME)/ccomp/atslib/lib'
list_ats_dependencies_LDADD += -latslib

#--------------------------------------------------------------------------
# local variables:
# coding: utf-8
# end:

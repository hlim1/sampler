name ?= $(error must define $$(name))
testDir ?= $(error must define $$(testDir))
runArgs ?= $(error must define $$(runArgs))


exec ?= $(name).exe


########################################################################


sampler := ../../..
instrumentor := $(sampler)/instrumentor
decure := $(instrumentor)/decure

include ../config.mk
workDir := $(workHome)/test
workExec := $(workDir)/$(testDir)/$(exec)
workComb := $(workExec)_comboptimcured.i

ifdef buildOnlys
-include functions.mk
ifneq (,$(filter all none, $(functions)))
$(name conflict: error benchmark defines an "all" or "none" function)
endif
endif

alwaysForms := $(addprefix always-, $(functions) all none)
alwaysExecs := $(alwaysForms:=.exe)
alwaysSrcs  := $(alwaysForms:=.c)

sampleForms := $(addprefix sample-, $(functions) all)
sampleExecs := $(sampleForms:=.exe)
sampleSrcs  := $(sampleForms:=.c)

allForms := $(alwaysForms) $(sampleForms)
allExecs := $(alwaysExecs) $(sampleExecs)
allIdents := $(allForms:=.ident)

CFLAGS := -O2
LOADLIBES := $(trusted:%=$(workDir)/$(testDir)/%) $(workHome)/obj/x86_LINUX/ccured_GNUCC_releaselib.a -lm
link = $(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@

decureMain := $(decure)/main
runDecure := $(decureMain)


########################################################################


all: stats loopless idents
.PHONY: all

execs: always sample
.PHONY: execs

always: $(sort $(alwaysExecs))
.PHONY: always

sample: $(sort $(sampleExecs))
.PHONY: sample

source: $(sort $(allExecs:.exe=.c))

../config.mk: %: %.in ../../../config.status
	$(MAKE) -C $(@D) $(@F)

force:
.PHONY: force


########################################################################


$(workComb):
	$(MAKE) -C $(workDir) ITERATIONS=0 RELEASE=1 INFERBOX=infer EXTRAARGS=--allowInlineAssembly $(name)
	[ -r $@ ]

basis-cured.c: $(decure)/filterComplete $(workComb)
	$^  >$@ || rm -f $@
	[ -r $@ ]

decurable.i: basis-cured.c
	$(CPP) -include $(sampler)/libcountdown/event.h $< >$@ || rm -f $@
	[ -r $@ ]


########################################################################


$(alwaysExecs): %.exe: %.c
	$(link)


always-%.c: runDecure += --no-sample

always-all.c: decurable.i
	$(runDecure) $< >$@ || rm -f $@

always-none.c: decurable.i
	$(runDecure) --exclude-function \* $< >$@ || rm -f $@

always-%.c: decurable.i
	$(runDecure) --include-function $* --exclude-function \* $< >$@ || rm -f $@
	[ -r $@ ]


clean::
	rm -f always-*.exe
	rm -f always-*.c


########################################################################


$(sampleExecs): CC := libtool $(CC)
$(sampleExecs): LOADLIBES += -L$(sampler)/libcountdown -levent -lcyclic `gsl-config --libs`


$(sampleExecs): %.exe: %.c
	$(link)


sample-%.c: runDecure += --sample

sample-all.c: decurable.i
	$(runDecure) $< >$@ || rm -f $@

sample-%.c: decurable.i
	$(runDecure) --include-function $* --exclude-function \* $< >$@ || rm -f $@
	[ -r $@ ]


clean::
	rm -f sample-*.exe
	rm -f sample-*.c


########################################################################


stats: decurable.i
	$(runDecure) --show-stats $< >/dev/null 2>$@ || rm -f $@
	[ -r $@ ]


clean::
	rm -f stats


########################################################################


loopless: $(instrumentor)/loopless decurable.i
	$^ >$@ || rm -f $@
	[ -r $@ ]

$(instrumentor)/loopless: force
	$(MAKE) -C $(@D) $(@F)

clean::
	rm -f loopless


########################################################################


functions-list: $(decure)/listCandidates decurable.i
	$^ >$@ || rm -f $@
	[ -r $@ ]

functions.mk: ../make-functions-mk functions-list
	$< <functions-list >$@ || rm -f $@
	[ -r $@ ]

clean::
	if [ -d .libs ]; then rmdir .libs; fi

spotless: clean
	rm -f functions.mk functions-list basis-cured.c decurable.i


########################################################################


idents: $(allIdents)
.PHONY: idents

$(allIdents): %.ident: %.exe
	ident $< >$@ || rm -f $@
	[ -r $@ ]

clean::
	rm -f *.ident


########################################################################


sparsities := 100 1000 10000 1000000
alwaysTimes := $(alwaysForms:=-1.times)
sampleAllTimes := $(sparsities:%=sample-all-%.times)
sampleOnlyTimes := $(functions:%=sample-%-1000.times)
times := $(alwaysTimes) $(sampleAllTimes) $(sampleOnlyTimes)

times: $(times)
.PHONY: times

%.times: when       = $(word 1, $(subst -, , $*))
%.times: where      = $(word 2, $(subst -, , $*))
%.times: sparsity   = $(word 3, $(subst -, , $*))
%.times: executable = $(when)-$(where).exe
%.times: ../run-trials $(executable)
	./$< $(sparsity) './$(executable) $(runArgs)' >$@. 2>&1
	mv $@. $@

clean::
	rm -f *.times.
	rm -f *.times

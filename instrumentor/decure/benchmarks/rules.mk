name ?= $(error must define $$(name))
testDir ?= $(error must define $$(testDir))
runArgs ?= $(error must define $$(runArgs))


exec ?= $(name).exe


########################################################################


decure := ../..
instrumentor := $(decure)/..
sampler := $(instrumentor)/..

workHome := $(instrumentor)/cil
workDir := $(workHome)/test
workExec := $(workDir)/$(testDir)/$(exec)
workComb := $(workExec)_comboptimcured.i

-include functions.mk
alwaysForms := $(addprefix always-, $(functions:%=only-%) all none)
alwaysExecs := $(alwaysForms:=.exe)
alwaysSrcs  := $(alwaysForms:=.c)

sampleForms := $(addprefix sample-, $(functions:%=only-%) all)
sampleExecs := $(sampleForms:=.exe)
sampleSrcs  := $(sampleForms:=.c)

allForms := $(alwaysForms) $(sampleForms)
allExecs := $(alwaysExecs) $(sampleExecs)
allTimes := $(allForms:=.times)
allIdents := $(allForms:=.ident)

CFLAGS := -O2
LOADLIBES := $(trusted:%=$(workDir)/$(testDir)/%) $(workHome)/obj/x86_LINUX/ccured_GNUCC_releaselib.a -lm
link = $(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@

decureMain := $(decure)/main
#decureMainDep := $(decureMain
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

$(workComb):
	$(MAKE) -C $(workDir) ITERATIONS=0 $(name)
	@[ -r $@ ]

basis-cured.c: $(decure)/filterComplete $(workComb)
	$^  >$@ || rm -f $@
	@[ -r $@ ]

decurable.i: basis-cured.c
	$(CPP) -include $(sampler)/libcountdown/event.h $< >$@ || rm -f $@
	@[ -r $@ ]


########################################################################


$(alwaysExecs): %.exe: %.c
	$(link)


always-%.c: runDecure += --no-sample

always-only-%.c: decurable.i $(decureMainDep)
	$(runDecure) --only $* $< >$@ || rm -f $@
	@[ -r $@ ]

always-all.c: decurable.i $(decureMainDep)
	$(runDecure) $< >$@ || rm -f $@

always-none.c: decurable.i $(decureMainDep)
	$(runDecure) --only @ $< >$@ || rm -f $@


clean::
	rm -f always-*.exe
	rm -f always-*.c


########################################################################


$(sampleExecs): CC := libtool $(CC)
$(sampleExecs): LOADLIBES += -L$(sampler)/libcountdown -levent -lcyclic `gsl-config --libs`


$(sampleExecs): %.exe: %.c
	$(link)


sample-%.c: runDecure += --sample

sample-only-%.c: decurable.i $(decureMainDep)
	$(runDecure) --only $* $< >$@ || rm -f $@
	@[ -r $@ ]

sample-all.c: decurable.i $(decureMainDep)
	$(runDecure) $< >$@ || rm -f $@


clean::
	rm -f sample-*.exe
	rm -f sample-*.c


########################################################################


stats: decurable.i $(decureMainDep)
	$(runDecure) --show-stats $< >/dev/null 2>$@ || rm -f $@
	@[ -r $@ ]


clean::
	rm -f stats


########################################################################


loopless: $(instrumentor)/loopless decurable.i
	$^ >$@ || rm -f $@
	@[ -r $@ ]


clean::
	rm -f loopless


########################################################################


functions-list: $(decure)/listCandidates decurable.i
	$^ >$@ || rm -f $@
	@[ -r $@ ]

functions.mk: ../make-functions-mk functions-list
	$< <functions-list >$@ || rm -f $@
	@[ -r $@ ]

clean::
	if [ -d .libs ]; then rmdir .libs; fi

spotless: clean
	rm -f functions.mk functions-list basis-cured.c decurable.i


########################################################################


times: $(allTimes)
.PHONY: times

$(allTimes): %.times: ../run-trials %.exe
	./$< 100 './$*.exe $(runArgs)' >$@. 2>&1
	mv $@. $@

../countdowns/%:
	$(MAKE) -C $(@D) $(@F)


clean::
	rm -f *.times.
	rm -f *.times


########################################################################


idents: $(allIdents)
.PHONY: idents

$(allIdents): %.ident: %.exe
	ident $< >$@ || rm -f $@
	@[ -r $@ ]

clean::
	rm -f *.ident


########################################################################


sparsities := 100 1000 10000 1000000
sparseTimes := $(sparsities:=.times)

sparse-times: $(sparseTimes)
.PHONY: sparse-times

$(sparseTimes): %.times: ../run-trials sample-all.exe
	./$< $* './sample-all.exe $(runArgs)' >$@. 2>&1
	mv $@. $@

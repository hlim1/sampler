name ?= $(error must define $$(name))
testDir ?= $(error must define $$(testDir))
runArgs ?= $(error must define $$(runArgs))


exec ?= $(name).exe


########################################################################


seeds := 1 2 3 4
sparsity := 100

decure := ../..
instrumentor := $(decure)/..
sampler := $(instrumentor)/..

workHome := $(instrumentor)/cil
workDir := $(workHome)/test
workExec := $(workDir)/$(testDir)/$(exec)
workComb := $(workExec)_comboptimcured.i

-include functions.mk
alwaysForms := $(addprefix always-only-, $(functions))
alwaysExecs := $(addsuffix .exe, $(alwaysForms) always-all always-none)
alwaysSrcs  := $(alwaysForms:=.c)

sampleForms := $(addprefix sample-only-, $(functions))
sampleExecs := $(addsuffix .exe, $(sampleForms) sample-all)
sampleSrcs  := $(sampleForms:=.c)

allForms := $(alwaysForms) $(sampleForms)
allExecs := $(alwaysExecs) $(sampleExecs)
allTimes := $(foreach seed, $(seeds), $(allForms:=.$(seed).time))

CFLAGS := -O2
LOADLIBES := $(trusted:%=$(workDir)/$(testDir)/%) $(workHome)/obj/x86_LINUX/ccured_GNUCC_releaselib.a -lm
link = $(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@

decureMain := $(decure)/main
runDecure := $(decureMain)


########################################################################


all: loopless execs
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
	$(CPP) -include $(sampler)/libcountdown/countdown.h $(sampler)/libcountdown/cyclic.h $(decure)/libdecure/decure.h $< >$@ || rm -f $@
	@[ -r $@ ]


########################################################################


$(alwaysExecs): %.exe: %.c
	$(link)


always-%.c: runDecure += --no-sample

$(alwaysSrcs): always-only-%.c: decurable.i $(decureMain)
	$(runDecure) --only $* $< >$@ || rm -f $@
	@[ -r $@ ]

always-all.c: decurable.i $(decureMain)
	$(runDecure) $< >$@ || rm -f $@

always-none.c: decurable.i $(decureMain)
	$(runDecure) --only @ $< >$@ || rm -f $@


########################################################################


$(sampleExecs): CC := libtool $(CC)
$(sampleExecs): LOADLIBES += -L$(sampler)/libcountdown -lcyclic `gsl-config --libs`


$(sampleExecs): %.exe: %.c
	$(link)


sample-%.c: runDecure += --sample

$(sampleSrcs): sample-only-%.c: decurable.i $(decureMain)
	$(runDecure) --only $* $< >$@ || rm -f $@
	@[ -r $@ ]

sample-all.c: decurable.i $(decureMain)
	$(runDecure) $< >$@ || rm -f $@


########################################################################


loopless: $(instrumentor)/loopless decurable.i
	$^ >$@ || rm -f $@
	@[ -r $@ ]


########################################################################


functions-list: $(decure)/listCandidates decurable.i
	$^ >$@ || rm -f $@
	@[ -r $@ ]

functions.mk: ../make-functions-mk functions-list
	$< <functions-list >$@ || rm -f $@
	@[ -r $@ ]

clean:
	if [ -d .libs ]; then rmdir .libs; fi
	rm -f *.*.time
	rm -f *.*.time.
	rm -f *.exe
	rm -f always-*.c
	rm -f only-*.c
	rm -f loopless

spotless: clean
	rm -f functions.mk functions-list basis-cured.c decurable.i


########################################################################


times: $(allTimes)
.PHONY: times

seed = $(subst ., , $(suffix $(basname $@)))
countdowns = ../countdowns/$(sparsity).$(seed).counts

$(allTimes): %.time: $(countdown) %.exe
	SAMPLER_COUNTDOWNS=$(countdowns) /usr/bin/time ./$*.exe $(runArgs) >$@. 2>&1
	mv $@. $@

../countdowns/%:
	$(MAKE) -C $(@D) $(@F)

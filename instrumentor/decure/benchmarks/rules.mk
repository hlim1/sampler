name ?= $(error must define $$(name))
testDir ?= $(error must define $$(testDir))
runArgs ?= $(error must define $$(runArgs))


exec ?= $(name).exe


########################################################################


seeds := 1 2 3 4
sparsity := 100

workHome := ../cil
workDir := $(workHome)/test
workExec := $(workDir)/$(testDir)/$(exec)
workComb := $(workExec)_comboptimcured.i

sampler := ../../sampler
instrumentor := $(sampler)/instrumentor
decure := $(instrumentor)/decure

-include functions.mk
onlyForms := $(addprefix only-, $(functions))
onlyExecs := $(onlyForms:=.exe)
onlySrcs  := $(onlyForms:=.c)

basisForms := $(addprefix basis-, cured no-checks)
basisExecs := $(basisForms:=.exe)
basisSrcs  := $(basisForms:=.c)

allForms := $(basisForms) $(onlyForms)
allExecs := $(basisExecs) $(onlyExecs)
allTimes := $(foreach seed, $(seeds), $(allForms:=.$(seed).time))

CFLAGS := -O2
LOADLIBES := $(trusted:%=$(workDir)/$(testDir)/%) $(workHome)/obj/x86_LINUX/ccured_GNUCC_releaselib.a -lm
link = $(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@


########################################################################


all: loopless execs
.PHONY: all

execs: basis only
.PHONY: execs

basis: $(basisExecs)
.PHONY: basis

only: $(sort $(onlyExecs))
.PHONY: only

$(workComb):
	$(MAKE) -C $(workDir) ITERATIONS=0 $(name)
	@[ -r $@ ]

basis-cured.c: $(decure)/filterComplete $(workComb)
	$^  >$@ || rm -f $@
	@[ -r $@ ]

basis-cured.i: %.i: %.c
	$(CPP) $< >$@ || rm -f $@
	@[ -r $@ ]

basis-cured.exe: basis-cured.i
	$(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@

decurable.i: basis-cured.c
	$(CPP) -include $(sampler)/libcountdown/countdown.h $(sampler)/libcountdown/acyclic.h $(decure)/libdecure/decure.h $< >$@ || rm -f $@
	@[ -r $@ ]

basis-no-checks.c: decurable.i
	$(decure)/main $< >$@ || rm -f $@
	@[ -r $@ ]

basis-no-checks.exe: %.exe: %.c
	$(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@


########################################################################


$(onlyExecs): CC := libtool $(CC)
$(onlyExecs): LOADLIBES += -L$(sampler)/libcountdown -lcountdown -lacyclic -lcountdown `gsl-config --libs`


$(onlyExecs): %.exe: %.c
	$(link)


$(onlySrcs): only-%.c: $(decure)/main decurable.i
	$< --only $* decurable.i >$@ || rm -f $@
	@[ -r $@ ]


########################################################################


loopless: $(instrumentor)/loopless basis-no-checks.c
	$^ >$@ || rm -f $@
	@[ -r $@ ]


########################################################################


functions-list: $(decure)/listCandidates basis-cured.i
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
	rm -f only-*.c
	rm -f basis-no-checks.c
	rm -f decurable.i
	rm -f loopless

spotless: clean
	rm -f functions.mk functions-list basis-cured.c basis-cured.i


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

name ?= $(error must define $$(name))
testDir ?= $(error must define $$(testDir))
runArgs ?= $(error must define $$(runArgs))


exec ?= $(name).exe


########################################################################


sampler = ../../..
instrumentor = $(sampler)/instrumentor
decure = SAMPLER_ALREADY_CURED=1 $(instrumentor)/driver/main decure $(sampling) $(filtering)

include ../config.mk
workDir = $(workHome)/test
workExec = $(workDir)/$(testDir)/$(exec)
workComb = $(workExec:.exe=.cured.i)

# hide from automake
-include ../onlys.mk

alwaysForms = $(addprefix always-, $(functions) all none)
alwaysExecs = $(alwaysForms:=.exe)
alwaysSrcs  = $(alwaysForms:=.c)

sampleForms = $(addprefix sample-, $(functions) all)
sampleExecs = $(sampleForms:=.exe)
sampleSrcs  = $(sampleForms:=.c)

allForms = $(alwaysForms) $(sampleForms)
allExecs = $(alwaysExecs) $(sampleExecs)
allIdents = $(allForms:=.ident)

CFLAGS = -O2
LOADLIBES = $(trusted:%=$(workDir)/$(testDir)/%) -lm
link = $(decure) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LOADLIBES) $(LDLIBS) -o $@


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
	$(MAKE) -C $(workDir) ITERATIONS=0 RELEASE=1 INFERBOX=infer EXTRAARGS='--allowInlineAssembly -save-temps' $(name)
	[ -r $@ ]

basis-cured.c: $(instrumentor)/decure/filterComplete $(workComb)
	$^ >$@ || rm -f $@
	[ -r $@ ]

basis-cured.i: %.i: %.c
	$(CC) -E $< -o $@


########################################################################


$(alwaysExecs): %.exe: %.c
	$(link)


always-%.exe: sampling = --no-sample

always-%.exe:    filtering = --include-function $* --exclude-function \*
always-all.exe:  filtering = --include-function \*
always-none.exe: filtering = --exclude-function \*


always-%.c: basis-cured.c
	cp $< $@


MOSTLYCLEANFILES = always-*.exe always-*.[ciso]


########################################################################


$(sampleExecs): LOADLIBES += -L$(sampler)/libcountdown -lcyclic -lcountdown


$(sampleExecs): %.exe: %.c
	$(link)


sample-%.exe: sampling = --sample

sample-%.exe:    filtering = --include-function $* --exclude-function \*
sample-all.exe:  filtering = --include-function \*
sample-none.exe: filtering = --exclude-function \*


sample-%.c: basis-cured.c
	cp $< $@


MOSTLYCLEANFILES += sample-*.exe sample-*.[ciso]


########################################################################


stats: stats.c
	$(decure) --show-stats -c $< -o stats.o 2>$@ || rm -f $@
	[ -r $@ ]

stats.c: basis-cured.c
	cp $< $@

MOSTLYCLEANFILES += stats stats.o


########################################################################


loopless: $(instrumentor)/loopless basis-cured.i
	$^ >$@ || rm -f $@
	[ -r $@ ]

$(instrumentor)/loopless: force
	$(MAKE) -C $(@D) $(@F)

MOSTLYCLEANFILES += loopless


########################################################################


functions-list: $(decure)/listCandidates basis-cured.i
	$^ >$@ || rm -f $@
	[ -r $@ ]

functions.mk: ../make-functions-mk functions-list
	$< <functions-list >$@ || rm -f $@
	[ -r $@ ]

CLEANFILES = functions.mk functions-list basis-cured.c basis-cured.i $(workComb)


########################################################################


idents: $(allIdents)
.PHONY: idents

$(allIdents): %.ident: %.exe
	ident $< >$@ || rm -f $@
	[ -r $@ ]

MOSTLYCLEANFILES += *.ident


########################################################################


sparsities := 100 1000 10000 1000000
ccuredTimes := ccured.times
alwaysTimes := $(alwaysForms:=-1.times)
sampleAllTimes := $(sparsities:%=sample-all-%.times)
sampleOnlyTimes := $(functions:%=sample-%-1000.times)
times := $(ccuredTimes) $(alwaysTimes) $(sampleAllTimes) $(sampleOnlyTimes)

times: $(times)
.PHONY: times

$(ccuredTimes): ../run-trials $(workExec)
	./$< 1 './$(workExec) $(runArgs)' >$@. 2>&1
	mv $@. $@

%.times: when       = $(word 1, $(subst -, , $*))
%.times: where      = $(word 2, $(subst -, , $*))
%.times: sparsity   = $(word 3, $(subst -, , $*))
%.times: executable = $(when)-$(where).exe
%.times: ../run-trials $(executable)
	./$< $(sparsity) './$(executable) $(runArgs)' >$@. 2>&1
	mv $@. $@

MOSTLYCLEANFILES += *.times. *.times

root := /afs/cs.wisc.edu/p/cbi/public/build/cbiexp
datadir := data
srcdir := debug/usr/src/debug

sites ?= $(shell find sites -name '*.sites')
source-strip-prefixes = /usr/src/debug/
update-tools =

include $(root)/src/analysis-rules.mk

$(datadir)/stamp-labels:
	echo $(numRuns) >$@

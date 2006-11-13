root := ../../../../../../cbiexp
datadir := data
srcdir := debug/usr/src/debug

sites ?= $(shell find sites -name '*.sites')
source-strip-prefixes = /usr/src/debug/

include $(root)/src/analysis-rules.mk

$(datadir)/stamp-labels:
	echo $(numRuns) >$@

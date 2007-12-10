-include ../../../local.mk

root ?= /afs/cs.wisc.edu/p/cbi/public/build/cbiexp
datadir ?= data
srcdir ?= debug/usr/src/debug

sites ?= $(shell find sites -name '*.sites')
source-strip-prefixes ?= /usr/src/debug/
convert_reports_flags ?= --ignore-alien-units
update-tools ?=

include $(root)/src/analysis-rules.mk

$(datadir)/stamp-labels:
	echo $(numRuns) >$@

executable := ../bc-1.06/debug/bc/bc

inputs := $(wildcard ../inputs/*)
tests := $(notdir $(inputs))
traces := $(tests:=.trace)
signals := $(tests:=.signal)

all: $(traces) $(signals)

%.trace %.signal: runner $(executable) ../inputs/%
	./$^ $*.trace $*.signal

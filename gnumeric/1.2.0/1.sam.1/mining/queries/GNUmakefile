queries := $(basename $(wildcard *.sql))
outs := $(queries:=.out)

all: $(outs)
.PHONY: all

$(outs): %.out: %.sql
	{ /usr/bin/time psql -e -f $<; } >$@. 2>&1
	mv $@. $@

clean:
	rm -f $(outs) $(outs:=.)
.PHONY: clean

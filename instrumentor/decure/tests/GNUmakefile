cildir := ../../../../cil

#CFLAGS := -W -Wall -Werror

all: echo-cured

%-cured.c: %.c
	cp $< $@
	chmod a-w $@

%-cured: CC := $(cildir)/bin/ccured

clean:
	rm -f *-cured *.[io] *_combcured.c

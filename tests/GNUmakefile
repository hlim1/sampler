instrumenter := ../main
checker := ../checker
LOADLIBES := ../liblog/liblog.a

recurse = $(MAKE) -C $(@D) $(@F)


all: run

run: reverse.inst
	./$< once upon a time

check: $(checker) headers.i
	$^

reverse.inst: %.inst: %.inst.c $(LOADLIBES)

reverse.inst.c: %.inst.c: $(instrumenter) %.i
	$^ >$@.
	egrep -v '^#' $@. | indent >$@

reverse.i: %.i: %.c
	$(CC) $(CPPFLAGS) $< $(OUTPUT_OPTION) -E

$(instrumenter) $(checker): force
	$(recurse)

../liblog/liblog.a: force
	$(recurse)

force:

.PHONY: force

clean:
	rm -f *.i *.o
	rm -f *.inst.c *.inst

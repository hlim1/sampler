precompute := ../../../libcountdown/precompute

all:

%.counts: $(precompute)
	SAMPLER_SPARSITY=$(strip $(subst -, SAMPLER_SEED=, $*)) $< $@

clean:
	rm -f *-*.counts

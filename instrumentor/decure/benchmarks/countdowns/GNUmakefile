precompute := ../../../../libcountdown/precompute

all:

%.counts: $(precompute)
	SAMPLER_SPARSITY=$(strip $(subst ., GSL_RNG_SEED=, $*)) $< $@

clean:
	rm -f *.*.counts

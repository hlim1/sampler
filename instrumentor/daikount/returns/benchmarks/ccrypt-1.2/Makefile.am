all-local: pristine-stamp

pristine-stamp: build-pristine standard/src/ccrypt
	./$<
	touch $@

standard/src/ccrypt: standard/src
	make -C $(dir $(@D))

standard/src:
	$(@D)/Bootstrap

clean-local: standard/clean
	rm -f pristine-stamp
	rm -rf cyphertext pristine

standard/clean:
	make -C $(@D) $(@F)
.PHONY: standard/clean

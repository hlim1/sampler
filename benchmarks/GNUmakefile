subdirs := bc-1.06 ccrypt-1.2 ccured


all: $(subdirs:=/all)

$(subdirs:=/all): force
	$(MAKE) -C $(@D) $(@F)

.PHONY: all %/all


times: $(subdirs:=/times)

$(subdirs:=/times): force
	$(MAKE) -C $(@D) $(@F)

.PHONY: times %/times


clean: $(subdirs:=/clean)

$(subdirs:=/clean): force
	$(MAKE) -C $(@D) $(@F)

.PHONY: clean %/clean


force:
.PHONY: force

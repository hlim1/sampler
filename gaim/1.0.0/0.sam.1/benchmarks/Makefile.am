SUBDIRS = bc-1.06 ccrypt-1.2 ccured

times = $(SUBDIRS:=/times)

times: $(times)

$(times): force
	$(MAKE) -C $(@D) $(@F)

.PHONY: times %/times

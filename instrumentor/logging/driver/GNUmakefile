top := ../..
include $(top)/defs.mk

driverdir := ../../driver
libdirs := $(driverdir)
targets := main

include $(top)/rules.mk


########################################################################


main: $(driverdir)/driver.cma $(main)
	$(link)

$(top)/%.cma: $(force)
	$(recurse)

$(top)/%.cmi: $(force)
	$(recurse)

$(driverdir)/%.cma: $(force)
	$(recurse)

$(driverdir)/%.cmi: $(force)
	$(recurse)

top := ..
include $(top)/defs.mk

targets := main

include $(top)/rules.mk


########################################################################


driver = driver
gccDriver = $(driver) $(gccInput) $(prefix) gccDriver
instDriver = $(gccDriver) $(tempFile) instDriver
prefix = prefix
tempFile = tempFile


########################################################################


main = $(instDriver) %
main: %: $(addsuffix .$(cmo), $(main))
	$(link)

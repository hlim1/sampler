top := ..
include $(top)/defs.mk

targets := driver.$(cma) main-gcc

include $(top)/rules.mk


########################################################################


driver.$(cma): $(instDriver)
	$(archive)

main-gcc = driver.$(cma) main-gcc.$(cmo)
main-gcc: $(main-gcc)
	$(link)

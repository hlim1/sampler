top := ..
include $(top)/defs.mk

targets := main driver.$(cma)

include $(top)/rules.mk


########################################################################


driver.$(cma): libs := str.$(cma) unix.$(cma)
driver.$(cma): $(instDriver)
	$(archive)

main = driver.$(cma) main.cmo
main: $(main)
	$(link)

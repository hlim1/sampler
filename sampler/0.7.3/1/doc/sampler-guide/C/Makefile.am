#figdir = figures
docname = sampler-guide
lang = C
omffile = $(docname)-$(lang).omf
entities =

include $(top_srcdir)/doc/xmldocs.make

dist-hook: app-dist-hook


TESTS = $(docname).xml $(omffile)
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout


html: html/stamp
.PHONY: html

html/stamp: $(docname).xml
	rm -rf html
	docbook2html -o html $<
	touch html/stamp

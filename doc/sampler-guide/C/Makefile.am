#figdir = figures
docname = sampler-guide
lang = C
omffile = $(docname)-$(lang).omf
entities =

include $(top_srcdir)/doc/xmldocs.make

dist-hook: app-dist-hook


TESTS = $(docname).xml $(omffile)
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout


html-local: $(docname).xml
	rm -f index.html ar??s??.html
	xsltproc --stringparam html.stylesheet $(docname).css --param admon.graphics 1 $<
	touch $@

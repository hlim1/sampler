#figdir = figures
docname = sampler-guide
lang = C
omffile = $(docname)-$(lang).omf
entities =

include $(top_srcdir)/doc/xmldocs.make
xml_files += $(docname).xsl $(docname).css

MOSTLYCLEANFILES = *.omf.out omf_timestamp

dist-hook: app-dist-hook


TESTS = $(docname).xml $(omffile)
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout


html-local: index.html

index.html: $(docname).xml $(docname).xsl
	rm -f index.html ar??s??.html
	xsltproc $<

.DELETE_ON_ERROR:

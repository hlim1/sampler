#figdir = figures
docname = sampler-guide
lang = C
omffile = $(docname)-$(lang).omf
entities =

include $(top_srcdir)/doc/xmldocs.make
xml_files += $(docname).xsl $(docname).css

clean_omf = *.omf.out omf_timestamp
clean_html = index.html ar??s??.html
MOSTLYCLEANFILES = $(clean_omf) $(clean_html)

dist-hook: app-dist-hook


TESTS = $(docname).xml $(omffile)
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout


html-local: index.html

index.html: $(docname).xml $(docname).xsl
	rm -f $(clean_html)
	xsltproc $<

.DELETE_ON_ERROR:

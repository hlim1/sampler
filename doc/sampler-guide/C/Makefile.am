#figdir = figures
docname = sampler-guide
lang = C
omffile = $(docname)-$(lang).omf
entities =

include $(top_srcdir)/doc/xmldocs.make

dist-hook: app-dist-hook


TESTS = $(docname).xml $(omffile)
XMLLINT = @XMLLINT@
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout

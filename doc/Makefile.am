AUTOMAKE_OPTIONS = 1.6

XSL_HTML := @XSL_HTML@

if HAVE_XSL_HTML
noinst_DATA = $(PACKAGE).html
endif

xml = $(PACKAGE).xml
EXTRA_DIST = $(xml)

TESTS = $(xml)
XMLLINT = @XMLLINT@
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout


$(PACKAGE).html: %.html: %.xml config.xml $(XSL_HTML)
	XML_CATALOG_FILES='$(XML_CATALOG_FILES)' xsltproc --nonet -o $@ $(XSL_HTML) $<

MOSTLYCLEANFILES = $(noinst_DATA)

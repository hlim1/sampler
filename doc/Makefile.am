xsldir := /usr/share/sgml/docbook/xsl-stylesheets

xml = $(PACKAGE).xml
noinst_DATA = $(PACKAGE).html

EXTRA_DIST = $(xml)

TESTS = $(xml)
TESTS_ENVIRONMENT = xmllint --valid --noout


%.html: %.xml
	xsltproc --nonet -o $@ $(xsldir)/xhtml/docbook.xsl $<

xsldir := /usr/share/sgml/docbook/xsl-stylesheets
xsl_html := $(xsldir)/xhtml/docbook.xsl

xml = $(PACKAGE).xml
noinst_DATA = $(PACKAGE).html

EXTRA_DIST = $(xml)

TESTS = $(xml)
TESTS_ENVIRONMENT = xmllint --valid --noout


%.html: %.xml config.xml $(xsl_html)
	xsltproc --nonet -o $@ $(xsl_html) $<

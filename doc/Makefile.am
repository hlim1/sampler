xsldir := /usr/share/sgml/docbook/xsl-stylesheets

noinst_DATA = $(PACKAGE).html

TESTS = $(PACKAGE).xml
TESTS_ENVIRONMENT = xmllint --valid --noout


%.html: %.xml
	xsltproc --nonet -o $@ $(xsldir)/xhtml/docbook.xsl $<

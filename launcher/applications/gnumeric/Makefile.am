all-local: gnome-gnumeric.png

gnome-gnumeric.png: ; ln -s /usr/share/pixmaps/$@ .


schemas = gnumeric-bug-isolation.schemas
EXTRA_DIST = $(schemas) gconf-1.0.dtd

TESTS = $(schemas)
XMLLINT = @XMLLINT@
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout

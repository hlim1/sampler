all-local: gnome-gnumeric.png

gnome-gnumeric.png: ; ln -s /usr/share/pixmaps/$@ .


schemas = gnumeric-bug-isolation.schemas
dtd := gconf-1.0.dtd
EXTRA_DIST = $(schemas)

TESTS = $(schemas)
XMLLINT = @XMLLINT@
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout

check-am: $(dtd)
$(dtd): ../$(dtd)
	$(LN_S) $< $@

links =						\
	stamp-executable			\
	gdb-commands				\
	gnome-gnumeric.png			\
	print-debug-info

all-local: $(links)

stamp-executable:
	ln -s ../../../../apps/gnumeric/cvs/branches/src/gnumeric executable
	touch $@

gdb-commands: ; ln -s ../../$@ .

gnome-gnumeric.png: ; ln -s /usr/share/pixmaps/$@ .

print-debug-info: ; ln -s ../../$@ .

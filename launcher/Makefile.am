SUBDIRS = python tray

package_data_DATA = gdb-commands
package_data_SCRIPTS = print-debug-info

EXTRA_DIST =					\
	$(package_data_DATA)			\
	$(package_data_SCRIPTS)

install-data-local:
	$(mkinstalldirs) $(DESTDIR)$(package_libdir)/applications

SUBDIRS += sampler


if ENABLE_SAMPLER

install-exec-hook:
	mv '$(DESTDIR)$(SAMPLER_EXECUTABLE)' '$(DESTDIR)$(launcherdir)/executable'
	$(LN_S) '$(launcherdir)/wrapper' '$(DESTDIR)$(SAMPLER_EXECUTABLE)'

uninstall-hook:
	rm -f '$(DESTDIR)$(launcherdir)/executable'

endif

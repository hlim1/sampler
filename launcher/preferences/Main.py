from gi.repository import GLib, Gtk
from sys import argv

import CommandLine


########################################################################


def activate(application):
    windows = application.get_windows()
    if windows:
        windows[0].present_with_time(Gtk.get_current_event_time())
    else:
        from PreferencesDialog import PreferencesDialog
        dialog = PreferencesDialog(application)
        GLib.idle_add(GLib.PRIORITY_DEFAULT_IDLE, PreferencesDialog.run, dialog)


def main():
    CommandLine.parse()
    application = Gtk.Application.new('edu.wisc.cs.cbi.Preferences', 0)
    application.connect('activate', activate)
    status = application.run(argv)
    exit(status)

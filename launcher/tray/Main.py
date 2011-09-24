import gi
gi.require_version('Gtk', '3.0')

from gi.repository import Gio, Gtk

from TrayIcon import TrayIcon

import CommandLine
import Keys
import Service

__pychecker__ = 'no-import'


########################################################################


def main():
    __pychecker__ = 'unusednames=tray'

    CommandLine.parse()
    unique = Service.unique()
    if not unique: return

    settings = Gio.Settings(Keys.BASE)
    tray = TrayIcon(settings)
    Gtk.main()

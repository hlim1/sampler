import gi
gi.require_version('Gtk', '3.0')

from gi.repository import Gio, Gtk
from os.path import abspath, dirname, join
from sys import path

path.insert(1, join(dirname(dirname(abspath(__file__))), 'common'))

from TrayIcon import TrayIcon

import Keys
import Service


########################################################################


def main():
    __pychecker__ = 'unusednames=tray'

    unique = Service.unique()
    if not unique: return

    settings = Gio.Settings(Keys.BASE)
    tray = TrayIcon(settings)
    Gtk.main()

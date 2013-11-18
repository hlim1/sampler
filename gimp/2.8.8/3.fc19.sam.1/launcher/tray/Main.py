import gi
gi.require_version('Gtk', '3.0')

from contextlib import closing
from gi.repository import Gio, Gtk
from os.path import abspath, dirname, join
from sys import path

path.insert(1, join(dirname(dirname(abspath(__file__))), 'common'))

from NotificationIcon import NotificationIcon

import Keys
import Service


########################################################################


def main():
    unique = Service.unique()
    if not unique: return

    settings = Gio.Settings(Keys.BASE)
    with closing(NotificationIcon(settings)):
        Gtk.main()

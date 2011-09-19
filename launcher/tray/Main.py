import gi
gi.require_version('Gtk', '3.0')

from gi.repository import GConf
from gi.repository import Gtk

from GConfDir import GConfDir
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

    client = GConf.Client.get_default()
    gconf_dir = GConfDir(client, Keys.root, GConf.ClientPreloadType.PRELOAD_ONELEVEL)

    tray = TrayIcon(client)
    Gtk.main()

    del gconf_dir

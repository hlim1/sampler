import pygtk
pygtk.require('2.0')

import dbus.glib
import gconf
import gnome
import gtk

from GConfDir import GConfDir
from UploaderTrayIcon import UploaderTrayIcon

import Keys
import SamplerConfig
import Service

__pychecker__ = 'no-import'


########################################################################


def main():
    gnome.program_init('tray', SamplerConfig.version)
    unique = Service.unique()
    if not unique: return

    client = gconf.client_get_default()
    gconf_dir = GConfDir(client, Keys.root, gconf.CLIENT_PRELOAD_ONELEVEL)

    tray = UploaderTrayIcon(client)
    tray.show_all()
    gtk.main()

    del gconf_dir

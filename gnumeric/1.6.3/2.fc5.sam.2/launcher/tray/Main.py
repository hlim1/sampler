import pygtk
pygtk.require('2.0')

import bonobo
import gconf
import gnome

from Factory import Factory
from GConfDir import GConfDir
from UploaderTrayIcon import UploaderTrayIcon

import Keys
import SamplerConfig


########################################################################


def main():
    gnome.program_init('tray', SamplerConfig.version)
    client = gconf.client_get_default()
    gconf_dir = GConfDir(client, Keys.root, gconf.CLIENT_PRELOAD_ONELEVEL)

    factory = Factory()
    tray = UploaderTrayIcon(client)
    tray.show_all()
    bonobo.main()

    del factory
    del gconf_dir

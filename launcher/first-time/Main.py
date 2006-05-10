import pygtk
pygtk.require('2.0')

import gconf
import gnome

from Factory import Factory
from FirstTime import FirstTime
from GConfDir import GConfDir

import Keys
import SamplerConfig


########################################################################


def main():
    gnome.program_init('first-time', SamplerConfig.version)

    client = gconf.client_get_default()
    gconf_dir = GConfDir(client, Keys.root, gconf.CLIENT_PRELOAD_NONE)

    dialog = FirstTime(client)
    factory = Factory(dialog)
    dialog.run()

    del factory
    del gconf_dir

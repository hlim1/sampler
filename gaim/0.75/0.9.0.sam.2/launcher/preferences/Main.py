import pygtk
pygtk.require('2.0')

import gconf
import gnome

from Factory import Factory
from PreferencesDialog import PreferencesDialog
from GConfDir import GConfDir

import Config
import Keys


########################################################################


def main(register):
    gnome.program_init('preferences', Config.version)

    client = gconf.client_get_default()
    dir = GConfDir(client, Keys.root, gconf.CLIENT_PRELOAD_NONE)

    dialog = PreferencesDialog(client)
    if register: factory = Factory(dialog)
    dialog.run()

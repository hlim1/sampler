import pygtk
pygtk.require('2.0')

import gconf
import gnome

from Factory import Factory
from FirstTime import FirstTime
from GConfDir import GConfDir

import Config
import Keys


########################################################################


gnome.program_init('first-time', Config.version)

client = gconf.client_get_default()
dir = GConfDir(client, Keys.root, gconf.CLIENT_PRELOAD_NONE)

dialog = FirstTime(client)
factory = Factory(dialog)
dialog.run()

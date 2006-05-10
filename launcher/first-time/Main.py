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
    dialog = FirstTime(client)
    Factory(dialog)
    dialog.run()

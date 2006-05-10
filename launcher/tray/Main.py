#!/usr/bin/python -O

import pygtk
pygtk.require('2.0')

import bonobo
import gconf
import gnome

from Factory import Factory
from GConfDir import GConfDir
from UploaderTrayIcon import UploaderTrayIcon

import SamplerConfig


########################################################################


def main():
    gnome.program_init('tray', SamplerConfig.version)
    client = gconf.client_get_default()

    Factory()
    tray = UploaderTrayIcon(client)
    tray.show_all()
    bonobo.main()

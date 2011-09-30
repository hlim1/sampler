import pygtk
pygtk.require('2.0')

import CommandLine
import Service


########################################################################


def main():
    CommandLine.parse()
    unique = Service.unique()

    if unique:
        unique.dialog.run()

    else:
        import os
        os.environ['DBUS_PYTHON_NO_DEPRECATED'] = '1'
        import dbus

        bus = dbus.SessionBus()
        remote = bus.get_object('edu.wisc.cs.cbi.FirstTime', '/edu/wisc/cs/cbi/FirstTime')
        remote.present()

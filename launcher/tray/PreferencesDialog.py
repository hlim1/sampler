import bonobo.activation

from BusyCursor import BusyCursor

import Config


########################################################################


def present():
    busy = BusyCursor()
    server = bonobo.activation.activate("iid == 'OAFIID:SamplerPreferences:" + Config.version + "'")
    print 'Preferences.present:', server

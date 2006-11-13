import sys
import Paths
sys.path.append(Paths.common)

import pygtk
pygtk.require('2.0')

import ORBit
import bonobo.activation

ORBit.load_typelib('Everything')
import CORBA

from AppConfig import AppConfig
from UserConfig import UserConfig

import Config
import Launcher
import Uploader


########################################################################


def main(configdir):
    app = AppConfig(configdir)
    user = UserConfig(configdir, app)

    monitor = bonobo.activation.activate("iid == 'OAFIID:SamplerMonitor:" + Config.version + "'")

    try:
        sparsity = user.sparsity()
        if sparsity > 0:
            outcome = Launcher.run_with_sampling(app, sparsity)
            if user.enabled():
                Uploader.upload(app, user, outcome, 'text/html')
        else:
            outcome = Launcher.run_without_sampling(app)

    finally:
        if monitor != None:
            try:
                monitor.unref()
            except CORBA.COMM_FAILURE:
                pass

    outcome.exit()

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
from SampledLauncher import SampledLauncher
from UnsampledLauncher import UnsampledLauncher
from UserConfig import UserConfig

import Config
import Uploader


########################################################################


def main(configdir):
    app = AppConfig(configdir)
    user = UserConfig(configdir, app)

    sparsity = user.sparsity()
    if sparsity > 0:
        launcher = SampledLauncher(app, user, sparsity)
    else:
        launcher = UnsampledLauncher(app)

    launcher.spawn()

    try:
        monitor = bonobo.activation.activate("iid == 'OAFIID:SamplerMonitor:0.1'")
        outcome = launcher.wait()

    finally:
        if monitor != None:
            try:
                monitor.unref()
            except CORBA.COMM_FAILURE:
                pass

    outcome.exit()

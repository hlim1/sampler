import sys
sys.path.append('@commondir@')

import pygtk
pygtk.require('2.0')

from AppConfig import AppConfig
from UserConfig import UserConfig

import Launcher


########################################################################


def main(configdir):
    app = AppConfig(configdir)
    user = UserConfig(configdir, app)

    sparsity = user.sparsity()
    if user.enabled() and sparsity > 0:
        outcome = Launcher.run_with_sampling(app, sparsity)
        Uploader.upload(app, user, outcome, 'text/html')
        outcome.exit()
    else:
        Launcher.run_without_sampling(app)

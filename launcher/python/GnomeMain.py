import AppConfig
import ConfigParser
import BaseMain
import GnomeUserConfig


def main(config_filename):
    '''Run an instrumented GNOME application.'''
    app = AppConfig.AppConfig(config_filename)
    user = GnomeUserConfig.GnomeUserConfig(config_filename, app)
    BaseMain.main(app, user)

import AppConfig
import BaseMain
import UserConfig


def main(config_filename):
    '''Run an instrumented application.'''
    app = AppConfig.AppConfig(config_filename)
    user = UserConfig.UserConfig(config_filename, app.config)
    BaseMain.main(app, user, 'text/plain')

import AppConfig
import BaseMain
import UserConfig


def main(app_filename, user_filename):
    """Run an instrumented application."""
    app = AppConfig.AppConfig(app_filename)
    user = UserConfig.UserConfig(user_filename)
    BaseMain.main(app, user)

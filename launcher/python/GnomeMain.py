import AppConfig
import BaseMain
import GnomeUserConfig


def main(app_filename):
    """Run an instrumented GNOME application."""
    app = AppConfig.AppConfig(app_filename)
    user = GnomeUserConfig.GnomeUserConfig(app_filename, app)
    BaseMain.main(app, user)

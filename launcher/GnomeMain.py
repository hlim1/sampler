import AppConfig
import BaseMain
import GnomeUserConfig


def main(app_filename):
    """Run an instrumented GNOME application and possibly upload the results."""
    app = AppConfig.AppConfig(app_filename)
    user = GnomeUserConfig.GnomeUserConfig(app)
    BaseMain.main(app, user)

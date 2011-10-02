from os.path import abspath, dirname, join
from sys import path, stderr

path.insert(1, join(dirname(dirname(abspath(__file__))), 'common'))


########################################################################


def main(name, wrapped, upload_headers, **extras):
    __pychecker__ = 'no-argsused'
    from gi.repository import Gio
    from glib import GError
    from AppConfig import AppConfig
    import Keys

    app = AppConfig(name, wrapped, upload_headers)
    settings = Gio.Settings(Keys.BASE)

    if settings[Keys.ASKED] and settings[Keys.MASTER]:
        import SampledLauncher
        sparsity = 100
        reporting_url = 'https://cbi.cs.wisc.edu/cbi/cgi-bin/sampler-upload.cgi'
        launcher = SampledLauncher.SampledLauncher(settings, app, sparsity, reporting_url)
    else:
        import UnsampledLauncher
        launcher = UnsampledLauncher.UnsampledLauncher(app)
    launcher.spawn()

    if not settings[Keys.ASKED]:
        try:
            Gio.DBusProxy.new_for_bus_sync(Gio.BusType.SESSION, Gio.DBusProxyFlags.DO_NOT_LOAD_PROPERTIES | Gio.DBusProxyFlags.DO_NOT_CONNECT_SIGNALS, None, 'edu.wisc.cs.cbi.FirstTime', '/edu/wisc/cs/cbi/FirstTime', 'org.gtk.Application', None).Activate('(a{sv})', None)
        except GError, error:
            print >>stderr, "warning: cannot activate CBI first-time dialog:", error

    if settings[Keys.SHOW_TRAY_ICON]:
        try:
            Gio.DBusProxy.new_for_bus_sync(Gio.BusType.SESSION, Gio.DBusProxyFlags.DO_NOT_LOAD_PROPERTIES | Gio.DBusProxyFlags.DO_NOT_CONNECT_SIGNALS, None, 'edu.wisc.cs.cbi.Monitor', '/edu/wisc/cs/cbi/Monitor', 'edu.wisc.cs.cbi.Monitor', None).activate()
        except GError, error:
            print >>stderr, "warning: cannot activate CBI tray icon:", error

    outcome = launcher.wait()
    outcome.exit()

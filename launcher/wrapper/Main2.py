import sys
import Paths
sys.path.append(Paths.common)


########################################################################


def main(name, wrapped, upload_headers, **extras):
    __pychecker__ = 'no-argsused'
    from AppConfig import AppConfig
    from UserConfig import UserConfig

    app = AppConfig(name, wrapped, upload_headers)
    user = UserConfig(name)

    sparsity = user.sparsity()
    if sparsity > 0:
        import SampledLauncher
        launcher = SampledLauncher.SampledLauncher(app, user, sparsity)
    else:
        import UnsampledLauncher
        launcher = UnsampledLauncher.UnsampledLauncher(app)

    launcher.spawn()

    if not user.asked():
        from subprocess import Popen
        Popen([Paths.first_time + '/first-time'])

    if user.show_tray_icon():
        from gi.repository import Gio
        from glib import GError
        try:
            Gio.DBusProxy.new_for_bus_sync(Gio.BusType.SESSION, Gio.DBusProxyFlags.DO_NOT_LOAD_PROPERTIES | Gio.DBusProxyFlags.DO_NOT_CONNECT_SIGNALS, None, 'edu.wisc.cs.cbi.Monitor', '/edu/wisc/cs/cbi/Monitor', 'edu.wisc.cs.cbi.Monitor', None).activate()
        except GError, error:
            print >>sys.stderr, "warning: cannot activate CBI tray icon:", error

    outcome = launcher.wait()
    outcome.exit()

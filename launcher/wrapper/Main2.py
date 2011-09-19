import sys
import Paths
sys.path.append(Paths.common)

import gi
gi.require_version('Gtk', '3.0')


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
        import dbus
        bus = dbus.SessionBus()
        remote = bus.get_object('edu.wisc.cs.cbi.Monitor', '/edu/wisc/cs/cbi/Monitor')
        try:
            remote.activate()
        except dbus.exceptions.DBusException, error:
            print >>sys.stderr, "warning: cannot activate CBI tray icon:", error

    outcome = launcher.wait()
    outcome.exit()

import sys
import Paths
sys.path.append(Paths.common)

import pygtk
pygtk.require('2.0')

import ORBit
ORBit.load_typelib('Everything')


########################################################################


def main(name, wrapped, upload_headers, **extras):
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

    import Activation
    monitor = Activation.activate("iid == 'OAFIID:SamplerMonitor:0.1'")

    try:
        outcome = launcher.wait()

    finally:
        if monitor != None:
            import CORBA
            try:
                monitor.unref()
            except CORBA.COMM_FAILURE:
                pass

    outcome.exit()

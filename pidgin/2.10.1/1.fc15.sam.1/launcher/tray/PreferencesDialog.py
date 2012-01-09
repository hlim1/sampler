def present():
    import os
    os.environ['DBUS_PYTHON_NO_DEPRECATED'] = '1'

    import dbus
    bus = dbus.SessionBus()
    remote = bus.get_object('edu.wisc.cs.cbi.Preferences', '/edu/wisc/cs/cbi/Preferences')
    remote.present()

def present():
    from gi.repository import Gio
    preferences = Gio.DBusProxy.new_for_bus_sync(Gio.BusType.SESSION, Gio.DBusProxyFlags.DO_NOT_LOAD_PROPERTIES | Gio.DBusProxyFlags.DO_NOT_CONNECT_SIGNALS, None, 'edu.wisc.cs.cbi.Preferences', '/edu/wisc/cs/cbi/Preferences', 'org.gtk.Application', None)
    preferences.Activate('(a{sv})', None)

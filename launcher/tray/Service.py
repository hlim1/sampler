import os
os.environ['DBUS_PYTHON_NO_DEPRECATED'] = '1'

from dbus.mainloop.glib import DBusGMainLoop

import dbus.service
from gi.repository import Gtk


class Server(dbus.service.Object):

    __slots__ = ['__clients']

    def __init__(self, bus_name):
        dbus.service.Object.__init__(self, bus_name=bus_name, object_path='/edu/wisc/cs/cbi/Monitor')
        self.__clients = set()

        broker = bus_name.get_bus().get_object('org.freedesktop.DBus', '/org/freedesktop/DBus')
        broker.connect_to_signal('NameOwnerChanged', self.__owner_changed, dbus_interface='org.freedesktop.DBus', arg2='')

    @dbus.service.method(dbus_interface='edu.wisc.cs.cbi.Monitor', sender_keyword='sender', in_signature='', out_signature='')
    def activate(self, sender):
        assert sender.startswith(':')
        assert sender not in self.__clients
        self.__clients.add(sender)

    def __owner_changed(self, name, seller, buyer):
        assert buyer == ''
        if name == seller and name.startswith(':'):
            try:
                self.__clients.remove(name)
                if not self.__clients:
                    Gtk.main_quit()
            except KeyError:
                pass


def unique():
    DBusGMainLoop(set_as_default=True)
    bus = dbus.SessionBus()

    try:
        bus_name = dbus.service.BusName('edu.wisc.cs.cbi.Monitor', bus=bus, do_not_queue=True)
    except dbus.exceptions.NameExistsException:
        return None

    return Server(bus_name)

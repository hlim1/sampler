from LazyWidget import LazyWidget


########################################################################


class PopupMenu(object):

    __slots__ = ['__about', '__client', '__master', '__notifier', '__tray', '__widget']

    def __init__(self, client, tray):
        from AboutDialog import AboutDialog
        from MasterNotifier import MasterNotifier
        import Paths
        import Signals
        import gtk.glade

        xml = gtk.glade.XML(Paths.glade, 'popup')
        Signals.autoconnect(self, xml)

        self.__about = AboutDialog(client)
        self.__client = client
        self.__master = xml.get_widget('menu-master')
        self.__notifier = MasterNotifier(self.__client, self.__master.set_active)
        self.__tray = tray
        self.__widget = xml.get_widget('popup')

    def popup(self, event):
        import gtk.gdk
        assert event.type == gtk.gdk.BUTTON_PRESS
        self.__widget.popup(None, None, self.position, event.button, event.time)

    def position(self, menu):
        tray = self.__tray
        x, y = tray.window.get_origin()

        allocation = tray.allocation
        x += allocation.x
        y += allocation.y

        if y > tray.get_screen().get_height() / 2:
            y -= menu.size_request()[1]
        else:
            y += allocation.height

        return x, y, True

    def on_master_toggled(self, item):
        import Keys
        active = item.get_active()
        self.__client.set_bool(Keys.master, active)

    def on_preferences_activate(self, item):
        __pychecker__ = 'no-argsused'
        import PreferencesDialog
        PreferencesDialog.present()

    def on_about_activate(self, item):
        __pychecker__ = 'no-argsused'
        self.__about.present()

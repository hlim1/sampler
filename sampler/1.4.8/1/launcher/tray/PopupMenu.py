from LazyWidget import LazyWidget


########################################################################


class PopupMenu(LazyWidget):

    __slots__ = ['__about', '__client', '__master', '__notifier', '__tray']

    def __init__(self, client, tray):
        from AboutDialog import AboutDialog
        LazyWidget.__init__(self, 'popup')
        self.__about = AboutDialog(client)
        self.__client = client
        self.__tray = tray

    def populate(self, xml, widget):
        __pychecker__ = 'no-argsused'
        from MasterNotifier import MasterNotifier
        self.__master = xml.get_widget('menu-master')
        self.__notifier = MasterNotifier(self.__client, self.__master.set_active)

    def popup(self, event):
        import gtk.gdk
        assert event.type == gtk.gdk.BUTTON_PRESS
        self.widget().popup(None, None, self.position, event.button, event.time)

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

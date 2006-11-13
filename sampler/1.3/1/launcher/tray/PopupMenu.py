from LazyWidget import LazyWidget


########################################################################


class PopupMenu(LazyWidget):
    def __init__(self, client):
        from AboutDialog import AboutDialog
        LazyWidget.__init__(self, 'popup')
        self.__about = AboutDialog(client)
        self.__client = client

    def populate(self, xml, widget):
        from MasterNotifier import MasterNotifier
        self.__master = xml.get_widget('menu-master')
        self.__notifier = MasterNotifier(self.__client, self.__master.set_active)

    def popup(self, event):
        import gtk.gdk
        assert event.type == gtk.gdk.BUTTON_PRESS
        self.widget().popup(None, None, None, event.button, event.time)

    def on_master_toggled(self, item):
        import Keys
        active = item.get_active()
        self.__client.set_bool(Keys.master, active)

    def on_preferences_activate(self, item):
        import PreferencesDialog
        PreferencesDialog.present()

    def on_about_activate(self, item):
        self.__about.present()

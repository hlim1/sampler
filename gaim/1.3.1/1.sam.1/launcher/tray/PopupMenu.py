import gtk.gdk

from AboutDialog import AboutDialog
from LazyWidget import LazyWidget
from MasterNotifier import MasterNotifier

import Keys
import Paths
import PreferencesDialog


########################################################################


class PopupMenu(LazyWidget):
    def __init__(self, client):
        LazyWidget.__init__(self, 'popup')
        self.__about = AboutDialog(client)
        self.__client = client

    def populate(self, xml, widget):
        self.__master = xml.get_widget('menu-master')
        self.__notifier = MasterNotifier(self.__client, self.__master.set_active)

    def popup(self, event):
        assert event.type == gtk.gdk.BUTTON_PRESS
        self.widget().popup(None, None, None, event.button, event.time)

    def on_master_toggled(self, item):
        active = item.get_active()
        self.__client.set_bool(Keys.master, active)

    def on_preferences_activate(self, item):
        PreferencesDialog.present()

    def on_about_activate(self, item):
        self.__about.present()

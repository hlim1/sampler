import gtk.gdk
import gtk.glade

from BusyCursor import BusyCursor
from GConfNotifier import GConfNotifier
from PreferencesDialog import PreferencesDialog
from PopupMenu import PopupMenu

import Keys
import Signals
import trayicon


class UploaderTrayIcon(trayicon.TrayIcon):

    def on_button_press(self, widget, event):
        if event.type == gtk.gdk.BUTTON_PRESS:
            if event.button == 1:
                self.__preferences.present()
            elif event.button == 3:
                self.__popup.popup(event)

    def __master_refresh(self, *args):
        if self.__client.get_bool(Keys.master):
            file = 'small-enabled.png'
        else:
            file = 'small-disabled.png'

        self.__image.set_from_file(file)

    def __init__(self, client, model):
        trayicon.TrayIcon.__init__(self, 'sampler')
        BusyCursor.top = self

        self.__busy = None
        self.__preferences = PreferencesDialog(client, model)
        self.__popup = PopupMenu(client, self.__preferences)

        xml = gtk.glade.XML('tray.glade', 'eventbox')
        Signals.autoconnect(self, xml)
        self.add(xml.get_widget('eventbox'))

        self.__image = xml.get_widget('image')
        self.__client = client
        self.__notifier = GConfNotifier(client, Keys.master, self.__master_refresh)
        self.__master_refresh()

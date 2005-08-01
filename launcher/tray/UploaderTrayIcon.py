import egg.trayicon
import gtk

from BusyCursor import BusyCursor
from PopupMenu import PopupMenu
from StatusIcon import StatusIcon

import Keys
import Paths
import PreferencesDialog
import Signals


class UploaderTrayIcon(egg.trayicon.TrayIcon):

    def on_button_press(self, widget, event):
        if event.type == gtk.gdk.BUTTON_PRESS:
            if event.button == 1:
                PreferencesDialog.present()
            elif event.button == 3:
                self.__popup.popup(event)

    def __init__(self, client):
        egg.trayicon.TrayIcon.__init__(self, 'sampler')
        BusyCursor.top = self

        self.__busy = None
        self.__popup = PopupMenu(client)

        xml = gtk.glade.XML(Paths.glade, 'eventbox')
        Signals.autoconnect(self, xml)
        self.add(xml.get_widget('eventbox'))

        image = xml.get_widget('image')
        self.__notifier = StatusIcon(client, image, gtk.ICON_SIZE_LARGE_TOOLBAR)

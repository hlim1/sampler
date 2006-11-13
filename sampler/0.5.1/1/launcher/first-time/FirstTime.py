import gnome.ui
import gtk
import gtk.glade

from MasterNotifier import MasterNotifier
from StatusIcon import StatusIcon
from WindowIcon import WindowIcon

import Keys
import Paths
import Signals


########################################################################
#
#  GUI callbacks and helpers for first-time opt-in dialog
#


class FirstTime:
    def __get_widget(self, name):
        return self.__xml.get_widget(name)

    def __init__(self, client):
        root = 'first-time'
        self.__xml = gtk.glade.XML(Paths.glade, root)
        self.__dialog = self.__get_widget(root)
        Signals.autoconnect(self, self.__xml)

        # replace the HRef button with a clone of itself to work around a libglade bug
        # <http://bugzilla.gnome.org/show_bug.cgi?id=112470>
        oldLink = self.__get_widget('learn-more')
        newLink = gnome.ui.HRef(oldLink.get_property('url'), oldLink.get_property('label'))
        linkParent = oldLink.parent
        oldLink.destroy()
        linkParent.add(newLink)
        newLink.show()

        # hook up state-linked icons
        image = self.__get_widget('image')
        self.__image_updater = StatusIcon(client, image, gtk.ICON_SIZE_DIALOG)
        self.__icon_updater = WindowIcon(client, self.__dialog)

        # hook up state-linked radio buttons
        self.__client = client
        self.__notifier = MasterNotifier(client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        self.__radio_refresh('yes', enabled)
        self.__radio_refresh('no', not enabled)

    def __radio_refresh(self, name, active):
        radio = self.__get_widget(name)
        details = self.__get_widget(name + '-details')
        radio.set_active(active)
        details.set_sensitive(active)

    def on_yes_toggled(self, yes):
        enabled = yes.get_active()
        self.__client.set_bool(Keys.master, enabled)

    def on_response(self, dialog, response):
        self.__client.set_bool(Keys.asked, gtk.TRUE)

    def run(self):
        result = self.__dialog.run()
        self.__dialog.destroy()
        return result

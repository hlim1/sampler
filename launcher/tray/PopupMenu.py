import gnome.ui
import gtk

from AboutDialog import AboutDialog
from MasterNotifier import MasterNotifier
import Paths

__pychecker__ = 'no-import'


########################################################################


class PopupMenu(object):

    __slots__ = ['__about', '__client', '__master', '__notifier', '__tray', '__widget']

    def __init__(self, client, tray):
        builder = gtk.Builder()
        builder.add_from_file(Paths.ui)
        builder.connect_signals(self)

        self.__about = AboutDialog(client, builder)
        self.__client = client
        self.__master = builder.get_object('menu-master')
        self.__notifier = MasterNotifier(self.__client, self.__master.set_active)
        self.__tray = tray
        self.__widget = builder.get_object('ui-manager').get_widget('/popup')

    def popup(self, button, activate_time):
        self.__widget.popup(None, None, gtk.status_icon_position_menu, button, activate_time, self.__tray)

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

    def on_about_delete(self, dialog, event):
        return self.__about.on_about_delete(dialog, event)

    def on_about_response(self, dialog, response):
        return self.__about.on_about_response(dialog, response)

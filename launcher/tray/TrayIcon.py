from gi.repository import Gtk

import BlipIcons
import Keys
from MasterNotifier import MasterNotifier
import Paths
import PreferencesDialog


class TrayIcon(object):

    __slots__ = ['__about', '__client', '__menu_master', '__notifier', '__popup', '__status_icon']

    def __init__(self, client):
        Gtk.about_dialog_set_url_hook(self.__url_hook)

        builder = Gtk.Builder()
        builder.add_from_file(Paths.ui)
        builder.connect_signals(self)

        self.__about = builder.get_object('about')
        self.__menu_master = builder.get_object('menu-master')
        self.__popup = builder.get_object('ui-manager').get_widget('/ui/popup')
        self.__status_icon = builder.get_object('status-icon')

        self.__client = client
        self.__notifier = MasterNotifier(client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        description = ('disabled', 'enabled')[enabled]
        pixbuf = self.__about.render_icon(BlipIcons.stock[enabled], BlipIcons.ICON_SIZE_EMBLEM, '')
        self.__about.set_icon(pixbuf)
        self.__about.set_property('logo', pixbuf)
        self.__menu_master.set_active(enabled)
        self.__status_icon.set_from_stock(BlipIcons.stock[enabled])
        self.__status_icon.set_tooltip('Automatic reporting is %s' % description)

    def __url_hook(self, dialog, link):
        __pychecker__ = 'no-argsused'
        pass

    # popup menu handlers

    def on_master_toggled(self, item):
        active = item.get_active()
        self.__client.set_bool(Keys.master, active)

    def on_preferences_activate(self, item):
        __pychecker__ = 'no-argsused'
        PreferencesDialog.present()

    def on_about_activate(self, item):
        __pychecker__ = 'no-argsused'
        self.__about.present()

    # about dialog handlers

    def on_about_delete(self, dialog, event):
        return True

    def on_about_response(self, dialog, response):
        if response < 0:
            dialog.hide()
            dialog.emit_stop_by_name('response')
            return True
        else:
            return False

    # status icon handlers

    def on_status_icon_activate(self, status_icon):
        __pychecker__ = 'no-argsused'
        PreferencesDialog.present()

    def on_status_icon_popup_menu(self, status_icon, button, activate_time):
        self.__popup.popup(None, None, Gtk.status_icon_position_menu, button, activate_time, status_icon)

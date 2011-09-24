from gi.repository import Gio, Gtk

import Keys
import Paths


class TrayIcon(object):

    __slots__ = ['__about', '__popup']

    def __init__(self, settings):
        Gtk.about_dialog_set_url_hook(self.__url_hook)

        builder = Gtk.Builder()
        builder.add_from_file(Paths.ui)
        builder.connect_signals(self)

        from AboutBoxIcon import AboutBoxIcon
        self.__about = builder.get_object('about')
        AboutBoxIcon(settings, self.__about)

        from StatusIcon import StatusIcon
        StatusIcon(settings, builder.get_object('status-icon'))

        self.__popup = builder.get_object('ui-manager').get_widget('/ui/popup')
        menu_master = builder.get_object('menu-master')
        settings.bind(Keys.MASTER, menu_master, 'active', Gio.SettingsBindFlags.DEFAULT)

    def __url_hook(self, dialog, link):
        __pychecker__ = 'no-argsused'
        pass

    def __activate_preferences_dialog(self):
        preferences = Gio.DBusProxy.new_for_bus_sync(Gio.BusType.SESSION, Gio.DBusProxyFlags.DO_NOT_LOAD_PROPERTIES | Gio.DBusProxyFlags.DO_NOT_CONNECT_SIGNALS, None, 'edu.wisc.cs.cbi.Preferences', '/edu/wisc/cs/cbi/Preferences', 'org.gtk.Application', None)
        preferences.Activate('(a{sv})', None)

    # popup menu handlers

    def on_preferences_activate(self, item):
        __pychecker__ = 'no-argsused'
        self.__activate_preferences_dialog()

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
        self.__activate_preferences_dialog()

    def on_status_icon_popup_menu(self, status_icon, button, activate_time):
        self.__popup.popup(None, None, Gtk.status_icon_position_menu, button, activate_time, status_icon)

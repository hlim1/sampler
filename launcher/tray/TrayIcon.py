from gi.repository import Gio, Gtk
from os.path import abspath, dirname, join

import Keys
from SamplerConfig import version


class TrayIcon(object):

    __slots__ = ['__about', '__popup']

    def __init__(self, settings):
        builder = Gtk.Builder()
	home = dirname(abspath(__file__))
        builder.add_from_file(join(home, 'tray.ui'))
        builder.connect_signals(self)

        from AboutBoxIcon import AboutBoxIcon
        self.__about = builder.get_object('about')
        self.__about.props.version = version
        AboutBoxIcon(settings, self.__about)

        from StatusIcon import StatusIcon
        status_icon = builder.get_object('status-icon')
        StatusIcon(settings, status_icon)

        self.__popup = builder.get_object('ui-manager').get_widget('/ui/popup')
        menu_master = builder.get_object('menu-master')
        settings.bind(Keys.MASTER, menu_master, 'active', Gio.SettingsBindFlags.DEFAULT)

    # popup menu handlers

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

    # change arguments to "self, menu, status_icon" once Fedora 15 (Gtk-3.0) is no longer supported
    def __position_menu(self, *args):
        menu = args[0]
        status_icon = args[-1]
        return Gtk.StatusIcon.position_menu(menu, status_icon)

    def __show_menu(self, status_icon, button, activate_time):
        self.__popup.popup(None, None, self.__position_menu, status_icon, button, activate_time)

    def on_status_icon_activate(self, status_icon):
        self.__show_menu(status_icon, 0, Gtk.get_current_event_time())

    def on_status_icon_popup_menu(self, status_icon, button, activate_time):
        self.__show_menu(status_icon, button, activate_time)

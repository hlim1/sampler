from gi.repository import Gtk

import Keys


########################################################################
#
#  GUI callbacks and helpers for first-time opt-in dialog
#


class FirstTime(object):

    __slots__ = ['__client', '__builder', '__dialog', '__dir', '__icon_updater', '__image_updater', '__notifier']

    def __get_widget(self, name):
        return self.__builder.get_object(name)

    def __init__(self, application):
        import Paths
        self.__builder = Gtk.Builder()
        self.__builder.add_from_file(Paths.ui)
        self.__dialog = self.__get_widget('first-time')
        self.__dialog.set_application(application)
        self.__builder.connect_signals(self)

        # hook up GConf configuration monitoring
        from gi.repository import GConf
        from GConfDir import GConfDir
        self.__client = GConf.Client.get_default()
        self.__dir = GConfDir(self.__client, Keys.root, GConf.ClientPreloadType.PRELOAD_NONE)

        # hook up state-linked icons
        from StatusIcon import StatusIcon
        from WindowIcon import WindowIcon
        image = self.__get_widget('image')
        self.__image_updater = StatusIcon(self.__client, image, Gtk.IconSize.DIALOG)
        self.__icon_updater = WindowIcon(self.__client, self.__dialog)

        # hook up state-linked radio buttons
        from MasterNotifier import MasterNotifier
        self.__notifier = MasterNotifier(self.__client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        self.__radio_refresh('yes', enabled)
        self.__radio_refresh('no', not enabled)

    def __radio_refresh(self, name, active):
        radio = self.__get_widget(name)
        details = self.__get_widget(name + '-details')
        radio.set_active(active)
        details.set_visible(active)

    def on_yes_toggled(self, yes):
        enabled = yes.get_active()
        self.__client.set_bool(Keys.master, enabled)

    def on_response(self, dialog, response):
        __pychecker__ = 'no-argsused'
        if response == Gtk.ResponseType.OK:
            self.__client.set_bool(Keys.asked, True)

    def run(self):
        result = self.__dialog.run()
        self.__dialog.destroy()
        return result

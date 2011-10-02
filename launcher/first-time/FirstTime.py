from gi.repository import Gtk
from os.path import abspath, dirname, join

import Keys


########################################################################
#
#  GUI callbacks and helpers for first-time opt-in dialog
#


class FirstTime(object):

    __slots__ = ['__dialog', '__settings']

    def __init__(self, application):
        builder = Gtk.Builder()
	home = dirname(abspath(__file__))
        builder.add_from_file(join(home, 'first-time.ui'))
        builder.connect_signals(self)
        get_widget = builder.get_object

        # grab top-level dialog and claim ownership
        self.__dialog = get_widget('first-time')
        self.__dialog.set_application(application)

        # hook up GSettings configuration monitoring
        from gi.repository import Gio
        self.__settings = Gio.Settings(Keys.BASE)

        # hook up state-linked icons
        from StatusIcon import StatusIcon
        from WindowIcon import WindowIcon
        image = get_widget('image')
        StatusIcon(self.__settings, image)
        WindowIcon(self.__settings, self.__dialog)

        # hook up state-linked radio buttons
        self.__bind_master(get_widget, 'yes', Gio.SettingsBindFlags.DEFAULT)
        self.__bind_master(get_widget, 'no', Gio.SettingsBindFlags.INVERT_BOOLEAN)

    def __bind_master(self, get_widget, sense, flags):
        self.__settings.bind(Keys.MASTER, get_widget(sense), 'active', flags)
        self.__settings.bind(Keys.MASTER, get_widget(sense + '-details'), 'visible', flags)

    def on_response(self, dialog, response):
        __pychecker__ = 'no-argsused'
        if response == Gtk.ResponseType.OK:
            self.__settings['asked'] = True

    def run(self):
        result = self.__dialog.run()
        self.__dialog.destroy()
        return result

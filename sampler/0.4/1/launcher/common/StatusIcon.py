import types

import gtk.gdk

from MasterNotifier import MasterNotifier
from LazyIcon import LazyIcon

import Keys


class StatusIcon:
    def __init__(self, client, widget, disabled, enabled):
        self.__widget = widget
        self.__icons = map(LazyIcon, [disabled, enabled])
        self.__notifier = MasterNotifier(client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        self.__widget.set_from_pixbuf(self.__icons[enabled].get())        

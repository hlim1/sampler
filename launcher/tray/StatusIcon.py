import types

import gtk.gdk

from GConfNotifier import GConfNotifier

import Keys


class StatusIcon:
    def __init__(self, client, icons, callback):
        self.__client = client
        self.__icons = icons
        self.__callback = callback

        self.__notify = GConfNotifier(client, Keys.master, self.__enabled_refresh)
        self.__enabled_refresh()

    def __enabled_refresh(self, *args):
        self.__callback(self.__icons.get(self.__client))        

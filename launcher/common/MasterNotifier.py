import gconf

from GConfNotifier import GConfNotifier

import Keys


class MasterNotifier(GConfNotifier):
    def __init__(self, client, callback):
        GConfNotifier.__init__(self, client, Keys.master, self.__changed)
        self.__client = client
        self.__callback = callback
        self.__changed()

    def __changed(self, *args):
        enabled = self.__client.get_bool(Keys.master)
        self.__callback(enabled)

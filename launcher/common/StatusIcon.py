from MasterNotifier import MasterNotifier

import BlipIcons
import Keys


class StatusIcon:

    def __init__(self, client, widget, size):
        self.__widget = widget
        self.__size = size
        self.__notifier = MasterNotifier(client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        self.__widget.set_from_stock(BlipIcons.stock[enabled], self.__size)

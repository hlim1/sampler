import gtk

from MasterNotifier import MasterNotifier

import BlipIcons


class WindowIcon:
    def __init__(self, client, widget):
        self.__widget = widget
        self.__notify = MasterNotifier(client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        pixbuf = self.__widget.render_icon(BlipIcons.stock[enabled], gtk.ICON_SIZE_MENU, "")
        self.__widget.set_icon(pixbuf)

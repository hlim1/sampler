from LazyIcon import LazyIcon
from MasterNotifier import MasterNotifier


class WindowIcon:
    __disabled = LazyIcon('disabled-16.png')
    __enabled = LazyIcon('enabled-16.png')
    __images = [__disabled, __enabled]

    def __init__(self, client, widget):
        self.__widget = widget
        self.__notify = MasterNotifier(client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        image = WindowIcon.__images[enabled].get()
        self.__widget.set_icon(image)

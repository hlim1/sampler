from MasterNotifier import MasterNotifier
from WindowIcon import WindowIcon


class AboutDialog(object):

    __slots__ = ['__icon_updater', '__notifier', '__widget']

    def __init__(self, client, builder):
        self.__widget = builder.get_object('about')
        self.__icon_updater = WindowIcon(client, self.__widget)
        self.__notifier = MasterNotifier(client, self.__enabled_refresh)

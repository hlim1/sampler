from ConfigParser import ConfigParser
import os.path

import gconf

from GConfNotifier import GConfNotifier

import Keys


class Application:
    def __init__(self, client, model, path):
        config = ConfigParser()
        config.read(os.path.join(path, 'config'))
        self.__root = config.get('application', 'gconf-root')
        self.name = config.get('application', 'name')

        self.__client = client
        self.__notify = GConfNotifier(client, Keys.master, self.__gconf_notify, model)

        self.__iter = model.add_application(self)

    def __gconf_notify(self, client, id, entry, model):
        value = entry.value and entry.value.get_bool()
        model.row_changed(model.get_path(self.__iter), self.__iter)

    def __key(self, item):
        return self.__root + '/' + item

    def get_enabled(self):
        return self.__client.get_bool(self.__key('enabled'))

    def set_enabled(self, value):
        self.__client.set_bool(self.__key('enabled'), value)

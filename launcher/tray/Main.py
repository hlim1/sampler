import bonobo
import gconf

from AppFinder import AppFinder
from Application import Application
from AppModel import AppModel
from Factory import Factory
from FirstTime import FirstTime
from GConfDir import GConfDir
from UploaderTrayIcon import UploaderTrayIcon

import Keys


class Main:
    def __init__(self):
	client = gconf.client_get_default()
        self.__dir = GConfDir(client, Keys.root, gconf.CLIENT_PRELOAD_ONELEVEL)

        self.__factory = Factory(client)

        finder = AppFinder()
        model = AppModel()
        for path in finder:
            app = Application(client, model, path)

        tray = UploaderTrayIcon(client, model)
        tray.show_all()

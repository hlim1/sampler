import bonobo
import gtk

import Config


class Factory(bonobo.GenericFactory):
    def __builder(self, factory, product):
        gtk.idle_add(self.__dialog.present)

    def __init__(self, dialog):
        self.__dialog = dialog
        bonobo.GenericFactory.__init__(self, 'OAFIID:SamplerPreferences_Factory:' + Config.version, self.__builder)

import bonobo


class Factory(bonobo.GenericFactory):
    def __builder(self, factory, product):
        import gtk
        gtk.idle_add(self.__dialog.present)

    def __init__(self, dialog):
        self.__dialog = dialog
        bonobo.GenericFactory.__init__(self, 'OAFIID:SamplerPreferences_Factory:0.1', self.__builder)

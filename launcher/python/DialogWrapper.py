import new
import types

import GtkImporter
import gtk.glade


########################################################################
#
#  Generic wrapper around GTK dialog widgets
#

class DialogWrapper:
    def __init__(self, app, name):
        self.__xml = gtk.glade.XML(app.path('interface.glade'), name)
        self.dialog = self.get_widget(name)

        callbacks = {}
        methods = self.__class__.__dict__
        for name in methods:
            method = methods[name]
            if type(method) == types.FunctionType:
                callbacks[name] = new.instancemethod(method, self, self.__class__)
        self.__xml.signal_autoconnect(callbacks)

    def get_widget(self, name):
        return self.__xml.get_widget(name)

    def run(self):
        return self.dialog.run()

    def hide(self):
        return self.dialog.hide()

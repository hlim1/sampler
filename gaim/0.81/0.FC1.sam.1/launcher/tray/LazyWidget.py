import gtk.glade

from BusyCursor import BusyCursor

import Paths
import Signals

class LazyWidget:
    def __init__(self, root):
        self.__root = root
        self.__widget = None

    def populate(self, xml, widget):
        return

    def widget(self):
        if not self.__widget:
            busy = BusyCursor()
            xml = gtk.glade.XML(Paths.glade, self.__root)
            self.__widget = xml.get_widget(self.__root)
            Signals.autoconnect(self, xml)
            self.populate(xml, self.__widget)

        return self.__widget

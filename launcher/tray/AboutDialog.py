import gtk.gdk
import gtk.glade

from LazyDialog import LazyDialog

import Config
import Paths


class AboutDialog(LazyDialog):
    def __init__(self, client):
        LazyDialog.__init__(self, client, 'about')

    def populate(self, xml, widget):
        LazyDialog.populate(self, xml, widget)
        widget.set_property('name', 'Feedback Collector')
        widget.set_property('version', Config.version)

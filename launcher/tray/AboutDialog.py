import gtk.gdk
import gtk.glade

from LazyDialog import LazyDialog
import Paths


class AboutDialog(LazyDialog):
    def __init__(self, client):
        LazyDialog.__init__(self, client, 'about')

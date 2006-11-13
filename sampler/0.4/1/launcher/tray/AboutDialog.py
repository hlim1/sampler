from LazyDialog import LazyDialog

import Config
import Paths


class AboutDialog(LazyDialog):
    def __init__(self, client):
        LazyDialog.__init__(self, client, 'about')

    def populate(self, xml, widget):
        LazyDialog.populate(self, xml, widget)
        widget.set_property('name', 'Bug Isolation Monitor')
        widget.set_property('version', Config.version)

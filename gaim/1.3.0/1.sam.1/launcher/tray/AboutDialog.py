from LazyDialog import LazyDialog
from MasterNotifier import MasterNotifier

import BlipIcons
import Config
import Paths


class AboutDialog(LazyDialog):
    def __init__(self, client):
        LazyDialog.__init__(self, client, 'about')
        self.__notifier = MasterNotifier(client, self.__enabled_refresh)

    def populate(self, xml, widget):
        LazyDialog.populate(self, xml, widget)
        widget.set_property('name', 'Bug Isolation Monitor')
        widget.set_property('version', Config.version)

    def __enabled_refresh(self, enabled):
        widget = self.widget()
        pixbuf = widget.render_icon(BlipIcons.stock[enabled], BlipIcons.ICON_SIZE_EMBLEM, "")
        widget.set_property('logo', pixbuf)

import gtk

from LazyWidget import LazyWidget
from WindowIcon import WindowIcon

import Paths


class LazyDialog(LazyWidget):
    def __init__(self, client, root):
        LazyWidget.__init__(self, root)
        self.__client = client

    def populate(self, xml, widget):
        LazyWidget.populate(self, xml, widget)
        self.__icon_updater = WindowIcon(self.__client, widget)

    def present(self):
        self.widget().present()

    def on_dialog_delete(self, dialog, event):
        return True

    def on_dialog_response(self, dialog, response):
        if response < 0:
            dialog.hide()
            dialog.emit_stop_by_name('response')
            return True

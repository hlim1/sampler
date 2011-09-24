import BlipIcons
import Keys
from StatusIcon import StatusIcon


class WindowIcon(StatusIcon):

    def set_icon(self, widget, enabled):
        pixbuf = widget.render_icon(enabled, BlipIcons.ICON_SIZE_EMBLEM, '')
        self.set_pixbuf(widget, pixbuf)

    def set_pixbuf(self, widget, pixbuf):
        widget.set_icon(pixbuf)

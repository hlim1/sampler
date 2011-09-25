from StatusIcon import StatusIcon


class WindowIcon(StatusIcon):

    def set_icon(self, widget, enabled, stock):
        import BlipIcons
        __pychecker__ = 'no-argsused'
        pixbuf = widget.render_icon(stock, BlipIcons.ICON_SIZE_EMBLEM, '')
        self.set_pixbuf(widget, pixbuf)

    def set_pixbuf(self, widget, pixbuf):
        widget.set_icon(pixbuf)

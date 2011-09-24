from WindowIcon import WindowIcon


class AboutBoxIcon(WindowIcon):

    def set_pixbuf(self, widget, pixbuf):
        WindowIcon.set_pixbuf(self, widget, pixbuf)
        widget.props.logo = pixbuf

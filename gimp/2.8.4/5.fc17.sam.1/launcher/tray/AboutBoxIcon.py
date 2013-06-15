from WindowIcon import WindowIcon


class AboutBoxIcon(WindowIcon):

    def set_icon(self, widget, enabled, themed):
        WindowIcon.set_icon(self, widget, enabled, themed)
        widget.props.logo_icon_name = themed

from EnabledIcon import EnabledIcon


class WindowIcon(EnabledIcon):

    def set_icon(self, widget, enabled, themed):
        __pychecker__ = 'no-argsused'
        widget.props.icon_name = themed

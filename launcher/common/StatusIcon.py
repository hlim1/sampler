import Keys


class StatusIcon(object):

    def __init__(self, settings, widget):
        settings.connect('changed::' + Keys.MASTER, self.__changed_enabled, widget)
        self.__changed_enabled(settings, Keys.MASTER, widget)

    def __changed_enabled(self, settings, key, widget):
        __pychecker__ = 'no-argsused'
        import BlipIcons
        master = settings[Keys.MASTER]
        enabled = BlipIcons.stock[master]
        self.set_icon(widget, enabled)

    def set_icon(self, widget, enabled):
        widget.props.stock = enabled
        widget.props.tooltip = 'Automatic reporting is %s' % ('disabled', 'enabled')[enabled]

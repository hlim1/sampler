import Keys


class StatusIcon(object):

    def __init__(self, settings, widget):
        settings.connect('changed::' + Keys.MASTER, self.__changed_enabled, widget)
        self.__changed_enabled(settings, Keys.MASTER, widget)

    def __changed_enabled(self, settings, key, widget):
        __pychecker__ = 'no-argsused'
        import BlipIcons
        enabled = settings[Keys.MASTER]
        stock = BlipIcons.stock[enabled]
        self.set_icon(widget, enabled, stock)

    def set_icon(self, widget, enabled, stock):
        widget.props.stock = stock
        widget.props.tooltip_markup = 'Automatic reporting is <b>%s</b>' % ('disabled', 'enabled')[enabled]

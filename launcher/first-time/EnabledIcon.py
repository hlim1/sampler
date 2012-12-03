import Keys


class EnabledIcon(object):

    def __init__(self, settings, widget):
        settings.connect('changed::' + Keys.MASTER, self.__changed_enabled, widget)
        self.__changed_enabled(settings, Keys.MASTER, widget)

    def __changed_enabled(self, settings, key, widget):
        __pychecker__ = 'no-argsused'
        enabled = settings[Keys.MASTER]
        themed = 'sampler-' + ('enabled' if enabled else 'disabled')
        self.set_icon(widget, enabled, themed)

    def set_icon(self, widget, enabled, themed):
        widget.props.icon_name = themed
        widget.props.tooltip_markup = 'Automatic reporting is <b>%s</b>' % ('disabled', 'enabled')[enabled]

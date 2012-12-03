import Keys


class EnabledIcon(object):

    def __init__(self, settings, widget):
        settings.connect('changed::' + Keys.MASTER, self.__changed_enabled, widget)
        self.__changed_enabled(settings, Keys.MASTER, widget)

    def __changed_enabled(self, settings, key, widget):
        enabled = 'enabled' if settings[key] else 'disabled'
        widget.props.icon_name = 'sampler-' + enabled
        widget.props.tooltip_markup = 'Automatic reporting is <b>%s</b>' % enabled

from MasterNotifier import MasterNotifier
from WindowIcon import WindowIcon


class AboutDialog(object):

    __slots__ = ['__icon_updater', '__notifier', '__widget']

    def __init__(self, client, builder):
        self.__widget = builder.get_object('about')
        self.__icon_updater = WindowIcon(client, self.__widget)
        self.__notifier = MasterNotifier(client, self.__enabled_refresh)

    def __enabled_refresh(self, enabled):
        import BlipIcons
        widget = self.__widget
        pixbuf = widget.render_icon(BlipIcons.stock[enabled], BlipIcons.ICON_SIZE_EMBLEM, "")
        widget.set_property('logo', pixbuf)

    def present(self):
        self.__widget.present()

    def on_about_delete(self, dialog, event):
        return True

    def on_about_response(self, dialog, response):
        if response < 0:
            dialog.hide()
            dialog.emit_stop_by_name('response')
            return True
        else:
            return False

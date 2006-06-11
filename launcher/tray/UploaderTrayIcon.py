from egg.trayicon import TrayIcon


class UploaderTrayIcon(TrayIcon):

    __slots__ = ['__busy', '__icon_notifier', '__popup', '__tooltips', '__tooltip_notifier']

    def on_button_press(self, widget, event):
        __pychecker__ = 'no-argsused'
        import gtk.gdk
        if event.type == gtk.gdk.BUTTON_PRESS:
            if event.button == 1:
                import PreferencesDialog
                PreferencesDialog.present()
            elif event.button == 3:
                self.__popup.popup(event)

    def __init__(self, client):
        import gtk
        import gtk.glade
        from BusyCursor import BusyCursor
        import Paths
        from PopupMenu import PopupMenu
        import Signals
        from StatusIcon import StatusIcon 

        TrayIcon.__init__(self, 'sampler')
        BusyCursor.top = self

        self.__busy = None
        self.__popup = PopupMenu(client)

        xml = gtk.glade.XML(Paths.glade, 'eventbox')
        Signals.autoconnect(self, xml)
        self.add(xml.get_widget('eventbox'))

        image = xml.get_widget('image')
        self.__icon_notifier = StatusIcon(client, image, gtk.ICON_SIZE_LARGE_TOOLBAR)

        from MasterNotifier import MasterNotifier
        self.__tooltips = gtk.Tooltips()
        self.__tooltip_notifier = MasterNotifier(client, self.__tooltip_refresh)
        self.__tooltips.enable()

    def __tooltip_refresh(self, enabled):
        messages = {True:  'Automatic reporting is enabled',
                    False: 'Automatic reporting is disabled'}
        message = messages[enabled]
        self.__tooltips.set_tip(self, message, None)

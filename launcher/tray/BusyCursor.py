class BusyCursor(object):

    __slots__ = []

    top = None
    __cursor = None

    def __init__(self):
        if BusyCursor.top and BusyCursor.top.window:
            import gtk.gdk
            if not BusyCursor.__cursor:
                BusyCursor.__cursor = gtk.gdk.Cursor(gtk.gdk.WATCH)
            BusyCursor.top.window.set_cursor(BusyCursor.__cursor)
            gtk.gdk.flush()

    def __del__(self):
        if BusyCursor.top and BusyCursor.top.window:
            BusyCursor.top.window.set_cursor(None)

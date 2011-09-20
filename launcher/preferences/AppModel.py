from gi.repository import Gtk


class AppModel(Gtk.ListStore):

    COLUMN_NAME = 0
    COLUMN_ENABLED = 1

    def add_application(self, app):
        iterator = self.append()
        self.set_row(iterator, (app, app))
        return iterator

    def __sort_name(self, model, a, b, unused):
        __pychecker__ = 'no-argsused'
        import locale
        a = self.get_value(a, self.COLUMN_NAME)
        b = self.get_value(b, self.COLUMN_NAME)
        return locale.strcoll(a.name, b.name)

    def __sort_enabled(self, model, a, b, unused):
        __pychecker__ = 'no-argsused'
        a = self.get_value(a, self.COLUMN_ENABLED)
        b = self.get_value(b, self.COLUMN_ENABLED)
        return a.get_enabled() - b.get_enabled()

    def __init__(self):
        from gi.repository import GObject
        Gtk.ListStore.__init__(self, GObject.TYPE_PYOBJECT, GObject.TYPE_PYOBJECT)
        assert self.get_flags() & Gtk.TREE_MODEL_ITERS_PERSIST

        self.set_sort_func(self.COLUMN_NAME, self.__sort_name)
        self.set_sort_func(self.COLUMN_ENABLED, self.__sort_enabled)
        self.set_sort_column_id(self.COLUMN_NAME, Gtk.SortType.ASCENDING)

import gtk

from AppFinder import AppFinder
from Application import Application
from AppModel import AppModel
from LazyDialog import LazyDialog
from MasterNotifier import MasterNotifier

import Keys
import Paths


class PreferencesDialog(LazyDialog):
    def __init__(self, client):
        LazyDialog.__init__(self, client, 'preferences')
        self.__client = client

        finder = AppFinder()
        self.__model = AppModel()
        for path in finder:
            app = Application(client, self.__model, path)

    def __name_data_func(self, column, renderer, model, iter):
        app = model.get_value(iter, model.COLUMN_NAME)
        renderer.set_property('text', app.name)

    def __enabled_data_func(self, column, renderer, model, iter):
        app = model.get_value(iter, model.COLUMN_ENABLED)
        renderer.set_property('active', app.get_enabled())

    def populate(self, xml, widget):
        LazyDialog.populate(self, xml, widget)

        self.__master = xml.get_widget('master')
        self.__applications_group = xml.get_widget('applications-group')
        self.__notifier = MasterNotifier(self.__client, self.__master_refresh)

        view = xml.get_widget('applications')

        selection = view.get_selection()
        selection.set_mode(gtk.SELECTION_NONE)

        renderer = gtk.CellRendererText()
        column = gtk.TreeViewColumn('Application', renderer)
        column.set_cell_data_func(renderer, self.__name_data_func)
        column.set_sort_column_id(self.__model.COLUMN_NAME)
        column.set_reorderable(gtk.TRUE)
        column.set_resizable(gtk.TRUE)
        view.append_column(column)

        renderer = gtk.CellRendererToggle()
        renderer.connect('toggled', self.on_application_toggled, self.__model)
        column = gtk.TreeViewColumn('Enabled', renderer)
        column.set_cell_data_func(renderer, self.__enabled_data_func)
        column.set_sort_column_id(self.__model.COLUMN_ENABLED)
        column.set_reorderable(gtk.TRUE)
        view.append_column(column)

        view.set_model(self.__model)

    def on_master_toggled(self, master):
        active = master.get_active()
        self.__client.set_bool(Keys.master, active)

    def __master_refresh(self, enabled):
        self.__master.set_active(enabled)
        self.__applications_group.set_sensitive(enabled)

    def on_application_toggled(self, renderer, path, model):
        path = int(path)
        iter = model.get_iter(path)
        app = model.get_value(iter, model.COLUMN_ENABLED)
        app.set_enabled(not app.get_enabled())

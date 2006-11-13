import gtk
import gtk.glade

from AppFinder import AppFinder
from Application import Application
from AppModel import AppModel
from MasterNotifier import MasterNotifier
from WindowIcon import WindowIcon

import Keys
import Paths
import Signals


class PreferencesDialog:
    def __init__(self, client):
        xml = gtk.glade.XML(Paths.glade, 'preferences')
        Signals.autoconnect(self, xml)
        self.__dialog = xml.get_widget('preferences')
        self.__client = client

        finder = AppFinder()
        model = AppModel()
        for path in finder:
            app = Application(client, model, path)

        self.__master = xml.get_widget('master')
        self.__applications_group = xml.get_widget('applications-group')
        self.__notifier = MasterNotifier(self.__client, self.__master_refresh)
        self.__icon = WindowIcon(client, self.__dialog)

        view = xml.get_widget('applications')

        selection = view.get_selection()
        selection.set_mode(gtk.SELECTION_NONE)

        renderer = gtk.CellRendererText()
        column = gtk.TreeViewColumn('Application', renderer)
        column.set_cell_data_func(renderer, self.__name_data_func)
        column.set_sort_column_id(model.COLUMN_NAME)
        column.set_reorderable(gtk.TRUE)
        column.set_resizable(gtk.TRUE)
        view.append_column(column)

        renderer = gtk.CellRendererToggle()
        renderer.connect('toggled', self.on_application_toggled, model)
        column = gtk.TreeViewColumn('Enabled', renderer)
        column.set_cell_data_func(renderer, self.__enabled_data_func)
        column.set_sort_column_id(model.COLUMN_ENABLED)
        column.set_reorderable(gtk.TRUE)
        view.append_column(column)

        view.set_model(model)

    def __name_data_func(self, column, renderer, model, iter):
        app = model.get_value(iter, model.COLUMN_NAME)
        renderer.set_property('text', app.name)

    def __enabled_data_func(self, column, renderer, model, iter):
        app = model.get_value(iter, model.COLUMN_ENABLED)
        renderer.set_property('active', app.get_enabled())

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

    def on_dialog_delete(self, dialog, event):
        return gtk.TRUE

    def on_dialog_response(self, dialog, response):
        if response < 0:
            dialog.hide()
            dialog.emit_stop_by_name('response')
            return gtk.TRUE

    def present(self):
        return self.__dialog.present()

    def run(self):
        return self.__dialog.run()

#!/usr/bin/python

import pygtk
pygtk.require('2.0')

import gnome
import gobject
import gtk
import gtk.glade
import trayicon


########################################################################


class UploaderModel(gtk.ListStore):

    def _add_row(self, enabled, running, name):
        iter = self.append()
        self.set_value(iter, 0, enabled)
        self.set_value(iter, 1, running)
        self.set_value(iter, 2, name)

    def _sort_enabled(self, a, b):
        a_value = self.get_value(a, 0)
        b_value = self.get_value(b, 0)
        return a_value - b_value

    def _sort_running(self, a, b):
        a_value = self.get_value(a, 1)
        b_value = self.get_value(b, 1)
        return (a_value != None) - (b_value != None)

    def __init__(self, gears):
        gtk.ListStore.__init__(self, gobject.TYPE_BOOLEAN, gtk.gdk.Pixbuf, gobject.TYPE_STRING)

        self.set_sort_func(0, self._sort_enabled)
        self.set_sort_func(1, self._sort_running)
        self.set_sort_column_id(2, gtk.SORT_ASCENDING)

        self._add_row(0, None, 'Nautilus')
        self._add_row(1, None, 'Evolution')
        self._add_row(0, gears, 'Gaim')
        self._add_row(1, gears, 'The GIMP')


########################################################################


class UploaderTrayIcon(trayicon.TrayIcon):

    def on_preferences(self, *args):
        self.preferences.present()

    def on_dialog_delete(self, *args):
        return gtk.TRUE

    def on_dialog_response(self, dialog, response):
        if response < 0:
            dialog.hide()
            dialog.emit_stop_by_name('response')
            return gtk.TRUE

    def on_about(self, *args):
        self.about.present()

    def on_master_toggled(self, master):
        self.applications_group.set_sensitive(master.get_active())

    def on_application_toggled(self, renderer, path, model):
        iter = model.get_iter(path)
        value = model.get_value(iter, 0)
        value = not value
        model.set(iter, 0, value)

    def on_button_press(self, widget, event):
        if event.type == gtk.gdk.BUTTON_PRESS:
            if event.button == 1:
                self.on_preferences()
            elif event.button == 3:
                self.popup.popup(None, None, None, event.button, event.time)

    def _get_glade(self, top):
        return gtk.glade.XML('tray.glade', top)

    def _get_widget(self, top):
        xml = self._get_glade(top)
        return (xml, xml.get_widget(top))

    def __init__(self):
        trayicon.TrayIcon.__init__(self, 'sampler')
        self.xml = gtk.glade.XML('tray.glade')

        self.add(self._get_widget('eventbox')[1])

        self.connect('button-press-event', self.on_button_press)

        (xml, self.popup) = self._get_widget('popup')
        xml.get_widget('menu-about').connect('activate', self.on_about)
        xml.get_widget('menu-preferences').connect('activate', self.on_preferences)
        
        (xml, self.about) = self._get_widget('about')
        self.about.connect('response', self.on_dialog_response)
        self.about.connect('delete_event', self.on_dialog_delete)

        (xml, self.preferences) = self._get_widget('preferences')
        self.preferences.connect('response', self.on_dialog_response)
        self.preferences.connect('delete_event', self.on_dialog_delete)

        self.applications_group = xml.get_widget('applications-group')
        master = xml.get_widget('master')
        master.connect('toggled', self.on_master_toggled)
        self.on_master_toggled(master)

        view = xml.get_widget('applications')
        gears = view.render_icon(gtk.STOCK_EXECUTE, gtk.ICON_SIZE_MENU, 'applications')
        model = UploaderModel(gears)

        renderer = gtk.CellRendererToggle()
        renderer.connect('toggled', self.on_application_toggled, model)
        column = gtk.TreeViewColumn('Enabled', renderer)
        column.add_attribute(renderer, 'active', 0)
        column.set_sort_column_id(0)
        column.set_reorderable(1)
        view.append_column(column)

        renderer = gtk.CellRendererPixbuf()
        column = gtk.TreeViewColumn('Running', renderer)
        column.add_attribute(renderer, 'pixbuf', 1)
        column.set_sort_column_id(1)
        column.set_reorderable(1)
        view.append_column(column)

        renderer = gtk.CellRendererText()
        column = gtk.TreeViewColumn('Application', renderer)
        column.add_attribute(renderer, 'text', 2)
        column.set_sort_column_id(2)
        column.set_reorderable(1)
        column.set_resizable(1)
        view.append_column(column)

        view.set_model(model)


########################################################################


gnome.init('Sampler', '0.2')

t = UploaderTrayIcon()
t.show_all()

gtk.main()

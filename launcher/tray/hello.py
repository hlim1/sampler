#!/usr/bin/python

import pygtk
pygtk.require('2.0')

import gnome
import gobject
import gtk
import gtk.glade
import trayicon

gnome.init('Sampler', '0.2')

t = trayicon.TrayIcon('sampler')

top = 'eventbox'
image = gtk.glade.XML('tray.glade', top).get_widget(top)
t.add(image)

top = 'popup'
menu_xml = gtk.glade.XML('tray.glade', top)
menu = menu_xml.get_widget(top)

top = 'preferences'
preferences_xml = gtk.glade.XML('tray.glade', top)
preferences = preferences_xml.get_widget(top)

def preferences_handler(*args):
    preferences.show()
    return 0

def about_handler(*args):
    top = 'about'
    gtk.glade.XML('tray.glade', top).get_widget(top).show()
    return 0

menu_xml.get_widget('menu-about').connect('activate', about_handler)
menu_xml.get_widget('menu-preferences').connect('activate', preferences_handler)

########################################################################

applications_group = preferences_xml.get_widget('applications-group')

def handle_master_toggled(master):
    applications_group.set_sensitive(master.get_active())
    return 0

master = preferences_xml.get_widget('master')
master.connect('toggled', handle_master_toggled)
handle_master_toggled(master)

########################################################################

view = preferences_xml.get_widget('applications')
print 'view:', dir(view)
gears = view.render_icon(gtk.STOCK_EXECUTE, gtk.ICON_SIZE_MENU, 'applications')

model = gtk.ListStore(gobject.TYPE_BOOLEAN, gtk.gdk.Pixbuf, gobject.TYPE_STRING)
iter = model.append()
model.set_value(iter, 0, 0)
model.set_value(iter, 1, None)
model.set_value(iter, 2, 'Nautilus')
iter = model.append()
model.set_value(iter, 0, 1)
model.set_value(iter, 1, None)
model.set_value(iter, 2, 'Evolution')
iter = model.append()
model.set_value(iter, 0, 0)
model.set_value(iter, 1, gears)
model.set_value(iter, 2, 'Gaim')
iter = model.append()
model.set_value(iter, 0, 1)
model.set_value(iter, 1, gears)
model.set_value(iter, 2, 'The GIMP')

def enabled_sorter (store, a, b):
    a_value = model.get_value(a, 0)
    b_value = model.get_value(b, 0)
    return a_value - b_value

model.set_sort_func(0, enabled_sorter)

def running_sorter (store, a, b):
    a_value = model.get_value(a, 1)
    b_value = model.get_value(b, 1)
    return (a_value != None) - (b_value != None)

model.set_sort_func(1, running_sorter)

model.set_sort_column_id(2, gtk.SORT_ASCENDING)

def handle_application_toggled(renderer, path, model):
    iter = model.get_iter(path)
    value = model.get_value(iter, 0)
    value = not value
    model.set(iter, 0, value)
    return 0

renderer = gtk.CellRendererToggle()
renderer.connect('toggled', handle_application_toggled, model)
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

def press_handler(widget, event):
    if event.type == gtk.gdk.BUTTON_PRESS:
        if event.button == 1:
            preferences_handler()
            return 0
        elif event.button == 3:
            menu.popup(None, None, None, event.button, event.time)
            return 0
    return 1

t.connect('button-press-event', press_handler)

########################################################################

t.show_all()
preferences_handler()
gtk.main()

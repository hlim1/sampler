#!/usr/bin/python -O
# -*- coding: utf-8 -*-

from os import environ
from os.path import abspath, dirname

home = dirname(abspath(__file__))
launcher = dirname(home)
environ['XDG_DATA_DIRS'] = ':'.join([
    launcher,
    '/usr/local/share',
    '/usr/share',
    ])

# add "../common" to sys.path
import Main

from gi.repository import Gio, GLib, Gtk, Notify

import BlipIcons
import Keys


BODY = 'You are now using instrumented software from the <a href="http://research.cs.wisc.edu/cbi/">Cooperative Bug Isolation Project</a>.  Automatic feedback reporting is <b>%s</b>.'

WORDS = {
    True: (
        'enabled',
        'Enable',
        ),
    False: (
        'disabled',
        'Disable',
        ),
    }


def closed(note):
    Gtk.main_quit()


def set_enabled(note, action, (settings, enabled)):
    settings[Keys.MASTER] = enabled


def changed_enabled(settings, key, note):
    update(settings, note)


def update(settings, note):
    enabled = settings[Keys.MASTER]
    adjective = WORDS[enabled][0]
    Imperative = WORDS[not enabled][1]

    summary = 'CBI reporting is %s' % adjective
    body = BODY % adjective
    note.update(summary, body, None)

    stockName = BlipIcons.stock[enabled]
    iconSet = Gtk.IconFactory.lookup_default(stockName)
    pixmap = iconSet.render_icon_pixbuf(Gtk.StyleContext(), Gtk.IconSize.DIALOG)
    note.set_icon_from_pixbuf(pixmap)

    # unusable in Fedora 15 and earlier due to <https://bugzilla.gnome.org/show_bug.cgi?id=658288>/<https://bugzilla.redhat.com/show_bug.cgi?id=741128>
    note.clear_actions()
    note.add_action('toggle', Imperative, set_enabled, (settings, not enabled), None)

    note.show()


def main():
    Notify.init('Bug Isolation Monitor')

    # workaround for <https://bugzilla.gnome.org/show_bug.cgi?id=653033>
    if 'body-hyperlinks' not in Notify.get_server_caps():
        import re
        global BODY
        BODY = re.sub('<(a href="[^"]*"|/a)>', '', BODY)

    note = Notify.Notification()
    note.set_urgency(Notify.Urgency.LOW)
    note.set_hint('resident', GLib.Variant.new_boolean(True))
    #note.set_hint_string('desktop-entry', ...)
    note.connect('closed', closed)

    settings = Gio.Settings(Keys.BASE)
    settings.connect('changed::' + Keys.MASTER, changed_enabled, note)
    update(settings, note)

    Gtk.main()


if __name__ == '__main__':
    main()

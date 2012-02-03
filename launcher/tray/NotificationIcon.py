# -*- coding: utf-8 -*-

from gi.repository import Gio, GLib, Gtk, Notify

import Keys


BODY = 'You are now using instrumented software from the <a href="http://research.cs.wisc.edu/cbi/">Cooperative Bug Isolation Project</a>.  Automatic feedback reporting is <b>%s</b>.'


BODY_HYPERLINKS = True


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


class TrayIcon(object):

    __slots__ = '__note'

    def __init__(self, settings):
        Notify.init('Bug Isolation Monitor')

        # workaround for <https://bugzilla.gnome.org/show_bug.cgi?id=653033>
        if 'body-hyperlinks' not in Notify.get_server_caps():
            import re
            global BODY, BODY_HYPERLINKS
            BODY = re.sub('<(a href="[^"]*"|/a)>', '', BODY)
            BODY_HYPERLINKS = False

        note = Notify.Notification()
        note.set_urgency(Notify.Urgency.LOW)
        note.set_hint('resident', GLib.Variant.new_boolean(True))
        #note.set_hint_string('desktop-entry', ...)
        self.__note = note

        key = Keys.MASTER
        settings.connect('changed::' + key, self.__changed_enabled, note)
        self.__changed_enabled(settings, key, note)

    def close(self):
        if self.__note:
            self.__note.close()

    # GSettings signal callbacks

    def __changed_enabled(self, settings, key, note):
        enabled = settings[key]
        adjective = WORDS[enabled][0]
        Imperative = WORDS[not enabled][1]

        summary = 'CBI reporting is %s' % adjective
        body = BODY % adjective
        themed = 'sampler-' + ('enabled' if enabled else 'disabled')
        note.update(summary, body, themed)

        # unusable in Fedora 15 and earlier due to <https://bugzilla.gnome.org/show_bug.cgi?id=658288>/<https://bugzilla.redhat.com/show_bug.cgi?id=741128>
        note.clear_actions()
        note.add_action('toggle', Imperative, self.__set_enabled, (settings, key, not enabled), None)
        if not BODY_HYPERLINKS:
            note.add_action('learn-more', 'Learn More…', self.__learn_more, None, None)

        try:
            note.show()
            self.__note = note
        except GLib.GError:
            self.__note = None

    # notification action callbacks

    def __learn_more(self, note, action, unused):
        __pychecker__ = 'no-argsused'
        destination = 'http://research.cs.wisc.edu/cbi/learn-more/'
        timestamp = Gtk.get_current_event_time()
        Gtk.show_uri(None, destination, timestamp)

    def __set_enabled(self, note, action, (settings, key, enabled)):
        __pychecker__ = 'no-argsused'
        settings[key] = enabled

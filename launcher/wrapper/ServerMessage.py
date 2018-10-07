import gi
gi.require_version('Gtk', '3.0')
gi.require_version('WebKit2', '4.0')

from gi.repository import GLib, Gtk, WebKit2
from os.path import abspath, dirname, join


########################################################################
#
#  GUI callbacks and helpers for server-message dialog
#


class ServerMessage(object):

    __slots__ = ['__binding', '__dialog', '__initial_title']

    def __init__(self, base, content_type, body):
        import cgi

        builder = Gtk.Builder()
        home = dirname(abspath(__file__))
        builder.add_from_file(join(home, 'wrapper.ui'))
        self.__dialog = builder.get_object('server-message')
        self.__initial_title = self.__dialog.props.title

        view = WebKit2.WebView()
        view.connect('decide-policy', self.__on_decide_policy)
        view.connect('notify::title', self.__on_notify_title)
        body_bytes = GLib.Bytes(body)
        [mime_type, options] = cgi.parse_header(content_type)
        encoding = options.get('charset', '')
        view.load_bytes(body_bytes, mime_type, encoding, base)

        scroll = builder.get_object('html-scroll')
        scroll.add(view)
        view.show()

    def __on_decide_policy(self, view, decision, kind):
        __pychecker__ = 'no-argsused'
        if kind == WebKit2.PolicyDecisionType.NAVIGATION_ACTION:
            if decision.props.navigation_type == WebKit2.NavigationType.LINK_CLICKED:
                decision.ignore()
                destination = decision.props.request.props.uri
                screen = self.__dialog.get_screen()
                timestamp = Gtk.get_current_event_time()
                Gtk.show_uri(screen, destination, timestamp)
                return True

        return False

    def __on_notify_title(self, view, param):
        __pychecker__ = 'no-argsused'
        title = view.props.title or self.__initial_title
        self.__dialog.props.title = title
        return True

    def run(self):
        result = self.__dialog.run()
        self.__dialog.destroy()
        return result

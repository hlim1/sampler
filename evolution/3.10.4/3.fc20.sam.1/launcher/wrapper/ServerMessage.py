from gi.repository import Gtk, WebKit
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

        view = WebKit.WebView()
        view.connect('navigation-policy-decision-requested', self.__on_navigation)
        view.connect('notify::title', self.__on_notify_title)
        [mime_type, options] = cgi.parse_header(content_type)
        encoding = options.get('charset', '')
        view.load_string(body, mime_type, encoding, base)

        scroll = builder.get_object('html-scroll')
        scroll.add(view)
        view.show()

    def __on_navigation(self, view, frame, request, action, decision):
        __pychecker__ = 'no-argsused'
        if action.props.reason == WebKit.WebNavigationReason.LINK_CLICKED:
            decision.ignore()
            destination = action.props.original_uri
            screen = self.__dialog.get_screen()
            timestamp = Gtk.get_current_event_time()
            Gtk.show_uri(screen, destination, timestamp)
            return True
        else:
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

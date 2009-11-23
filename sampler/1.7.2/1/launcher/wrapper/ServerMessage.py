import gtk
import urlparse


########################################################################
#
#  GUI callbacks and helpers for server-message dialog
#


class ServerMessage(object):

    __slots__ = ['__dialog', '__document']

    def __init__(self, base, content_type, body):
        import cgi
        import gtkhtml2
        import BlipIcons
        import Paths

        builder = gtk.Builder()
        builder.add_from_file(Paths.ui)
        self.__dialog = builder.get_object('server-message')
        pixmap = self.__dialog.render_icon(BlipIcons.stock[True],
                                           BlipIcons.ICON_SIZE_EMBLEM, '')
        self.__dialog.set_icon(pixmap)

        document = gtkhtml2.Document()
        document.connect('request_url', self.on_request_url)
        document.connect('set_base', self.on_set_base)
        document.connect('link_clicked', self.on_link_clicked)
        document.connect('title_changed', self.on_title_changed)
        document.dialog = self.__dialog
        document.base = ''
        self.on_set_base(document, base)
        [mime_type, options] = cgi.parse_header(content_type)
        document.open_stream(mime_type)
        document.write_stream(body)
        document.close_stream()
        self.__document = document

        view = gtkhtml2.View()
        view.set_document(document)
        port = builder.get_object('html-scroll')
        port.add(view)
        view.show()

    def run(self):
        result = self.__dialog.run()
        # GNOME bugzilla bug 119496
        self.__document.clear()
        self.__dialog.destroy()
        return result

    def on_request_url(self, document, url, stream):
        import urllib2
        full = urlparse.urljoin(document.base, url)
        reply = urllib2.urlopen(full)
        stream.write(reply.read())
        stream.close()

    def on_set_base(self, document, base):
        document.base = urlparse.urljoin(document.base, base)

    def on_link_clicked(self, document, link):
        screen = self.__dialog.get_screen()
        full = urlparse.urljoin(document.base, link)
        timestamp = gtk.get_current_event_time()
        gtk.show_uri(screen, full, timestamp)

    def on_title_changed(self, document, title):
        document.dialog.set_title(title)

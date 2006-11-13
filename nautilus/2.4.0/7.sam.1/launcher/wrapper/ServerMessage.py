import cgi
import sys
import urllib2
import urlparse

import gnome
import gtk
import gtk.glade
import gtkhtml2

import BlipIcons
import Config
import Paths
import Signals


########################################################################
#
#  GUI callbacks and helpers for server-message dialog
#


class ServerMessage:
    def __init__(self, base, content_type, body):
        argv = sys.argv
        sys.argv = [sys.argv[0]]
        gnome.program_init('wrapper', Config.version)
        sys.argv = argv

        xml = gtk.glade.XML(Paths.glade)
        Signals.autoconnect(self, xml)
        self.__dialog = xml.get_widget('server-message')
        pixmap = self.__dialog.render_icon(BlipIcons.stock[gtk.TRUE],
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
        [type, options] = cgi.parse_header(content_type)
        document.open_stream(type)
        document.write_stream(body)
        document.close_stream()
        self.__document = document

        view = gtkhtml2.View()
        view.set_document(document)
        port = xml.get_widget('html-scroll')
        port.add(view)
        view.show()

    def run(self):
        result = self.__dialog.run()
        # GNOME bugzilla bug 119496
        self.__document.clear()
        self.__dialog.destroy()
        return result

    def on_request_url(self, document, url, stream):
        full = urlparse.urljoin(document.base, url)
        reply = urllib2.urlopen(full)
        stream.write(reply.read())
        stream.close()

    def on_set_base(self, document, base):
        document.base = urlparse.urljoin(document.base, base)

    def on_link_clicked(self, document, link):
        full = urlparse.urljoin(document.base, link)
        gnome.url_show(full)

    def on_title_changed(self, document, title):
        document.dialog.set_title(title)

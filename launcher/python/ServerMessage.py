import cgi
import urllib2
import urlparse

import pygtk
pygtk.require('2.0')
import gnome
import gtkhtml2

from DialogWrapper import DialogWrapper


########################################################################
#
#  GUI callbacks and helpers for server-message dialog
#


class ServerMessage (DialogWrapper):
    def __init__(self, dir, reply):
        DialogWrapper.__init__(self, dir, 'server-message')

        document = gtkhtml2.Document()
        document.connect('request_url', self.on_request_url)
        document.connect('set_base', self.on_set_base)
        document.connect('link_clicked', self.on_link_clicked)
        document.connect('title_changed', self.on_title_changed)
        document.dialog = self.dialog
        document.base = ''
        self.on_set_base(document, reply.geturl())
        [type, options] = cgi.parse_header(reply.info()['Content-type'])
        document.open_stream(type)
        document.write_stream(reply.read())
        document.close_stream()

        view = gtkhtml2.View()
        view.set_document(document)
        port = self.get_widget('html-scroll')
        port.add(view)
        view.show()

    def on_request_url(self, document, url, stream):
        full = urlparse.urljoin(document.base, url)
        reply = urllib2.urlopen(full)
        stream.write(reply.read())

    def on_set_base(self, document, base):
        document.base = urlparse.urljoin(document.base, base)

    def on_link_clicked(self, document, link):
        full = urlparse.urljoin(document.base, link)
        gnome.url_show(full)

    def on_title_changed(self, document, title):
        document.dialog.set_title(title)

from DialogWrapper import DialogWrapper

import gnome
import gtkhtml2

import urllib2
import urlparse


########################################################################
#
#  GUI callbacks and helpers for server-message dialog
#


class ServerMessage (DialogWrapper):
    def __init__(self, application, reply, message):
        DialogWrapper.__init__(self, application, 'server-message')

        document = gtkhtml2.Document()
        document.connect('request_url', self.on_request_url)
        document.connect('set_base', self.on_set_base)
        document.connect('link_clicked', self.on_link_clicked)
        document.connect('title_changed', self.on_title_changed)
        document.dialog = self.dialog
        document.base = ''
        self.on_set_base(document, reply.geturl())
        document.open_stream(message.get_content_type())
        document.write_stream(message.get_payload())
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
        print 'old base:', document.base
        print 'rel base:', base
        document.base = urlparse.urljoin(document.base, base)
        print 'new base:', document.base

    def on_link_clicked(self, document, link):
        print 'base:', document.base
        print 'link:', link
        full = urlparse.urljoin(document.base, link)
        print 'full:', full
        gnome.url_show(full)

    def on_title_changed(self, document, title):
        document.dialog.set_title(title)

from urllib2 import HTTPRedirectHandler
import urlparse


########################################################################
#
#  Custom urllib2 redirection handler that gives access to information
#  about permanent redirections
#


class RedirectHandler (HTTPRedirectHandler):
    def __init__(self):
        self.permanent = None

    def http_error_301(self, req, fp, code, msg, headers):
        if headers.has_key('location'):
            newurl = headers['location']
        elif headers.has_key('uri'):
            newurl = headers['uri']
        else:
            return
        newurl = urlparse.urljoin(req.get_full_url(), newurl)
        self.permanent = newurl
        return HTTPRedirectHandler.http_error_301(self, req, fp, code, msg, headers)

    http_error_303 = HTTPRedirectHandler.http_error_302
    http_error_307 = HTTPRedirectHandler.http_error_302


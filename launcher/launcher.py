#!/usr/bin/env python

import gconf
import gnome
import gobject
import gtk
import gtk.glade
import gtkhtml2
import pango

import ConfigParser
import cStringIO
import gzip
import os
import random
import re
import struct
import sys
import urllib2
import urlparse
import xreadlines


########################################################################
#
#  Application configuration
#

class AppInfo (ConfigParser.ConfigParser):

    def __init__(self):
        ConfigParser.ConfigParser.__init__(self)
        self.base = os.path.realpath(sys.path[0])
        self.name = os.path.basename(sys.argv[0])
        self.dir = os.path.join(self.base, 'applications', self.name)
        self.executable = self.path('executable')
        assert os.access(self.executable, os.X_OK)
        self.readfp(file(self.path('config')))

    def path(self, filename):
        return os.path.join(self.dir, filename)

    def optionxform(self, option):
        return str(option)

application = AppInfo()


########################################################################
#
#  GConf interaction
#


class GnomeConfig:

    def __init__(self):
        self.client = gconf.client_get_default()
        self.root = application.get('general', 'gconf-root')
        self.client.add_dir(self.root, gconf.CLIENT_PRELOAD_ONELEVEL)

    def __key(self, suffix):
        return self.root + '/' + suffix

    def __get_bool(self, name):
        return self.client.get_bool(self.__key(name))

    def __set_bool(self, name, value):
        self.client.set_bool(self.__key(name), value)

    def __get_int(self, name):
        return self.client.get_int(self.__key(name))

    def __get_string(self, name):
        return self.client.get_string(self.__key(name))

    __handle_bool = { 'get' : __get_bool,
                      'set' : __set_bool }

    __handle_int = { 'get' : __get_int }

    __handle_string = { 'get' : __get_string }

    __handlers = { 'asked' : __handle_bool,
                   'compression-level' : __handle_int,
                   'enabled' : __handle_bool,
                   'reporting-url' : __handle_string,
                   'sparsity' : __handle_int,
                   'view-before-sending' : __handle_bool }

    def __getitem__(self, name):
        return GnomeConfig.__handlers[name]['get'](self, name)

    def __setitem__(self, name, value):
        GnomeConfig.__handlers[name]['set'](self, name, value)


gconfig = GnomeConfig()


########################################################################
#
#  GUI callbacks and helpers: opt-in dialog
#


def yesno_update(name, active):
    radio = xml.get_widget(name)
    details = xml.get_widget(name + '-details')
    radio.set_active(active)
    details.set_sensitive(active)


def yesno_set():
    global enabled
    yesno_update('yes', enabled)
    yesno_update('no', not enabled)


def on_yes_toggled(yes):
    global enabled
    enabled = yes.get_active()
    yesno_set()


########################################################################
#
#  GUI callbacks and helpers: server-message dialog
#


def on_request_url(document, url, stream):
    full = urlparse.urljoin(document.base, url)
    # !!!: support GNOME-configured proxy (example at end of http://mail.python.org/pipermail/python-dev/2002-December/030927.html)
    reply = urllib2.urlopen(full)
    stream.write(reply.read())


def on_set_base(document, base):
    document.base = urlparse.urljoin(document.base, base)


def on_link_clicked(document, link):
    full = urlparse.urljoin(document.base, link)
    gnome.url_show(full)


def on_title_changed(document, title):
    document.dialog.set_title(title)


########################################################################
#
#  Python has a great "email" package with the not-so-great assumption
#  that "\n" is always the appropriate line terminator.  HTTP mandates
#  CRLF, and there's just no practical way to convince the "email"
#  package to use this.  So we can't use that package at all, and have
#  to roll our own crude replacement.
#
#  {sigh}
#


def pickBoundary(parts):
    candidate = ('=' * 15) + repr(random.random()).split('.')[1] + '=='
    pattern = re.compile('^--' + re.escape(candidate) + '(--)?$', re.MULTILINE)
    for id in parts:
        if pattern.search(parts[id]):
            return pickBoundary(parts)
    return candidate


def appendPart(multipart, boundary, name, content):
    if content != None:
        contents = ['--' + boundary,
                    'Content-Disposition: form-data; filename="' + name + '", name="' + name + '"',
                    'Content-Encoding: gzip',
                    '',
                    content]
        for line in contents:
            print >>multipart, line + '\r'


########################################################################


def compress(text):
    compressLevel = gconfig['compression-level']
    if compressLevel < 1 or compressLevel > 9:
        compressLevel = 6

    result = cStringIO.StringIO()
    compressor = gzip.GzipFile(None, 'w', compressLevel, result)
    compressor.write(text)
    compressor.close()
    return result.getvalue()


def main():
    global enabled
    enabled = gconfig['enabled']

    global xml
    xml = gtk.glade.XML(os.path.join(application.dir, 'interface.glade'))
    xml.signal_autoconnect(globals())

    docu = gtkhtml2.Document()
    view = gtkhtml2.View()
    port = xml.get_widget('html-scroll')
    port.add(view)
    dialog = xml.get_widget('server-message')

    view.set_document(docu)
    docu.dialog = dialog
    docu.base = ''
    on_set_base(docu, 'http://www.google.com/')
    docu.connect('request_url', on_request_url)
    docu.connect('set_base', on_set_base)
    docu.connect('link_clicked', on_link_clicked)
    docu.connect('title_changed', on_title_changed)

    docu.open_stream('text/html')
    docu.write_stream('<html><head><meta http-equiv="content-type" content="text/html; charset=ISO-8859-1"><title>Google</title><style><!--\
body,td,a,p,.h{font-family:arial,sans-serif;}\
.h{font-size: 20px;}\
.q{text-decoration:none; color:#0000cc;}\
//-->\
</style>\
<script>\
<!--\
function sf(){document.f.q.focus();}\
// -->\
</script>\
</head><body bgcolor=#ffffff text=#000000 link=#0000cc vlink=#551a8b alink=#ff0000 onLoad=sf()><center><table border=0 cellspacing=0 cellpadding=0><tr><td><img src="/images/logo.gif" width=276 height=110 alt="Google"></td></tr></table><br>\
<table border=0 cellspacing=0 cellpadding=0><tr><td width=15>&nbsp;</td><td id=0 bgcolor=#3366cc align=center width=95 nowrap><font color=#ffffff size=-1><b>Web</b></font></td><td width=15>&nbsp;</td><td id=1 bgcolor=#efefef align=center width=95 nowrap onClick="" style=cursor:pointer;cursor:hand;><a id=1a class=q href="/imghp?hl=en&tab=wi&ie=UTF-8"><font size=-1>Images</font></a></td><td width=15>&nbsp;</td><td id=2 bgcolor=#efefef align=center width=95 nowrap onClick="" style=cursor:pointer;cursor:hand;><a id=2a class=q href="/grphp?hl=en&tab=wg&ie=UTF-8"><font size=-1>Groups</font></a></td><td width=15>&nbsp;</td><td id=3 bgcolor=#efefef align=center width=95 nowrap onClick="" style=cursor:pointer;cursor:hand;><a id=3a class=q href="/dirhp?hl=en&tab=wd&ie=UTF-8"><font size=-1>Directory</font></a></td><td width=15>&nbsp;</td><td id=4 bgcolor=#efefef align=center width=95 nowrap onClick="" style=cursor:pointer;cursor:hand;><a id=4a class=q href="/nwshp?hl=en&tab=wn&ie=UTF-8"><font size=-1>News</font></a></td><td width=15>&nbsp;</td></tr><tr><td colspan=12 bgcolor=#3366cc><img width=1 height=1 alt=""></td></tr></table><br><form action="/search" name=f><table cellspacing=0 cellpadding=0><tr><td width=75>&nbsp;</td><td align=center><input type=hidden name=hl value=en><span id=hf></span><input type=hidden name=ie value="ISO-8859-1"><input maxLength=256 size=55 name=q value=""><br><input type=submit value="Google Search" name=btnG><input type=submit value="I\'m Feeling Lucky" name=btnI></td><td valign=top nowrap><font size=-2>&nbsp;&#8226;&nbsp;<a href=/advanced_search?hl=en>Advanced&nbsp;Search</a><br>&nbsp;&#8226;&nbsp;<a href=/preferences?hl=en>Preferences</a><br>&nbsp;&#8226;&nbsp;<a href=/language_tools?hl=en>Language Tools</a></font></td></tr></table></form><br>\
<br><font size=-1><a href="/ads/">Advertise&nbsp;with&nbsp;Us</a> - <a href="/services/">Business&nbsp;Solutions</a> - <a href="/options/">Services&nbsp;&amp;&nbsp;Tools</a> - <a href=/about.html>Jobs,&nbsp;Press,&nbsp;&amp;&nbsp;Help</a></font><p><font size=-2>&copy;2003 Google - Searching 3,083,324,652 web pages</font></p></center></body></html>')
    docu.close_stream()
    view.show()
    dialog.run()
    dialog.hide()

    if not gconfig['asked']:
        yesno_set()

        dialog = xml.get_widget('opt-in')
        response = dialog.run()
        dialog.hide()
        if response != gtk.RESPONSE_OK:
            sys.exit(1)

        gconfig['enabled'] = enabled
        gconfig['asked'] = 1

    sparsity = gconfig['sparsity']
    enabled &= (sparsity > 0)

    reportingUrl = gconfig['reporting-url']
    enabled &= (reportingUrl != None)

    if enabled:
        format = 'L'
        seed = str(struct.unpack(format, file('/dev/urandom').read(struct.calcsize(format)))[0])

        pipe = os.pipe()
        os.environ['GNOME_DISABLE_CRASH_DIALOG'] = '1'
        os.environ['SAMPLER_FILE'] = '/dev/fd/%d' % pipe[1]
        os.environ['SAMPLER_DEBUGGER'] = application.path('print-debug-info')
        os.environ['SAMPLER_SPARSITY'] = str(sparsity)
        os.environ['GSL_RNG_SEED'] = seed
        if 'GSL_RNG_TYPE' in os.environ:
            del os.environ['GSL_RNG_TYPE']

        os.spawnv(os.P_NOWAIT, application.executable, sys.argv)

        os.close(pipe[1])
        reportsFile = os.fdopen(pipe[0])
        reportsLines = xreadlines.xreadlines(reportsFile)
        reportText = {}

        startTag = re.compile('^<report id="([^"]+)">\n$')
        print 'reading reports'
        for line in reportsLines:
            match = startTag.match(line)
            if match:
                reportId = match.group(1)
                print '  reading report:', reportId
                if reportId in reportText:
                    print >>sys.stderr, 'duplicate report id:', reportId
                # !!!: sanity check report id against expected list
                reportText[reportId] = cStringIO.StringIO()
                for line in reportsLines:
                    if line == '</report>\n':
                        print '  reading report:', reportId, '... done'
                        break
                    else:
                        reportText[reportId].write(line)

        print 'reading reports: done'
        for reportId in reportText:
            reportText[reportId] = reportText[reportId].getvalue()

        [pid, exitCodes] = os.wait()
        exitStatus = os.WIFEXITED(exitCodes) and os.WEXITSTATUS(exitCodes)
        exitSignal = os.WIFSIGNALED(exitCodes) and os.WTERMSIG(exitCodes)

        # !!!: check that 'samples' report has been provided

        synopsis = {'Version' : '0.1',
                   'Program-Name' : application.name,
                   'Random-Seed' : seed,
                   'Sparsity' : str(sparsity),
                   'Exit-Status' : str(exitStatus),
                   'Exit-Signal' : str(exitSignal)}

        for option in application.options('synopsis'):
            assert option not in synopsis
            synopsis[option] = application.get('synopsis', option)

        if gconfig['view-before-sending']:
            model = gtk.ListStore(gobject.TYPE_STRING, gobject.TYPE_STRING)
            keys = synopsis.keys();
            keys.sort()
            for key in keys:
                iter = model.append()
                model.set(iter, 0, key, 1, synopsis[key])

            synopsisWidget = xml.get_widget('synopsis')
            renderer = gtk.CellRendererText()
            column = gtk.TreeViewColumn('Attribute', renderer, text=0)
            synopsisWidget.append_column(column)
            column = gtk.TreeViewColumn('Value', renderer, text=1)
            synopsisWidget.append_column(column)
            synopsisWidget.set_model(model)

            samplesWidget = xml.get_widget('samples')
            samplesWidget.get_buffer().set_text(reportText['samples'])

            sharedLibsWidget = xml.get_widget('shared-libraries')
            if 'shared-libraries' in reportText:
                sharedLibsWidget.get_buffer().set_text(reportText['shared-libraries'])
            else:
                sharedLibsWidget.get_parent().hide()

            stackTraceWidget = xml.get_widget('stack-trace')
            if 'stack-trace' in reportText:
                stackTraceWidget.get_buffer().set_text(reportText['stack-trace'])
            else:
                stackTraceWidget.get_parent().hide()

            dialog = xml.get_widget('view-before-sending')
            response = dialog.run()
            dialog.hide()
            if response != gtk.RESPONSE_OK:
                sys.exit(exitSignal or exitStatus)

        print 'compressing reports'
        for reportId in reportText:
            reportText[reportId] = compress(reportText[reportId])
        print 'compressing reports: done'

        multipart = cStringIO.StringIO()
        boundary = pickBoundary(reportText)
        for reportId in reportText:
            appendPart(multipart, boundary, reportId, reportText[reportId])
        print >>multipart, '--' + boundary + '--\r'
        headers = {'Content-type' : 'multipart/form-data; boundary="' + boundary + '"'}

        for header in synopsis:
            headers['Sampler-' + header] = synopsis[header]

        request = urllib2.Request(reportingUrl, multipart.getvalue(), headers)
        # !!!: support GNOME-configured proxy (example at end of http://mail.python.org/pipermail/python-dev/2002-December/030927.html)
        reply = urllib2.urlopen(request)
        # !!!: present result in HTML widget if non-empty
        # !!!: check for sparsity update
        print reply.read()

        sys.exit(exitSignal or exitStatus)

    else:
        os.execv(application.executable, sys.argv)

main()

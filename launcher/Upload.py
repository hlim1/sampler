import cStringIO
import gzip
import random
import re
import shutil
import sys


########################################################################
#
#  Python has a great "email" package with the not-so-great assumption
#  that "\n" is always the appropriate line terminator.  HTTP mandates
#  CRLF, and there's just no practical way to convince the "email"
#  package to use this.  Furthermore, our compressed reports are
#  binary, not text, so we cannot simply replace "\n" with CRLF later.
#
#  Thus we cannot use the "email" package at all, and have to roll our
#  own crude replacement.
#
#  {sigh}
#


class Upload:
    def __init__(self, reports, compressLevel):
        # compress each individual report
        self.__compressed = {}
        for name in reports:
            accumulator = cStringIO.StringIO()
            compressor = gzip.GzipFile(None, 'wb', compressLevel, accumulator)
            reports[name].seek(0)
            shutil.copyfileobj(reports[name], compressor)
            compressor.close()
            self.__compressed[name] = accumulator.getvalue()

        # pick a boundy that never appears in any report
        self.boundary = self.__pickBoundary()


    def __pickBoundary(self):
        candidate = ('=' * 15) + repr(random.random()).split('.')[1] + '=='
        pattern = re.compile('^--' + re.escape(candidate) + '(--)?$', re.MULTILINE)

        for name in self.__compressed:
            if pattern.search(self.__compressed[name]):
                return __pickBoundary(reports)

        return candidate


    def __str__(self):
        multipart = cStringIO.StringIO()

        for name in self.__compressed:
            contents = ['--' + self.boundary,
                        'Content-Disposition: form-data; filename="' + name + '", name="' + name + '"',
                        'Content-Encoding: gzip',
                        '',
                        self.__compressed[name]]
            for line in contents:
                print >>multipart, line + '\r'

        print >>multipart, '--' + self.boundary + '--\r'
        return multipart.getvalue()

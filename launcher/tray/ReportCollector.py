import sampler


class ReportCollector(sampler.ReportCollector):

    def __init__(self):
        sampler.ReportCollector.__init__(self, addHeader = self.addHeader, addReport = self.addReport, submit = self.submit)
        self._headers = {}
        self._reports = {}

    def addHeader(self, name, value):
        if name in self._headers:
            print >>stderr, 'warning: duplicate header:', name
        self._headers[name] = value

    def addReport(self, name, contents):
        if name in self._reports:
            self._reports[name] += contents
        else:
            self._reports[name] = contents

    def submit(self, url):
        print 'python: submit:', url

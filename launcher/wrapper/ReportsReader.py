import cStringIO
import re
import xreadlines


########################################################################
#
#  Read report stream from instrumented application and split it apart
#  into individual reports
#

class ReportsReader (dict):
    def __init__(self, source):
        lines = xreadlines.xreadlines(source)

        startTag = re.compile('^<report id="([^"]+)">\n$')
        for line in lines:
            match = startTag.match(line)
            if match:
                name = match.group(1)
                if not name in self:
                    self[name] = cStringIO.StringIO()

                for line in lines:
                    if line == '</report>\n':
                        break
                    else:
                        self[name].write(line)

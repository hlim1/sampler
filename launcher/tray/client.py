#!/usr/bin/python

import bonobo
import time

server = bonobo.get_object('OAFIID:SamplerReportCollector:1.0', 'Sampler/ReportCollector')

nothing = server.addHeader('sparsity', '100')
print 'addHeader:', nothing

nothing = server.addReport('samples', 'deadbeef\n0\t0\n1\t0\n')
print 'addReport:', nothing

nothing = server.submit('http://brawnix.cs.berkeley.edu/cgi-bin/sampler-upload')
print 'submit:', nothing

#time.sleep(5)

server.unref()

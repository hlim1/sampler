#!/usr/bin/python

import bonobo
import time

server = bonobo.get_object('OAFIID:SamplerReportCollector:1.0', 'IDL:Sampler/ReportCollector:1.0')
print dir(server)

sparsity = server.sparsity()
print 'sparsity:', sparsity

nothing = server.reportUnit((12, 34, 56, 78), (1, 1, 2, 3, 5, 8, 13, 21))
print 'reportUnit:', nothing

nothing = server.exitStatus(14)
print 'exitStatus:', nothing

nothing = server.exitSignal(14)
print 'exitSignal:', nothing

time.sleep(10)

server.unref()

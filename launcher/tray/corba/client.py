#!/usr/bin/python

import bonobo
import time

server = bonobo.get_object('OAFIID:SamplerUploader:1.0', 'Sampler/Uploader')

server.increment()
server.increment()
server.increment()

print 'sleeping...'
time.sleep(3)

server.unref()

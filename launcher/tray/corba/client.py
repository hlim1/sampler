#!/usr/bin/python

import bonobo

server = bonobo.get_object('OAFIID:SamplerUploader:1.0', 'IDL:Sampler/Uploader:1.0')

server.increment()

server.unref()

#!/usr/bin/python

import bonobo
import time
import CORBA; help(CORBA)

bag = bonobo.get_object('OAFIID:SamplerUploader_Bag:1.0', 'IDL:Bonobo/PropertyBag:1.0')
print bag, dir(bag)

bag.setValue('foo', 7)
uploader = bag.getValue('foo')
print uploader, dir(uploader)

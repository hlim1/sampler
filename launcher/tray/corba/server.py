#!/usr/bin/python

import ORBit
import bonobo
import os
import sys

ORBit.load_typelib(os.path.dirname(sys.argv[0]) + '/sampler_module')

import CORBA
import Sampler__POA


########################################################################


class Uploader(Sampler__POA.Uploader):

    def __init__(self):
        self.count = 0

    def increment(self):
        ++self.count
        print 'Uploader.increment; count ==', self.count

    def increment(self):
        ++self.count
        print 'Uploader.increment; count ==', self.count

    def reportUnit(self, signature, counts):
        print 'reportUnit:', signature, length(counts)

    def exitStatus(self, status):
        print 'exitStatus:', status

    def exitSignal(self, signal):
        print 'exitSignal:', signal
    

########################################################################


class UploaderBag(bonobo.PropertyBag):

    def set_property(self, *args):
        print 'UploaderBag.set_property:', args

    def get_property(self, *args):
        print 'UploaderBag.get_property:', args
        return self.uploader

    def __init__(self):
        print 'UploaderBag.__init__'
        bonobo.PropertyBag.__init__(self, self.get_property, self.set_property)
        self.uploader = Uploader()
    

########################################################################


class UploaderFactory(bonobo.GenericFactory):

    def __init__(self):
        print 'UploaderFactor.__init__', self
        bonobo.GenericFactory.__init__(self, 'OAFIID:SamplerUploader_Factory:1.0', self.manufacture)

    def manufacture(*args):
        print 'UploaderFactory.manufacture:', args
        return UploaderBag()


component = UploaderFactory()
print 'created:', component
bonobo.running_context_auto_exit_unref(component)

print 'about to enter bonobo.main'
bonobo.main()
print 'returned from bonobo.main'

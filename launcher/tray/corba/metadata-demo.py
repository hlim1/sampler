#!/usr/bin/python
#
# pass the IOR returned by the following command as an argument:
#   activation-client -s "repo_ids.has('IDL:Nautilus/MetafileFactory:1.0')" | tail -1
#
import sys, os

import ORBit, CORBA

# we can load type information from a typelib
ORBit.load_typelib('Bonobo')

# or by parsing IDL ...
nautilusdir = os.environ['HOME'] + '/cvs/gnome2/nautilus'
ORBit.load_file('%s/libnautilus-private/nautilus-metafile-server.idl' % nautilusdir,
                '-I%s -I/usr/share/idl -D__ORBIT_IDL__ -D__nautilus_view_component_COMPILATION' % nautilusdir)

import Nautilus__POA

class Monitor(Nautilus__POA.MetafileMonitor):
    i = 0

    # Bonobo::Unknown methods ...
    def ref(self):
        print "Ref!"
    def unref(self):
        print "Unref!"
    def queryInterface(self, repoid):
        if repoid in ('IDL:Bonobo/Unknown:1.0',
                      'IDL:Nautilus/MetafileMonitor:1.0'):
            return self._this()
        return None

    # Nautilus::MetafileMonitor methods:
    def metafile_changed(self, file_names):
        for name in file_names:
            print name, 'changed:', metafile.get_list(name, 'keyword', 'name')

        # stop listening after a while
        self.i += 1
        if self.i > 10:
            metafile.unregister_monitor(self._this())
            orb.shutdown(False)
    def metafile_ready(self):
        print "Metafile ready"

ior = sys.argv[1]

orb = CORBA.ORB_init()

# create the metadata monitor ...
monitor_servant = Monitor()
monitor = monitor_servant._this()

# open the metadata for the home directory ...
factory = orb.string_to_object(ior)
metafile = factory.open(os.environ['HOME'])
metafile.register_monitor(monitor)

orb.run()

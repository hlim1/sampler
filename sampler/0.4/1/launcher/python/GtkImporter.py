import sys

if not sys.modules.has_key('gtk'):
    import pygtk
    pygtk.require('2.0')

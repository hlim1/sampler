#!/usr/bin/python

import pygtk
pygtk.require('2.0')

from Main import Main

import bonobo
import gnome


# !!!: begin temporary hack zone
#import os, sys
#sys.stdout = sys.stderr = file('/dev/pts/2', 'w')
#os.chdir(os.path.dirname(sys.argv[0]))
# !!!: end temporary hack zone

gnome.program_init('sampler', '0.1')
import locale
main = Main()
bonobo.main()

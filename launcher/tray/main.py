#!/usr/bin/python -O

import pygtk
pygtk.require('2.0')

import bonobo
import gnome

from Main import Main

import Config


# !!!: begin temporary hack zone
import os, sys
#sys.stdout = sys.stderr = file('/dev/pts/2', 'w')
os.chdir(os.path.dirname(sys.argv[0]))
# !!!: end temporary hack zone

gnome.program_init('sampler', Config.version)
import locale
main = Main()
bonobo.main()

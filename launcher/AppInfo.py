import ConfigParser
import os
import sys


########################################################################
#
#  Interface to static application configuration
#

class AppInfo (ConfigParser.ConfigParser):

    def __init__(self):
        ConfigParser.ConfigParser.__init__(self)
        base = os.path.realpath(sys.path[0])
        self.name = os.path.basename(sys.argv[0])
        self.__dir = os.path.join(base, 'applications', self.name)
        self.executable = self.path('executable')
        assert os.access(self.executable, os.X_OK)
        self.readfp(file(self.path('config')))

    def path(self, filename):
        return os.path.join(self.__dir, filename)

    def optionxform(self, option):
        return str(option)

from ConfigParser import ConfigParser
import os
import sys


########################################################################
#
#  Interface to static application configuration
#

class AppInfo (ConfigParser):

    def __init__(self):
        ConfigParser.__init__(self)
        self.__dir = sys.path[0]
        self.name = os.path.basename(self.__dir)
        self.executable = self.path('executable')
        assert os.access(self.executable, os.X_OK)
        self.readfp(file(self.path('config')))

    def path(self, filename):
        return os.path.join(self.__dir, filename)

    def optionxform(self, option):
        return str(option)

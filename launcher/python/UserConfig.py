from BaseUserConfig import BaseUserConfig

import shutil
from sys import stderr
import xreadlines


class UserConfig (BaseUserConfig):
    '''User preferences as stored in a static config file.'''

    def __init__(self, filename, config):
        '''Find user preferences in the given configuration file.'''
        self.__config = config
        self.__filename = filename

    def enabled(self):
        '''Check whether sampling is enabled.'''
        return self.__config.getboolean('user', 'enabled')

    def reporting_url(self):
        '''Destination address for uploaded reports.'''
        return self.__config.get('user', 'reporting-url')

    def sparsity(self):
        '''Sparsity of sampled data.'''
        return self.__config.getint('user', 'sparsity')

    def compression_level(self):
        '''Level of compression for uploaded reports.'''
        if self.__config.has_option('user', 'compression-level'):
            return self.__config.getint('user', 'compression-level')
        else:
            return None

    def change_reporting_url(self, url):
        '''Record a new address for future uploads.'''
        self.__change('reporting-url', url)

    def change_sparsity(self, sparsity):
        '''Record a new sampling sparsity for future runs.'''
        self.__change('sparsity', sparsity)

    def __change(self, key, new):
        '''Change and save the configuration.'''
        old = self.__config.get('user', key)
        self.__config.set('user', key, new)
        try:
            out = file(self.__filename, 'w')
            self.__config.write(out)
        except IOError, error:
            print >>stderr, 'warning: server requested a configuration change'
            print >>stderr
            print >>stderr, '    in section [user], please change "%s" from "%s" to "%s"' % (key, old, new)
            print >>stderr

    def show_server_message(self, reply):
        print >>stderr, 'warning: server posted the following reply message:'
        print >>stderr
        for key in reply.info().keys():
            print >>stderr, '    %s: %s' % (key, reply.info()[key])
        print >>stderr
        
        for line in xreadlines.xreadlines(reply):
            print >>stderr, '   ', line,

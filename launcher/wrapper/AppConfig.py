import os.path

from ConfigParser import ConfigParser


class AppConfig:
    '''Static configuration information about a single instrumented application'''

    def __init__(self, configdir, executable):
        '''Find application information in the given configuration file.'''
        self.__dir = configdir
        self.__executable = self.__path(executable)
        filename = self.__path('config')
        self.config = ConfigParser()
        self.config.readfp(file(filename))

    def __path(self, filename):
        '''Find a related file in the same directory as the config file.'''
        return os.path.join(self.__dir, filename)

    def get(self, section, key):
        '''Fetch an arbitrary configuration entry.'''
        return self.config.get(section, key)

    def executable(self):
        '''Path to the real instrumented executable.'''
        return self.__executable

    def debug_reporter(self):
        '''Path to script that prints post-crash debug reports.'''
        if self.config.has_option('application', 'debug-reporter'):
            return self.__path(self.get('application', 'debug-reporter'))
        else:
            return None

    def upload_headers(self):
        '''Extra headers to be included in all report uploads.'''
        headers = {'executable-path' : self.executable()}
        for key in self.config.options('upload-headers'):
            headers[key] = self.get('upload-headers', key)
        return headers

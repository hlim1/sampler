class BaseUserConfig:
    '''Common base for user preferences.'''

    def enabled(self):
        '''Check whether sampling is enabled.'''
        raise NotImementedError

    def sparsity(self):
        '''Sparsity of sampled data.'''
        raise NotImementedError

    def reporting_url(self):
        '''Destination address for uploaded reports.'''
        raise NotImementedError

    def compression_level(self):
        '''Level of compression for uploaded reports.'''
        raise NotImementedError

    def change_reporting_url(self, url):
        '''Record a new address for future uploads.'''
        raise NotImementedError

    def change_sparsity(self, url):
        '''Record a new sampling sparsity for future runs.'''
        raise NotImementedError

    def show_server_message(self, reply):
        '''Show a server message in response to an upload.'''
        raise NotImplementedError

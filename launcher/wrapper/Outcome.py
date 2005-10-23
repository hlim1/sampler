class Outcome:
    '''Outcome of one run of a sampled application.'''

    def exit(self):
        '''Propagate exit status out to whoever ran this wrapper script.'''
        import sys
        sys.exit(self.signal or self.status)

    def upload_headers(self):
        '''Contribute additional headers to report uploads.'''
        return {'sparsity' : str(self.sparsity),
                'exit-status' : str(self.status),
                'exit-signal' : str(self.signal)}

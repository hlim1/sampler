class AppConfig:
    '''Static configuration information about a single instrumented application'''

    def __init__(self, name, executable, debug_reporter, upload_headers):
        upload_headers['application-name'] = name,
        upload_headers['executable-path'] = executable
        self.executable = executable
        self.debug_reporter = debug_reporter
        self.__upload_headers = upload_headers

    def upload_headers(self):
        return self.__upload_headers

from ConfigParser import ConfigParser
import os.path


class AppConfig:
    """Static configuration information about a single instrumented application"""

    def __init__(self, filename):
        """Find application information in the given configuration file."""
        self.__dir = os.path.dirname(filename)
        self.config = ConfigParser()
        self.config.readfp(file(filename))

    def path(self, filename):
        """Find a related file in the same directory as the config file."""
        return os.path.join(self.__dir, filename)

    def get(self, section, key):
        """Fetch an arbitrary configuration entry."""
        return self.config.get(section, key, 0, {"configdir" : self.__dir})

    def executable(self):
        """Path to the real instrumented executable."""
        return self.get("application", "executable")

    def debug_reporter(self):
        """Path to script that prints post-crash debug reports."""
        if self.config.has_option("application", "debug-reporter"):
            return self.get("application", "debug-reporter")
        else:
            return None

    def upload_headers(self):
        """Extra headers to be included in all report uploads."""
        headers = {}
        for key in self.config.options("upload-headers"):
            headers[key] = self.get("upload-headers", key)
        return headers

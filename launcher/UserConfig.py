from BaseUserConfig import BaseUserConfig


class UserConfig (BaseUserConfig):
    """User preferences as stored in a static config file."""

    def __init__(self, filename):
        """Find user preferences in the given configuration file."""
        self.__config = ConfigParser()
        self.__config.readfp(file(filename))

    def enabled(self):
        """Check whether sampling is enabled."""
        return self.__config.getboolean("user", "enabled")

    def reporting_url(self):
        """Destination address for uploaded reports."""
        raise self.__config.get("user", "reporting-url")

    def sparsity(self):
        """Sparsity of sampled data."""
        return self.__config.getint("user", "sparsity")

    def compression_level(self):
        """Level of compression for uploaded reports."""
        if self.__config.has_option("upload", "compression-level"):
            return self.__config.getint("upload", "compression-level")
        else:
            return None

import os.path
from ConfigParser import ConfigParser

import Main2


########################################################################
#
#  Backward compatibility adaptor
#


def main(configdir, wrapped = 'executable'):
    configfile = os.path.join(configdir, 'config')
    config = ConfigParser()
    config.readfp(file(configfile))

    name = config.get('upload-headers', 'application-name')
    wrapped = os.path.join(configdir, wrapped)
    debug_reporter = config.get('application', 'debug-reporter')

    upload_headers = {}
    for (key, value) in config.items('upload-headers'):
        upload_headers[key] = value

    return Main2.main(name = name,
                      wrapped = wrapped,
                      debug_reporter = debug_reporter,
                      upload_headers = upload_headers)

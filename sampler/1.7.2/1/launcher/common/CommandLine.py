from glib.option import OptionParser
from optparse import BadOptionError
import sys

import SamplerConfig


########################################################################


def parse():
    parser = OptionParser(version=SamplerConfig.version)
    try:
        parser.parse_args()
    except BadOptionError, error:
        parser.error(error)

    if sys.argv[1:]:
        parser.error('too many arguments')

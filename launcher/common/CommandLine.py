from argparse import ArgumentParser

import SamplerConfig


########################################################################


def parse():
    parser = ArgumentParser()
    parser.add_argument('-v', '--version', action='version', version=SamplerConfig.version)
    parser.parse_args()

import os.path
from sys import stderr

import gconf

import Paths


class AppFinder(list):
    def __init__(self):
        for dir in Paths.appdirs:
            self.__find(dir)

    def __find(self, dir):
        if not os.path.isdir(dir):
            return

        config = os.path.join(dir, 'config')
        if os.path.isfile(config):
            self.append(dir)

        for subdir in os.listdir(dir):
            self.__find(os.path.join(dir, subdir))

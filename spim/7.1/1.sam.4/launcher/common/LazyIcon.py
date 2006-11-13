import os.path
import types

import gtk.gdk

import Keys
import Paths


class LazyIcon:
    def __init__(self, filename):
        self.__image = filename

    def get(self):
        if isinstance(self.__image, types.StringTypes):
            fullpath = os.path.join(Paths.home, self.__image)
            self.__image = gtk.gdk.pixbuf_new_from_file(fullpath)

        return self.__image

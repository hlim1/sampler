import types

import gtk.gdk

import Keys


class LazyIcon:
    def __init__(self, filename):
        self.__image = filename

    def get(self):
        if isinstance(self.__image, types.StringTypes):
            self.__image = gtk.gdk.pixbuf_new_from_file(self.__image)

        return self.__image

class LazyIcon(object):

    __slots__ = ['__image']

    def __init__(self, filename):
        self.__image = filename

    def get(self):
        import types
        if isinstance(self.__image, types.StringTypes):
            import gtk.gdk
            import os.path
            import Paths

            fullpath = os.path.join(Paths.home, self.__image)
            self.__image = gtk.gdk.pixbuf_new_from_file(fullpath)

        return self.__image

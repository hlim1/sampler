import types

import gtk.gdk

import Keys


class __IconPair:
    def __init__(self, disabled, enabled):
        self.__images = [disabled, enabled]

    def get(self, client):
        enabled = client.get_bool(Keys.master)
        if isinstance(self.__images[enabled], types.StringTypes):
            self.__images[enabled] = gtk.gdk.pixbuf_new_from_file(self.__images[enabled])

        return self.__images[enabled]

big = __IconPair('disabled.png', 'enabled.png')
small = __IconPair('small-disabled.png', 'small-enabled.png')

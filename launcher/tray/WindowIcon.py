from StatusIcon import StatusIcon

import IconPair


class WindowIcon(StatusIcon):
    def __init__(self, client, widget):
        StatusIcon.__init__(self, client, IconPair.big, widget.set_icon)

import gnome.ui

from DialogWrapper import DialogWrapper


########################################################################
#
#  GUI callbacks and helpers for first-time opt-in dialog
#


class FirstTime (DialogWrapper):
    def __init__(self, dir, gconfig):
        DialogWrapper.__init__(self, dir, 'first-time')

        # replace the HRef button with a clone of itself to work around a libglade bug
        # <http://bugzilla.gnome.org/show_bug.cgi?id=112470>
        oldLink = self.get_widget('learn-more')
        newLink = gnome.ui.HRef(oldLink.get_property('url'), oldLink.get_property('label'))
        linkParent = oldLink.parent
        oldLink.destroy()
        linkParent.add(newLink)
        newLink.show()

        # set initial state for yes/no radio buttons and associated labels
        self.__gconfig = gconfig
        self.__enabled = gconfig['enabled']
        self.__yesno_set()

    def __yesno_update(self, name, active):
        radio = self.get_widget(name)
        details = self.get_widget(name + '-details')
        radio.set_active(active)
        details.set_sensitive(active)

    def __yesno_set(self):
        self.__yesno_update('yes', self.__enabled)
        self.__yesno_update('no', not self.__enabled)

    def on_yes_toggled(self, yes):
        self.__enabled = yes.get_active()
        self.__yesno_set()
        self.__gconfig['enabled'] = self.__enabled

    def enabled(self):
        return self.__enabled

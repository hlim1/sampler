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

        # hook up gconf notifications and set initial state
        self.__gconfig = gconfig
        gconfig.notify_add('enabled', self.gconf_on_enabled)
        self.gconf_on_enabled()

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

    def gconf_on_enabled(self):
        self.__enabled = self.__gconfig['enabled']
        self.__yesno_set()

    def enabled(self):
        return self.__enabled

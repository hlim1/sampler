import pygtk
pygtk.require('2.0')


########################################################################


def main(register):
    import gnome
    import Config
    gnome.program_init('preferences', Config.version)

    import gconf
    from GConfDir import GConfDir
    import Keys
    client = gconf.client_get_default()
    dir = GConfDir(client, Keys.root, gconf.CLIENT_PRELOAD_NONE)

    from Factory import Factory
    from PreferencesDialog import PreferencesDialog
    dialog = PreferencesDialog(client)
    if register: factory = Factory(dialog)
    dialog.run()

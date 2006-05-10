import pygtk
pygtk.require('2.0')


########################################################################


def main(register):
    import gnome
    import SamplerConfig
    gnome.program_init('preferences', SamplerConfig.version)

    import gconf
    from GConfDir import GConfDir
    import Keys
    client = gconf.client_get_default()
    gconf_dir = GConfDir(client, Keys.root, gconf.CLIENT_PRELOAD_NONE)

    from Factory import Factory
    from PreferencesDialog import PreferencesDialog
    dialog = PreferencesDialog(client)
    if register: factory = Factory(dialog)
    dialog.run()

    if register: del factory
    del gconf_dir

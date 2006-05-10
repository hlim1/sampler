import pygtk
pygtk.require('2.0')


########################################################################


def main(register):
    import gnome
    import SamplerConfig
    gnome.program_init('preferences', SamplerConfig.version)

    import gconf
    client = gconf.client_get_default()

    from Factory import Factory
    from PreferencesDialog import PreferencesDialog
    dialog = PreferencesDialog(client)
    if register: Factory(dialog)
    dialog.run()

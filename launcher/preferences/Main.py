import pygtk
pygtk.require('2.0')


########################################################################


def new_instance(app, argc, argv, dialog):
    __pychecker__ = 'no-argsused'
    dialog.present()
    return 0


def main():
    import gnome
    import SamplerConfig
    gnome.program_init('preferences', SamplerConfig.version)

    import bonobo
    app = bonobo.Application('Sampler Preferences')
    signature = app.create_serverinfo(('DISPLAY',))
    client = app.register_unique(signature)

    if client == None:
        from PreferencesDialog import PreferencesDialog
        dialog = PreferencesDialog()
        app.connect("new-instance", new_instance, dialog)
        dialog.run()

    else:
        app.unref()
        del app
        client.new_instance([])
        import gtk.gdk
        gtk.gdk.notify_startup_complete()

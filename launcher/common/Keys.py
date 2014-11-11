ASKED = 'asked'
MASTER = 'enabled'


def settings():
    # always use "schema_id" once Fedora 20 is no longer supported
    import gi
    key = 'schema_id' if gi.version_info >= (3, 14) else 'schema'

    from gi.repository import Gio
    return Gio.Settings(**{key: 'edu.wisc.cs.cbi'})

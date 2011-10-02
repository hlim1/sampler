from gi.repository import Gtk
from os.path import abspath, dirname, join


########################################################################


def __source(abled, size):
    home = dirname(abspath(__file__))
    filename = '%s-%d.png' % (abled, size)
    source = Gtk.IconSource()
    source.set_filename(join(home, filename))
    return source


def __install(factory, abled):
    source_48 = __source(abled, 48)
    source_48.set_size_wildcarded(False)
    source_48.set_size(Gtk.IconSize.DIALOG)

    source_96 = __source(abled, 96)
    #source_96.set_size_wildcarded(False)
    source_96.set_size(ICON_SIZE_EMBLEM)

    icons = Gtk.IconSet()
    icons.add_source(source_48)
    icons.add_source(source_96)
    factory.add('sampler-' + abled, icons)


ICON_SIZE_EMBLEM = Gtk.icon_size_register('sampler-emblem', 96, 96)

__factory = Gtk.IconFactory()
__install(__factory, 'disabled')
__install(__factory, 'enabled')
__factory.add_default()

stock = ['sampler-disabled', 'sampler-enabled']

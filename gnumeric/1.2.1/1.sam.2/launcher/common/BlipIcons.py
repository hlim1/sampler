import os.path
import sys

import gtk

import Config


########################################################################


def __source(abled, size):
    source = gtk.IconSource()
    filename = abled + '-' + str(size) + '.png'
    source.set_filename(os.path.join(Config.pixmapsdir, filename))
    return source


def __install(abled):
    set = gtk.IconSet()

    source_48 = __source(abled, 48)
    source_48.set_size_wildcarded(gtk.FALSE)
    source_48.set_size(gtk.ICON_SIZE_DIALOG)
    set.add_source(source_48)

    source_96 = __source(abled, 96)
    #source_96.set_size_wildcarded(gtk.FALSE)
    source_96.set_size(ICON_SIZE_EMBLEM)
    set.add_source(source_96)

    factory = gtk.IconFactory()
    factory.add('sampler-' + abled, set)
    factory.add_default()


ICON_SIZE_EMBLEM = gtk.icon_size_register('sampler-emblem', 96, 96)

__install('disabled')
__install('enabled')

stock = ['sampler-disabled', 'sampler-enabled']

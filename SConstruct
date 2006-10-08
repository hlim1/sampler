import os
from os.path import exists

from SCons.Errors import UserError


########################################################################
#
#  version numbering
#

version = File('version').get_contents().rstrip()


########################################################################
#
#  configurable options
#

def validate_cil_path(key, value, env):
    suffix = {True:'.cmxa', False:'.cma'}[env['OCAML_NATIVE']]
    library = '%s/cil%s' % (value, suffix)
    if not exists(library):
        raise UserError('%s does not exist for option %s: %s' % (library, key, value))

opts = Options(None, ARGUMENTS)
opts.AddOptions(
    BoolOption('OCAML_NATIVE', 'compile OCaml to native code', False),
    PathOption('prefix', 'install in the given directory', '/usr/local'),
    ('cil_path', 'look for CIL in the given directory', '../cil/obj/x86_LINUX', validate_cil_path),
    PathOption('objcopy', 'use the given objcopy executable', WhereIs('objcopy')),
    )


########################################################################
#
#  shared build environment
#

env = Environment(
    tools=['default', 'ocaml', 'template', 'test'], toolpath=['.'],
    CCFLAGS=['-W', '-Wall', '-Werror', '-Wformat=2'],
    OCAML_DTYPES=True, OCAML_WARN='A', OCAML_WARN_ERROR='A',
    options=opts,
    VERSION=version,
    version=version,
    prefix='/usr',

    # various derived paths
    bindir='$prefix/bin',
    commondir='$pkgdatadir/common',
    datadir='$prefix/share',
    driverdir='$pkglibdir/driver',
    exec_prefix='$prefix',
    first_timedir='$pkgdatadir/first-time',
    libdir='$prefix/lib',
    pixmapsdir='$pkgdatadir/pixmaps',
    pkgdatadir='$datadir/sampler',
    pkglibdir='$libdir/sampler',
    preferencesdir='$pkgdatadir/preferences',
    traydir='$pkgdatadir/tray',
    wrapperdir='$pkgdatadir/wrapper',
    )

# needed for some pychecker tests
if 'DISPLAY' in os.environ:
    env.AppendUnique(ENV={'DISPLAY': os.environ['DISPLAY']})
if 'XAUTHORITY' in os.environ:
    env.AppendUnique(ENV={'XAUTHORITY': os.environ['XAUTHORITY']})

env.SourceCode('.', None)
SConsignFile()
Help(opts.GenerateHelpText(env))
Export('env')


########################################################################
#
# performance boosters
#

CacheDir('.scons-cache')
SetOption('implicit_cache', True)
SetOption('max_drift', 1)
#SourceSignatures('timestamp')


########################################################################
#
#  subsidiary scons scripts
#

SConscript(dirs=[
    'doc',
    'driver',
    'fuzz',
    'instrumentor',
    'launcher',
    'lib',
    'ocaml',
    'tools',
    ])

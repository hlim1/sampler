from os.path import exists

from SCons.Errors import UserError


########################################################################
#
#  version numbering
#

version = File('version').get_contents()
Export('version')


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
    )


########################################################################
#
#  shared build environment
#

env = Environment(
    tools=['default', 'ocaml'], toolpath=['.'],
    CCFLAGS=['-W', '-Wall', '-Werror', '-Wformat=2'],
    OCAML_DTYPES=True, OCAML_WARN='A', OCAML_WARN_ERROR='A',
    options=opts,
    prefix='/usr',
    )

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
    'fuzz',
    'instrumentor',
    'launcher',
    'lib',
    'ocaml',
    'tools',
    ])

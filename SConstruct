########################################################################
#
#  version numbering
#

version = File('version').get_contents()
Export('version')


########################################################################
#
#  shared build environment and configurable options
#


SConsignFile()

opts = Options(None, ARGUMENTS)
opts.AddOptions(
    BoolOption('OCAML_NATIVE', 'compile OCaml to native code', False),
    PathOption('prefix', 'install in the given directory', '/usr/local'),
    )

env = Environment(
    tools=['default', 'ocaml'], toolpath=['.'],
    #CPPPATH=['/usr/include', '/usr/lib/gcc/i386-redhat-linux/4.1.1/include/'],
    CCFLAGS=['-W', '-Wall', '-Werror', '-Wformat=2'],
    OCAML_DTYPES=True, OCAML_WARN='A', OCAML_WARN_ERROR='A',
    options=opts,
    prefix='/usr',
    )

env.SourceCode('.', None)

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

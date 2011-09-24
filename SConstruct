import os
import stat
import sys
import platform

from itertools import chain
from socket import getfqdn
from shutil import copy2

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

lib64 = 'lib' + {'32bit': '', '64bit': '64'}[platform.architecture()[0]]

def validate_gcc_path(key, value, env):
    if not value:
        value = env['gcc'] = env.WhereIs('gcc')

    PathVariable.PathIsFile(key, value, env)


def validate_cil_path(key, value, env):

    suffix = {True:'.cmxa', False:'.cma'}[env['OCAML_NATIVE']]

    def libcil(path):
        return env.File('cil' + suffix, path)

    if value:
        library = libcil(value)
        if library.exists():
            return
        else:
            raise UserError('bad option %s: %s does not exist' % (key, library))
    else:
        paths = [
            '../cil/obj/x86_LINUX',
            '/usr/local/%s/ocaml/cil' % lib64,
            '/usr/local/%s/cil' % lib64,
            '/usr/%s/ocaml/cil' % lib64,
            '/usr/%s/cil' % lib64,
            ]
        for path in paths:
            library = libcil(path)
            if library.exists():
                env[key] = path
                return
        raise UserError('cannot find CIL libraries; use cil_path option')


opts = Variables('.scons-config', ARGUMENTS)
opts.AddVariables(
    BoolVariable('GSETTINGS_SCHEMAS_COMPILE', 'compile installed GSettings schemas', True),
    BoolVariable('OCAML_NATIVE', 'compile OCaml to native code', False),
    BoolVariable('debug', 'compile for debugging', False),
    PathVariable('prefix', 'install in the given directory', '/usr/local'),
    PathVariable('DESTDIR', 'extra installation directory prefix', '/'),
    PathVariable('gcc', 'path to native GCC C compiler', None, validate_gcc_path),
    ('cil_path', 'look for CIL in the given directory', '', validate_cil_path),
    ('extra_cflags', 'extra C compiler flags'),
    EnumVariable('tuple_counter_bits', 'in tuple counters, use unsigned integers of the specified bit-width', 'natural', ['32', '64', 'natural']),
    )

env = Environment(options=opts)
opts.Save('.scons-config', env)

domainname = getfqdn().split('.', 1)[1]
if domainname == 'cs.wisc.edu':
    print 'adding special tweaks for', domainname
    env.AppendENVPath('PATH', '/unsup/ocaml/bin')
    env['pychecker'] = [sys.executable, '/unsup/pychecker/lib/python2.4/site-packages/pychecker/checker.py']

env['cil_path'] = env.Dir('$cil_path')
env.SetDefault(gcc=env.WhereIs('gcc'))


########################################################################
#
#  shared build environment
#

env = env.Clone(
    tools=['default', 'ocaml', 'template', 'test', 'xml'], toolpath=['scons-tools'],
    CCFLAGS=['-Wall', '-Wextra', '-Werror', '-Wformat=2'],
    OCAML_DEBUG=env['debug'],
    OCAML_DTYPES=True,
    OCAML_WARN='A',
    OCAML_WARN_ERROR='A',
    PERL=env.WhereIs('perl'),

    PACKAGE='sampler',
    PACKAGE_NAME='$PACKAGE',
    PACKAGE_VERSION=version,
    PACKAGE_BUGREPORT='liblit@cs.wisc.edu',
    NAME='$PACKAGE_NAME',
    VERSION=version,
    version=version,
    deployment_release_suffix='',
    enable_deployment='default',
    TARCOMSTR='$TAR $TARFLAGS -f $TARGET $$SOURCES',

    # various derived paths
    applicationsdir='$datadir/applications',
    bindir='$prefix/bin',
    commondir='$pkgdatadir/common',
    datarootdir='$prefix/share',
    datadir='$datarootdir',
    docdir='$datadir/sampler/doc',
    driverdir='$pkglibdir/driver',
    exec_prefix='$prefix',
    first_timedir='$pkgdatadir/first-time',
    lib64=lib64,
    libdir='$prefix/$lib64',
    localstatedir='/var',
    omfdir='$datadir/omf/sampler',
    pixmapsdir='$pkgdatadir/pixmaps',
    pkgdatadir='$datadir/sampler',
    pkglibdir='$libdir/sampler',
    preferencesdir='$pkgdatadir/preferences',
    samplerdir='$driverdir/sampler',
    schemadir='$datadir/glib-2.0/schemas',
    schemesdir='$samplerdir/schemes',
    sysconfdir='/etc',
    threadsdir='$samplerdir/threads',
    toolsdir='$pkglibdir/tools',
    traydir='$pkgdatadir/tray',
    wrapperdir='$pkgdatadir/wrapper',
    wwwdir='$localstatedir/www',
    )

env.MergeFlags(env.get('extra_cflags'))

env.File([
        'scons-tools/ocaml.py',
        'scons-tools/pipe.py',
        'scons-tools/template.py',
        'scons-tools/test.py',
        'scons-tools/utils.py',
        'scons-tools/xml.py',
        ])

# needed for some pychecker tests
if 'DISPLAY' in os.environ:
    env.AppendUnique(ENV={'DISPLAY': os.environ['DISPLAY']})
if 'XAUTHORITY' in os.environ:
    env.AppendUnique(ENV={'XAUTHORITY': os.environ['XAUTHORITY']})

env.SourceCode('.', None)
SConsignFile()
Help(opts.GenerateHelpText(env))
Export('env')


def distroName(context):
    context.Message('checking for distribution name: ')
    name = {
        'centos': 'centos',
        'debian': 'debian',
        'fedora': 'fedora',
        'redhat': 'rhel',
        }[platform.dist()[0]]
    context.env['DISTRO_NAME'] = name
    context.Result(name)

def distroBasis(context):
    context.Message('checking for distribution basis: ')
    basis = {
        'centos': 'rpm',
        'debian': 'debian',
        'fedora': 'rpm',
	'rhel': 'rpm',
        }[context.env['DISTRO_NAME']]
    context.env['DISTRO_BASIS'] = basis
    context.Result(basis)
    return basis

def distroCpu(context):
    context.Message('checking for distribution cpu: ')
    action = {
        'rpm': [['rpm', '--eval', '%_target_cpu', '>', '$TARGET']],
        'debian': [['dpkg-architecture', '-s', '-qDEB_BUILD_ARCH', '>', '$TARGET']],
        }[env['DISTRO_BASIS']]
    (status, cpu) = context.TryAction(action)
    if status:
        cpu = cpu.rstrip()
        context.env['DISTRO_CPU'] = cpu
        context.Result(cpu)
    else:
        context.Result(False)
        context.env.Exit(1)

conf = env.Configure(
    clean=False, help=False,
    custom_tests={
        'DistroName': distroName,
        'DistroBasis': distroBasis,
        'DistroCpu': distroCpu,
        })
conf.DistroName()
conf.DistroBasis()
conf.DistroCpu()
conf.Finish()

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
#  installation
#

def install(dest, source, env):
    copy2(source, dest)
    mode = stat.S_IWUSR | stat.S_IRUSR | stat.S_IRGRP | stat.S_IROTH
    if os.stat(source).st_mode & stat.S_IXUSR:
        mode |= stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH
    os.chmod(dest, mode)
    # todo: parent directories have wrong permissions

env['INSTALL'] = install


for dir in ['sites', 'wrapped']:
    target = env.Dir('$DESTDIR$pkglibdir/' + dir)
    env.Command(target, None, Mkdir('$TARGET'))
    Alias('install', target)


########################################################################
#
#  regular build targets in this directory
#

spec = env.Template('sampler.spec.in', varlist=[
        'PACKAGE_NAME',
        'PACKAGE_VERSION',
        'PACKAGE_BUGREPORT',
        'deployment_release_suffix',
        'enable_deployment',
        ], template_copy_mode=False)

AddPostAction(spec, [Chmod('$TARGET', 0644)])
Default(spec)


########################################################################
#
#  subsidiary scons scripts
#

excludedSources = set(['config.log'])
Export('excludedSources')

SConscript(dirs=[
    'debian',
    'doc',
    'driver',
    'fuzz',
    'instrumentor',
    'launcher',
    'lib',
    'ocaml',
    'tools',
    'www',
    ])


########################################################################
#
#  packaging
#

env.File([
        'AUTHORS',
        'COPYING',
        'NEWS',
        ])

excludedSources = set(map(env.File, excludedSources))
sources = set(env.FindSourceFiles()) - excludedSources
sources = sorted(sources, key=lambda node: node.path)

env.Tool('packaging')
package = env.Package(
    NAME='${NAME}',
    VERSION='${VERSION}',
    PACKAGETYPE='src_targz',
    source=sources,
    )[0]

AddPostAction(package, [Chmod('$TARGET', 0644)])

subdirs = [
    'BUILD',
    'RPMS/$DISTRO_CPU',
    'SOURCES',
    'SRPMS',
    ]

redhat = Dir('redhat')

subpackages = ['devel', 'libs', 'server']
def rpm_targets():
    yield 'SRPMS/$NAME-${VERSION}-1${deployment_release_suffix}.src.rpm'
    yield 'RPMS/$DISTRO_CPU/$NAME-${VERSION}-1${deployment_release_suffix}.${DISTRO_CPU}.rpm'
    for subpackage in subpackages:
        yield 'RPMS/$DISTRO_CPU/$NAME-%s-${VERSION}-1${deployment_release_suffix}.${DISTRO_CPU}.rpm' % subpackage

rpms = env.File(list(rpm_targets()), redhat)

def rpm_action():
    yield Delete('redhat')
    for subdir in subdirs:
        yield Mkdir(env.Dir(subdir, redhat))
    yield Copy(redhat.Dir('SOURCES'), package)
    yield ['rpmbuild', '--define', '_topdir %s' % redhat.abspath, '-ba', '$SOURCE']


Command(rpms, ['sampler.spec', package], list(rpm_action()))
Alias('rpms', rpms)

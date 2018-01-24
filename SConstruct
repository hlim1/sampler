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
#  basic build platform detection
#

def distroName(context):
    context.Message('checking for distribution name: ')
    name = {
        'centos': 'centos',
        'debian': 'debian',
        'fedora': 'fedora',
        'redhat': 'rhel',
        'Ubuntu': 'ubuntu',
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
        'ubuntu': 'debian'
        }[context.env['DISTRO_NAME']]
    context.env['DISTRO_BASIS'] = basis
    context.Result(basis)
    return basis

def distroVersion(context):
    context.Message('checking for distribution version: ')
    version = platform.dist()[1]
    context.env['DISTRO_VERSION'] = version
    context.Result(version)

def distroArch(context):
    context.Message('checking for distribution architecture: ')
    action = {
        'rpm': [['rpm', '--eval', '%_build_arch', '>', '$TARGET']],
        'debian': [['dpkg-architecture', '-s', '-qDEB_BUILD_GNU_CPU', '>', '$TARGET']],
        }[env['DISTRO_BASIS']]
    (status, arch) = context.TryAction(action)
    if status:
        arch = arch.rstrip()
        context.env['DISTRO_ARCH'] = arch
        context.Result(arch)
    else:
        context.Result(False)
        context.env.Exit(1)

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

env = Environment()

conf = env.Configure(
    clean=True, help=False,
    custom_tests={
        'DistroName': distroName,
        'DistroBasis': distroBasis,
        'DistroVersion': distroVersion,
        'DistroArch': distroArch,
        'DistroCpu': distroCpu,
        })
conf.DistroName()
conf.DistroBasis()
conf.DistroVersion()
conf.DistroArch()
conf.DistroCpu()
conf.Finish()

lib64 = 'lib' + {
    ('32bit', 'debian'): '32',
    ('64bit', 'debian'): '',
    ('32bit', 'rpm'): '',
    ('64bit', 'rpm'): '64',
}[platform.architecture()[0], env['DISTRO_BASIS']]


########################################################################
#
#  configurable options
#

def validate_gcc_path(key, value, env):
    if not value:
        value = env['gcc'] = env.WhereIs('gcc')

    PathVariable.PathIsFile(key, value, env)


def validate_cil_paths(paths, env):
    suffix = {True:'.cmxa', False:'.cma'}[env['OCAML_NATIVE']]
    basename = 'cil' + suffix
    library = env.FindFile(basename, paths)
    if library:
        return library.dir


def validate_cil_path(key, value, env):
    paths = (value,)
    if not validate_cil_paths(paths, env):
        raise UserError('bad %s option: cannot find CIL libraries under %s' % (key, value))
    env['cil_paths'] = map(env.Dir, paths)


def guess_cil_path(env):
    paths = (
        '/usr/local/%s/ocaml/cil' % lib64,
        '/usr/local/%s/cil' % lib64,
        '/usr/%s/ocaml/cil' % lib64,
        '/usr/%s/cil' % lib64,
        )
    selected = validate_cil_paths(paths, env)
    if not selected:
        raise UserError('cannot find CIL libraries; use cil_path or cil_build option')
    env['cil_paths'] = env.Dir(selected)


def validate_cil_build(key, value, env):
    subdirs = (
        'src',
        'src/ext',
        'src/frontc',
        'src/ocamlutil',
        )
    paths = ['%s/_build/%s' % (value, subdir) for subdir in subdirs]
    if not validate_cil_paths(paths, env):
        raise UserError('cannot find CIL libraries under %s' % value)
    env['cil_paths'] = map(env.Dir, paths)


opts = Variables('.scons-config', ARGUMENTS)
opts.AddVariables(
    BoolVariable('GSETTINGS_SCHEMAS_COMPILE', 'compile installed GSettings schemas', True),
    BoolVariable('OCAML_NATIVE', 'compile OCaml to native code', False),
    BoolVariable('debug', 'compile for debugging', False),
    PathVariable('prefix', 'install in the given directory', '/usr/local'),
    PathVariable('DESTDIR', 'extra installation directory prefix', '/', PathVariable.PathIsDirCreate),
    PathVariable('gcc', 'path to native GCC C compiler', None, validate_gcc_path),
    ('cil_path', 'look for CIL in the given directory', None, validate_cil_path),
    ('cil_build', 'look for CIL in the build tree', None, validate_cil_build),
    ('extra_cflags', 'extra C compiler flags'),
    EnumVariable('tuple_counter_bits', 'in tuple counters, use unsigned integers of the specified bit-width', 'natural', ['32', '64', 'natural']),
    BoolVariable('launcher', 'include GNOME launcher code', True),
    )

opts.Update(env)
opts.Save('.scons-config', env)

if not 'cil_paths' in env:
    guess_cil_path(env)

try:
    domainname = getfqdn().split('.', 1)[1]
except IndexError:
    domainname = None

env.SetDefault(gcc=env.WhereIs('gcc'))


########################################################################
#
#  shared build environment
#

env = env.Clone(
    tools=['default', 'ocaml', 'python', 'template', 'test', 'xml'], toolpath=['scons-tools'],
    CCFLAGS=['-Wall', '-Wextra', '-Werror', '-Wformat=2'],
    OCAML_DEBUG=env['debug'],
    OCAML_DTYPES=True,
    OCAML_WARN='A',
    OCAML_WARN_ERROR='A',

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
        'scons-tools/python.py',
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

subdirs = set((
        'debian',
        'doc',
        'driver',
        'fuzz',
        'instrumentor',
        'lib',
        'ocaml',
        'tools',
        'www',
        ))

if env['launcher']:
    subdirs.add('launcher')

SConscript(dirs=sorted(subdirs))


########################################################################
#
#  tar packaging
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


########################################################################
#
#  RPM packaging
#

redhat = Dir('redhat')

srpm = env.File('SRPMS/$NAME-$VERSION-1${deployment_release_suffix}.src.rpm', redhat)
env.Command(srpm, [spec, package], [[
            'rpmbuild', '-bs',
            '--define', '_topdir ' + redhat.path,
            '--define', '_sourcedir .',
            '$SOURCE',
            ]])
Clean(srpm, env.Dir(['BUILD', 'BUILDROOT', 'SOURCES', 'SPECS'], redhat))

def rpm_targets(env):
    rpmdir = env.Dir('RPMS/$TARGET_ARCH', redhat)
    yield env.File('$NAME-$VERSION-1${deployment_release_suffix}.${TARGET_CPU}.rpm', rpmdir)
    for subpackage in 'devel', 'libs', 'server':
        yield env.File('$NAME-%s-$VERSION-1${deployment_release_suffix}.${TARGET_CPU}.rpm' % subpackage, rpmdir)

targetArchCPUs = frozenset((
            (env.get('DISTRO_ARCH'), env.get('DISTRO_CPU')),
            ('i386', 'i686'),
            ))

if env['DISTRO_BASIS'] == 'rpm':
    for arch, cpu in targetArchCPUs:
        tenv = env.Clone(
            TARGET_ARCH=arch,
            TARGET_CPU=cpu,
        )
        targets = list(rpm_targets(tenv))
        tenv.Command(targets, srpm, 'mock --root=$DISTRO_NAME-$DISTRO_VERSION-$TARGET_ARCH --resultdir=${TARGETS[0].dir} $SOURCE')
        Alias('rpms', targets)

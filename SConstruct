import os
import stat
import sys

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
        for path in ['../cil/obj/x86_LINUX', '/usr/local/lib/ocaml/cil', '/usr/local/lib/cil', '/usr/lib/ocaml/cil', '/usr/lib/cil']:
            library = libcil(path)
            if library.exists():
                env[key] = path
                return
        raise UserError('cannot find CIL libraries; use cil_path option')

opts = Variables(None, ARGUMENTS)
opts.AddVariables(
    BoolVariable('GCONF_SCHEMAS_INSTALL', 'install GConf schemas', True),
    BoolVariable('OCAML_NATIVE', 'compile OCaml to native code', False),
    PathVariable('prefix', 'install in the given directory', '/usr/local'),
    PathVariable('DESTDIR', 'extra installation directory prefix', '/'),
    BoolVariable('launcher', 'build client application launcher and related tools', True),
    ('cil_path', 'look for CIL in the given directory', '', validate_cil_path),
    ('extra_cflags', 'extra C compiler flags'),
    )

env = Environment(options=opts)

domainname = getfqdn().split('.', 1)[1]
if domainname == 'cs.wisc.edu':
    print 'adding special tweaks for', domainname
    env.AppendENVPath('PATH', '/unsup/ocaml/bin')
    env['pychecker'] = [sys.executable, '/unsup/pychecker/lib/python2.4/site-packages/pychecker/checker.py']
    env['PKG_CONFIG_PATH'] = '/usr/lib/pkgconfig'
    env['launcher'] = False

env['cil_path'] = env.Dir('$cil_path')


########################################################################
#
#  shared build environment
#

env = env.Clone(
    tools=['default', 'ocaml', 'template', 'test'], toolpath=['.'],
    CCFLAGS=['-Wall', '-Wextra', '-Werror', '-Wformat=2'],
    OCAML_DTYPES=True, OCAML_WARN='A', OCAML_WARN_ERROR='A',
    PERL=env.WhereIs('perl'),

    PACKAGE='sampler',
    PACKAGE_NAME='$PACKAGE',
    PACKAGE_VERSION=version,
    PACKAGE_BUGREPORT='liblit@cs.wisc.edu',
    NAME='$PACKAGE_NAME',
    VERSION=version,
    version=version,
    deployment_learn_more_url='http://www.cs.wisc.edu/cbi/learn-more/',
    deployment_release_suffix='',
    enable_deployment='default',
    TARCOMSTR='$TAR $TARFLAGS -f $TARGET $$SOURCES',

    pkg_config='PKG_CONFIG_PATH=$PKG_CONFIG_PATH pkg-config',

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
    libdir='$prefix/lib',
    localstatedir='/var',
    omfdir='$datadir/omf/sampler',
    pixmapsdir='$pkgdatadir/pixmaps',
    pkgdatadir='$datadir/sampler',
    pkglibdir='$libdir/sampler',
    preferencesdir='$pkgdatadir/preferences',
    samplerdir='$driverdir/sampler',
    schemadir='$sysconfdir/gconf/schemas',
    schemesdir='$samplerdir/schemes',
    sysconfdir='/etc',
    threadsdir='$samplerdir/threads',
    toolsdir='$pkglibdir/tools',
    traydir='$pkgdatadir/tray',
    wrapperdir='$pkgdatadir/wrapper',
    wwwdir='$localstatedir/www',
    )

env.MergeFlags(env.get('extra_cflags'))

env.File(['ocaml.py', 'template.py', 'test.py', 'utils.py'])

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

SConscript(dirs=[
    'debian',
    'doc',
    'driver',
    'fuzz',
    'instrumentor',
    'lib',
    'ocaml',
    'tools',
    'www',
    ])

if env['launcher']:
    SConscript(dirs=['launcher'])


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
    'RPMS/i386',
    'SOURCES',
    'SRPMS',
    ]

redhat = Dir('redhat')

subpackages = ['devel', 'libs', 'server']
def rpm_targets():
    yield 'SRPMS/$NAME-${VERSION}-1${deployment_release_suffix}.src.rpm'
    yield 'RPMS/i386/$NAME-${VERSION}-1${deployment_release_suffix}.i386.rpm'
    for subpackage in subpackages:
        yield 'RPMS/i386/$NAME-%s-${VERSION}-1${deployment_release_suffix}.i386.rpm' % subpackage

rpms = env.File(list(rpm_targets()), redhat)

def rpm_action():
    yield Delete('redhat')
    for subdir in subdirs:
        yield Mkdir(redhat.Dir(subdir))
    yield Copy(redhat.Dir('SOURCES'), package)
    yield ['rpmbuild', '--define', '_topdir %s' % redhat.abspath, '-ba', '$SOURCE']


Command(rpms, ['sampler.spec', package], list(rpm_action()))
Alias('rpms', rpms)

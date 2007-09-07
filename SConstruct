import os
import stat

from os.path import exists
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
        return '%s/cil%s' % (path, suffix)

    if value:
        library = libcil(value)
        if exists(library):
            return
        else:
            raise UserError('bad option %s: %s does not exist' % (key, library))
    else:
        for path in ['../cil/obj/x86_LINUX', '/usr/local/lib/cil', '/usr/lib/cil']:
            library = libcil(path)
            if exists(library):
                env[key] = path
                return
        raise UserError('cannot find CIL libraries; use cil_path option')

opts = Options(None, ARGUMENTS)
opts.AddOptions(
    BoolOption('GCONF_SCHEMAS_INSTALL', 'install GConf schemas', True),
    BoolOption('OCAML_NATIVE', 'compile OCaml to native code', False),
    PathOption('prefix', 'install in the given directory', '/usr/local'),
    PathOption('DESTDIR', 'extra installation directory prefix', '/'),
    ('cil_path', 'look for CIL in the given directory', '', validate_cil_path),
    )

env = Environment(options=opts)
domainname = getfqdn().split('.', 1)[1]
if domainname == 'cs.wisc.edu':
    print 'adding special tweaks for', domainname
    env.AppendENVPath('PATH', '/unsup/ocaml/bin')
    env.AppendENVPath('PATH', '/unsup/pychecker/bin')
    env['PKG_CONFIG_PATH'] = '/usr/lib/pkgconfig'


########################################################################
#
#  shared build environment
#

env = env.Copy(
    tools=['default', 'dist', 'ocaml', 'template', 'test'], toolpath=['.'],
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
    dist='#/$PACKAGE-${PACKAGE_VERSION}.tar.gz',

    pkg_config='PKG_CONFIG_PATH=$PKG_CONFIG_PATH pkg-config',

    # various derived paths
    applicationsdir='$datadir/applications',
    bindir='$prefix/bin',
    commondir='$pkgdatadir/common',
    datarootdir='$prefix/share',
    datadir='$datadir',
    docdir='$datadir/sampler/doc',
    driverdir='$pkglibdir/driver',
    exec_prefix='$prefix',
    first_timedir='$pkgdatadir/first-time',
    libdir='$prefix/lib',
    localstatedir='$prefix/var',
    omfdir='$datadir/omf/sampler',
    pixmapsdir='$pkgdatadir/pixmaps',
    pkgdatadir='$datadir/sampler',
    pkglibdir='$libdir/sampler',
    preferencesdir='$pkgdatadir/preferences',
    samplerdir='$driverdir/sampler',
    schemadir='$sysconfdir/gconf/schemas',
    schemesdir='$samplerdir/schemes',
    serversdir='$libdir/bonobo/servers',
    sysconfdir='$prefix/etc',
    threadsdir='$samplerdir/threads',
    toolsdir='$pkglibdir/tools',
    traydir='$pkgdatadir/tray',
    traylibdir='$pkglibdir/tray',
    wrapperdir='$pkgdatadir/wrapper',
    wwwdir='$localstatedir/www',
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

Default(env.Template('sampler.spec.in', varlist=[
	'PACKAGE_NAME',
	'PACKAGE_VERSION',
	'PACKAGE_BUGREPORT',
	'deployment_release_suffix',
]))


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
    'www',
    ])


########################################################################


#env.Tool('packaging')
#package = env.Package(NAME='${NAME}', VERSION='${VERSION}', PACKAGETYPE='src_targz')
#Default(package)

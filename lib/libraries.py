from itertools import imap
from os import symlink
from SCons.Script import *


########################################################################


def symlink_emitter(target, source, env):
    [target] = target
    [source] = source
    source = [source, File(source, target.dir)]
    return target, source


def symlink_action(target, source, env):
    [target] = target
    symlink(str(source[0]), target.abspath)


symlink_builder = Builder(
    action=symlink_action,
    source_factory=Value,
    emitter=symlink_emitter,
    )


########################################################################


def TwoLibraries(env, target, source, objdir='.', **kwargs):
    target = '#driver/' + target
    [static] = env.StaticLibrary(target, source, **kwargs)

    majorVersioned = static.target_from_source('', env.subst('${SHLIBSUFFIX}.${SHLIBVERSION[0]}'))
    unversioned    = static.target_from_source('', env.subst('${SHLIBSUFFIX}'))

    [shared] = env.SharedLibrary(target, source,
                                 SHLIBSUFFIX='${SHLIBSUFFIX}.$_SHLIBVERSION',
                                 SHLINKFLAGS=['$SHLINKFLAGS', '-Wl,-soname,' + majorVersioned.name],
                                 **kwargs)

    Default(
        shared,
        static,
        env.Symlink(majorVersioned, shared.name),
        env.Symlink(unversioned, shared.name),
        )

    libdir = env.Dir('$DESTDIR$libdir')
    Alias('install', [
            env.Install('$DESTDIR$libdir', [static, shared]),
            env.Symlink(libdir.File(majorVersioned.name), shared.name),
            env.Symlink(libdir.File(unversioned.name),    shared.name),
            ])

    return shared


def var_shlibversion(target, source, env, for_signature):
    strings = imap(str, env['SHLIBVERSION'])
    dotted = '.'.join(strings)
    return dotted


########################################################################


def generate(env):
    env.AppendUnique(
        BUILDERS={
            'Symlink': symlink_builder,
            },
        )

    env.SetDefault(
        _SHLIBVERSION=var_shlibversion,
        )

    env.AddMethod(TwoLibraries)


def exists(env):
    return True

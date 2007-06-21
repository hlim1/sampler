import os

from stat import S_IMODE
from string import Template
from sys import stderr

from SCons.Action import Action
from SCons.Builder import Builder
from SCons.Defaults import Chmod
from SCons.Script import Exit

from utils import instantiate


def __instantiate_exec(target, source, env):
    varlist = env['varlist']

    missing = [key for key in varlist if not env.has_key(key)]
    if missing:
        print >>stderr, 'error: missing variables for template instantiation:', ', '.join(missing)
        Exit(1)

    keywords = dict((key, env.subst('$' + key)) for key in varlist)
    instantiate(str(source[0]), str(target[0]), **keywords)

def __instantiate_show(target, source, env):
    __pychecker__ = 'no-argsused'
    return 'instantiate "%s" as "%s"' % (source[0], target[0])

__instantiate = Action(__instantiate_exec, __instantiate_show)


def __chmod_copy_exec(target, source, env):
    mode = os.stat(str(source[0])).st_mode
    mode = S_IMODE(mode)
    env.Execute(Chmod(target, mode))

def __chmod_copy_show(target, source, env):
    __pychecker__ = 'no-argsused'
    return 'copy file mode from "%s" to "%s"' % (source[0], target[0])

__chmod_copy = Action(__chmod_copy_exec, __chmod_copy_show)


def __generator(source, target, env, for_signature):
    __pychecker__ = 'no-argsused'
    varlist = env['varlist']
    return [Action(__instantiate, varlist=varlist),
            __chmod_copy]


__template_builder = Builder(
    generator=__generator,
    src_suffix=['.in'],
    single_source=True,
    )


def generate(env):
    env.AppendUnique(BUILDERS={
        'Template': __template_builder,
        })

def exists(env):
    return True

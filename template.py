from os import stat
from stat import S_IMODE
from string import Template

from SCons.Action import Action
from SCons.Builder import Builder
from SCons.Defaults import Chmod

from utils import instantiate


def __instantiate_exec(target, source, env):
    varlist = env['varlist']
    keywords = dict((key, env[key]) for key in varlist)
    instantiate(str(source[0]), str(target[0]), **keywords)

def __instantiate_show(target, source, env):
    return 'instantiate "%s" from "%s"' % (target[0], source[0])

__instantiate = Action(__instantiate_exec, strfunction=__instantiate_show)


def __chmod_copy_exec(target, source, env):
    mode = stat(str(source[0])).st_mode
    mode = S_IMODE(mode)
    env.Execute(Chmod(target, mode))

def __chmod_copy_show(target, source, env):
    return 'copy file mode to "%s" from "%s"' % (target[0], source[0])

__chmod_copy = Action(__chmod_copy_exec, strfunction=__chmod_copy_show)


def __generator(source, target, env, for_signature):
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

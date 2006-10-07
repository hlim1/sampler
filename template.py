from string import Template

from SCons.Action import Action
from SCons.Builder import Builder
from SCons.Util import scons_subst

from utils import instantiate


def __instantiate(target, source, env):
    varlist = env['varlist']
    keywords = dict((key, env[key]) for key in varlist)
    instantiate(str(source[0]), str(target[0]), **keywords)


def __generator(source, target, env, for_signature):
    varlist = env['varlist']
    return Action(__instantiate, varlist=varlist)


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

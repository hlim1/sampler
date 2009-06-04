from __future__ import with_statement
from SCons.Script import *


def __literal_exec(target, source, env):
    with open(str(target[0]), 'w') as sink:
        print >>sink, source[0].get_contents()


def __literal_show(target, source, env):
    contents = source[0].get_contents()
    return 'create "%s" containing %s' % (target[0], repr(contents))


__literal_action = Action(__literal_exec, __literal_show)


__literal_builder = Builder(
    action=__literal_action,
    source_factory=Value,
    single_source=True,
    )


def generate(env):
    env.AppendUnique(BUILDERS={'Literal': __literal_builder})


def exists(env):
    return True

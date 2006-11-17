from itertools import imap
from string import Template
from subprocess import PIPE, Popen

from SCons.Action import Action

import sys
sys.path[1:1] = ['/usr/lib/scons']


class AtTemplate(Template):

    delimiter = '@'

    pattern = r"""
    (?:
    (?P<escaped>@@) |
    (?P<named>(?!)) |
    @(?P<braced>%(id)s)@ |
    (?P<invalid>(?!))
    )
    """ % {'id': Template.idpattern}


def instantiate(source, sink, **kwargs):
    source = file(source)
    sink = file(sink, 'w')
    for line in source:
        sink.write(AtTemplate(line).substitute(kwargs))
    sink.close()


def read_pipe(action, env):

    def spawn(shell, escape, cmd, args, env):
        __pychecker__ = 'no-argsused'
        command = ' '.join(args)
        process = Popen(command, shell=True, executable=shell, env=env, stdout=PIPE)
        return process.stdout

    env = env.Copy(SPAWN=spawn)
    return env.Execute(action)


def __literal_exec(target, source, env):
    __pychecker__ = 'no-argsused'
    target = file(str(target[0]), 'w')
    print >>target, source[0].get_contents()
    target.close()

def __literal_show(target, source, env):
    return 'create "%s" containing %s' % (target[0], source[0])

__literal_action = Action(__literal_exec, __literal_show)


def literal(env, target, value):
    return env.Command(target, env.Value(value), __literal_action)

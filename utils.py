from itertools import imap
from string import Template
from subprocess import PIPE, Popen

import sys
sys.path[1:1] = ['/usr/lib/scons']


def read_pipe(action, env):

    def spawn(shell, escape, cmd, args, env):
        __pychecker__ = 'no-argsused'
        command = ' '.join(args)
        process = Popen(command, shell=True, executable=shell, env=env, stdout=PIPE)
        return process.stdout

    env = env.Copy(SPAWN=spawn)
    return env.Execute(action)


def instantiate(source, sink, **kwargs):
    source = file(source)
    sink = file(sink, 'w')

    for line in source:
        sink.write(Template(line).substitute(kwargs))


def __literal_action(target, source, env):
    __pychecker__ = 'no-argsused'
    target = file(str(target[0]), 'w')
    print >>target, source[0].get_contents()
    target.close()


def literal(env, target, value):
    return env.Command(target, env.Value(value), __literal_action)

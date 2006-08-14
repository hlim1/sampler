from itertools import imap
from string import Template
from subprocess import PIPE, Popen


def read_pipe(action, env):

    def spawn(shell, escape, cmd, args, env):
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

from SCons.Script import *
from subprocess import CalledProcessError, PIPE, Popen


def ReadPipe(self, command):
    command = map(str, command)
    if not self.GetOption('silent'):
        print ' '.join(command)
    process = Popen(command, env=self['ENV'], stdout=PIPE)

    for line in process.stdout:
        yield line

    status = process.wait()
    if status != 0:
        raise CalledProcessError(status, command[0])


def generate(env):
    env.AddMethod(ReadPipe)

def exists(env):
    return True

import sys
sys.path[1:1] = ['/usr/lib/scons']
from SCons.Action import Action
from SCons.Builder import Builder


########################################################################


__opt_builder = Builder(
    action=Action([[sys.executable, '-O', '-m', 'py_compile', '$SOURCES']]),
    src_suffix='.py',
    suffix='.pyo',
    single_source=True,
    )


def generate(env):
    env.AppendUnique(BUILDERS={'PythonBytecodeOpt': __opt_builder})


def exists(env):
    return True

from SCons.Script import *


def test_suffix(env, sources):
    return sources[0].get_suffix() + '.passed'

def TestBuilder(command, **kwargs):
    return Builder(action=[command, Touch('$TARGET')], suffix=test_suffix, **kwargs)

test_desktop_builder = TestBuilder('desktop-file-validate $SOURCE', single_source=True)
test_python_builder = TestBuilder('$pychecker $pychecker_flags $SOURCES')


def generate(env):
    env.AppendUnique(
        BUILDERS={
        'TestDesktop': test_desktop_builder,
        'TestPython': test_python_builder,
        },
        )

    env.SetDefault(
        pychecker='pychecker',
        pychecker_flags=['--stdlib', '--quiet'],
        )


def exists(env):
    return True

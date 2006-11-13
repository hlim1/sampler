from SCons.Builder import Builder
from SCons.Defaults import Touch


def test_suffix(env, sources):
    return sources[0].get_suffix() + '.passed'

def TestBuilder(command, **kwargs):
    return Builder(action=[command, Touch('$TARGET')], suffix=test_suffix, **kwargs)

test_desktop_builder = TestBuilder(['desktop-file-validate', '$SOURCE'], single_source=True)
test_python_builder = TestBuilder(['pychecker', '--stdlib', '--quiet', '$SOURCE'], single_source=True)
test_xml_builder = TestBuilder(['xmllint', '--valid', '--noout', '$SOURCE'])


def generate(env):
    env.AppendUnique(BUILDERS={
        'TestDesktop': test_desktop_builder,
        'TestPython': test_python_builder,
        'TestXML': test_xml_builder,
        })

def exists(env):
    return True

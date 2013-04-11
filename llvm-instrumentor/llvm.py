from SCons.Script import *
from distutils.version import StrictVersion


def check_llvm_version(context):
    context.Message('Checking for LLVM version...')
    success, output = context.TryAction('llvm-config --version >$TARGET')
    output = output.rstrip()

    # workaround for <http://llvm.org/bugs/show_bug.cgi?id=14715>
    if output == '3.2svn': output = '3.2'

    output = StrictVersion(output.rstrip())
    context.Result(str(output))
    context.env['LLVM_version'] = output


def generate(env):
    if 'LLVM_version' in env:
        return

    conf = Configure(
        env,
        custom_tests={
            'CheckLLVMVersion': check_llvm_version,
            })
    conf.CheckLLVMVersion()
    conf.Finish()


def exists(env):
    return true

from SCons.Script import *


########################################################################
#
#  generate LLVM bitcode from C/C++ source using the Clang front end
#


def __bitcode_builder(stage, suffix):
    cxx_action = '$__CLANG_COMMAND_CXX ' + stage
    cxx_suffixes = ['cc', 'cpp', 'cxx']

    actions = {'c': '$__CLANG_COMMAND_C ' + stage}
    for src_suffix in cxx_suffixes:
        actions[src_suffix] = cxx_action

    return Builder(
        action=actions,
        src_suffix=['c'] + cxx_suffixes,
        suffix=suffix,
        source_scanner=CScanner,
        )


########################################################################


def generate(env):
    if '__CLANG_COMMAND' in env:
        return

    env.AppendUnique(
        __CLANG_COMMAND='$CLANG -emit-llvm -o $TARGET $SOURCES $CCFLAGS $_CCCOMCOM $CLANG_FLAGS',
        __CLANG_COMMAND_C='$__CLANG_COMMAND $CFLAGS',
        __CLANG_COMMAND_CXX='$__CLANG_COMMAND $CXXFLAGS',
        BUILDERS={
            'BitcodeBinary': __bitcode_builder('-c', 'bc'),
            'BitcodeSource': __bitcode_builder('-S', 'll'),
            },
        CLANG='clang',
        )


def exists(env):
    return env.WhereIs('clang')

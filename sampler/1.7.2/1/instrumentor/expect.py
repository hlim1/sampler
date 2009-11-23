from SCons.Script import *

from itertools import chain, ifilter, imap

import filecmp


########################################################################
#
#  comparison with reference output
#


def __compare_action_exec(target, source, env):
    __pychecker__ = 'no-argsused'
    [source] = source
    expected = source.target_from_source('', '.expected')
    return not filecmp.cmp(str(source), str(expected), False)


def __compare_action_show(target, source, env):
    __pychecker__ = 'no-argsused'
    [source] = source
    expected = source.target_from_source('', '.expected')
    return 'compare "%s" and "%s"' % (source, expected)


__compare_action = Action(__compare_action_exec, __compare_action_show)


__expect_action = [__compare_action, Touch('$TARGET')]


def __expect_scan(node, env, path):
    __pychecker__ = 'no-argsused'
    return [node.target_from_source('', '.expected')]


__expect_scanner = Scanner(function=__expect_scan)


__expect_builder = Builder(
    action=__expect_action,
    suffix='.passed',
    target_scanner=__expect_scanner,
    single_source=True,
    )


########################################################################


def generate(env):
    env.AppendUnique(
        BUILDERS={
            'Expect': __expect_builder,
            },
        )


def exists(env):
    return True

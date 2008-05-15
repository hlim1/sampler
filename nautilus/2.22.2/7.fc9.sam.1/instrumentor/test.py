import sys
sys.path[1:1] = ['/usr/lib/scons']

from SCons.Action import Action
from SCons.Builder import Builder
from SCons.Defaults import CScan, Touch
from SCons.Scanner import Scanner
from SCons.Script import Flatten

from itertools import chain, ifilter, imap

import filecmp

from utils import read_pipe


########################################################################
#
#  common utilities
#


__driver_deps = ['#driver/sampler-cc-here', '#driver/as', '#driver/cc1', '#driver/sampler-specs', '#instrumentor/main']


def __sampler_cc_scan(node, env, path):
    __pychecker__ = 'no-argsused'
    # todo: dependencies on headers under '#lib'
    return map(env.File, __driver_deps)


def __sampler_ld_scan(node, env, path):
    __pychecker__ = 'no-argsused'
    tdir = {True: 'yes', False: 'no'}['-pthread' in env['LINKFLAGS']]
    libs = ['early', 'late', 'random-online']
    libs = ( 'threads/%s/lib%s' % (tdir, lib) for lib in libs )
    libs = chain(['schemes/libschemes'], libs)
    libs = ( '#lib/%s.a' % lib for lib in libs )

    deps = chain(__driver_deps, libs)
    return map(env.File, deps)


__sampler_cc_scanner = Scanner(function=__sampler_cc_scan)
__sampler_ld_scanner = Scanner(function=__sampler_ld_scan)


########################################################################
#
#  static objects and programs
#


__static_object_builder = Builder(
    action='$CCCOM',
    prefix='$OBJPREFIX',
    suffix='$OBJSUFFIX',
    src_suffix='$CFILESUFFIX',
    target_scanner=__sampler_cc_scanner,
    )


__program_builder = Builder(
    action='$LINKCOM',
    prefix='$PROGPREFIX',
    suffix='$PROGSUFFIX',
    src_suffix='$OBJSUFFIX',
    src_builder='CBIStaticObject',
    target_scanner=__sampler_ld_scanner,
    )


########################################################################
#
#  shared objects and libraries
#


__shared_object_builder = Builder(
    action='$SHCCCOM',
    prefix='$SHOBJPREFIX',
    suffix='$SHOBJSUFFIX',
    src_suffix='$CFILESUFFIX',
    target_scanner=__sampler_cc_scanner,
    )


__shared_library_builder = Builder(
    action='$SHLINKCOM',
    prefix='$SHLIBPREFIX',
    suffix='$SHLIBSUFFIX',
    src_suffix='$SHOBJSUFFIX',
    src_builder='CBISharedObject',
    target_scanner=__sampler_ld_scanner,
    )


########################################################################
#
#  static information extraction
#


def __extract_scan(node, env, path):
    __pychecker__ = 'no-argsused'
    return [env.File('#$EXTRACT_SECTION')]


__extract_scanner = Scanner(function=__extract_scan)


__sites_action = Action([['$EXTRACT_SECTION', '.debug_site_info', '$SOURCES', '>$TARGET']])


__sites_builder = Builder(
    action=__sites_action,
    suffix='.sites',
    src_suffix='$PROGSUFFIX',
    src_builder='CBIProgram',
    target_scanner=__extract_scanner,
    )


########################################################################
#
#  feedback report creation
#


def __var_test_stdout(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    if env['TEST_STDOUT']:
        return '>$TEST_STDOUT'


def __var_test_stderr(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    if env['TEST_STDERR']:
        return '2>$TEST_STDERR'


__reports_action = Action([['{', '$TEST_PREFIX', 'env', 'SAMPLER_SPARSITY=1', 'SAMPLER_FILE=$TARGET', '$SOURCE', '$TEST_ARGS', ';', '}', '$_TEST_STDOUT', '$_TEST_STDERR']])


__reports_builder = Builder(
    action=__reports_action,
    suffix='.reports',
    src_suffix=[''],
    src_builder='CBIProgram',
    )


########################################################################
#
#  samples resolving
#


__resolved_samples_action = Action([[
    '$RESOLVE_SAMPLES', '$objects', '<$SOURCE', '|',
    'cut', '-f1,3-', '|',
    'sed', 's:$SOURCE.dir/::g', '|',
    'sort', '-t', '\t', '-o', '$TARGET',
    ]])


def __resolved_samples_scan(node, env, path):
    __pychecker__ = 'no-argsused'
    return Flatten([env.subst('#$RESOLVE_SAMPLES'), env['objects']])


__resolved_samples_scanner = Scanner(function=__resolved_samples_scan)


__resolved_samples_builder = Builder(
    action=__resolved_samples_action,
    suffix='.resolved',
    src_suffix='.reports',
    src_builder='CBIReports',
    target_scanner=__resolved_samples_scanner,
    )


########################################################################
#
#  timestamps resolving
#


__resolved_timestamps_action = Action([[
    '$RESOLVE_TIMESTAMPS', '${SOURCE.children()}', '<$SOURCE', '|',
    'cut', '-f1,4-', '|',
    'sed', 's:$SOURCE.dir/::g', '|',
    'sort', '-t', '\t', '-k3', '-o', '$TARGET',
    ]])


def __resolved_timestamps_scan(node, env, path):
    __pychecker__ = 'no-argsused'
    return [env.subst('#$RESOLVE_TIMESTAMPS')]


__resolved_timestamps_scanner = Scanner(function=__resolved_timestamps_scan)


__resolved_timestamps_builder = Builder(
    action=__resolved_timestamps_action,
    suffix='.timestamps',
    src_suffix='.reports',
    src_builder='CBIReports',
    target_scanner=__resolved_timestamps_scanner,
    )


########################################################################
#
#  control flow graph resolving
#


__resolved_cfg_action = Action([[
    '$RESOLVE_CFG', '$SOURCE', '|',
    'sed', 's:$SOURCE.dir/::g', '>$TARGET',
    ]])


def __resolved_cfg_scan(node, env, path):
    __pychecker__ = 'no-argsused'
    return [env.subst('#$RESOLVE_CFG')]


__resolved_cfg_scanner = Scanner(function=__resolved_cfg_scan)


__resolved_cfg_builder = Builder(
    action=__resolved_cfg_action,
    suffix='.cfg',
    src_suffix=['$OBJSUFFIX', '$SHOBJSUFFIX', '$LIBSUFFIX', '$SHLIBSUFFIX', '$PROGSUFFIX'],
    src_builder='CBIStaticObject',
    target_scanner=__resolved_cfg_scanner,
    )


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
    env['CC'] = env.File('#driver/sampler-cc-here')

    env.AppendUnique(
        CCFLAGS=['--relative-paths'],
        EXTRACT_SECTION=env.File('#tools/extract-section'),
        RESOLVE_CFG=env.File('#tools/resolve-cfg'),
        RESOLVE_SAMPLES=env.File('#tools/resolve-samples'),
        RESOLVE_TIMESTAMPS=env.File('#tools/resolve-timestamps'),

        BUILDERS={
        'CBIProgram': __program_builder,
        'CBIReports': __reports_builder,
        'CBIResolvedCFG': __resolved_cfg_builder,
        'CBIResolvedSamples': __resolved_samples_builder,
        'CBIResolvedTimestamps': __resolved_timestamps_builder,
        'CBISharedLibrary': __shared_library_builder,
        'CBISharedObject': __shared_object_builder,
        'CBISites': __sites_builder,
        'CBIStaticObject': __static_object_builder,
        'Expect': __expect_builder,
        },

        TEST_PREFIX=[],
        TEST_STDOUT=[],
        TEST_STDERR=[],
        _TEST_STDOUT='${_concat(">", TEST_STDOUT, "", __env__)}',
        _TEST_STDERR='${_concat("2>", TEST_STDERR, "", __env__)}',
        )


def exists(env):
    return True

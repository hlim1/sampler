import sys
sys.path[1:1] = ['/usr/lib/scons']

from SCons.Action import Action
from SCons.Builder import Builder
from SCons.Scanner import Scanner


########################################################################
#
#  common utilities
#


def __sampler_cc_scan(node, env, path):
    return [
        env['CC'],
        env.File('#instrumentor/main'),
        ]


__sampler_cc_scanner = Scanner(function=__sampler_cc_scan)


########################################################################
#
#  static binaries
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
    target_scanner=__sampler_cc_scanner,
    )


########################################################################
#
#  shared binaries
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
    target_scanner=__sampler_cc_scanner,
    )


########################################################################
#
#  static information extraction
#


def __extract_scan(node, env, path):
    return [env.File('#$EXTRACT_SECTION')]


__extract_scanner = Scanner(function=__extract_scan)


__sites_info_action = Action([['$EXTRACT_SECTION', '.debug_site_info', '$SOURCES', '>$TARGET']])


__sites_info_builder = Builder(
    action=__sites_info_action,
    suffix='.sites',
    src_suffix='$PROGSUFFIX',
    src_builder='CBIProgram',
    target_scanner=__extract_scanner,
    )


__cfg_info_action = Action([['$EXTRACT_SECTION', '.debug_sampler_cfg', '$SOURCES', '>$TARGET']])


__cfg_info_builder = Builder(
    action=__cfg_info_action,
    suffix='.cfg',
    src_suffix='$PROGSUFFIX',
    src_builder='CBIProgram',
    target_scanner=__extract_scanner,
    )


########################################################################
#
#  feedback report creation and checking
#


def __var_test_stdout(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    if env['TEST_STDOUT']:
        return '>$TEST_STDOUT'
    else:
        return []


def __var_test_stderr(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    if env['TEST_STDERR']:
        return '2>$TEST_STDERR'
    else:
        return []


__reports_action = Action([['{', '$TEST_PREFIX', 'env', 'SAMPLER_SPARSITY=1', 'SAMPLER_FILE=$TARGET', '$SOURCE', '$TEST_ARGS', ';', '}', '$_TEST_STDOUT', '$_TEST_STDERR']])


__reports_builder = Builder(
    action=__reports_action,
    suffix='.reports',
    src_suffix=[''],
    src_builder='CBIProgram',
    )


__resolved_action = Action([[
    '$RESOLVE_SAMPLES', '${SOURCE.children()}', '<$SOURCE', '|',
    'cut', '-f1,3-', '|',
    'sed', 's:$SOURCE.dir/::g', '|',
    'sort', '-t', '\t', '-o', '$TARGET',
    ]])


def __resolved_scan(node, env, path):
    return [env.subst('#$RESOLVE_SAMPLES')]


__resolved_scanner = Scanner(function=__resolved_scan)


__resolved_builder = Builder(
    action=__resolved_action,
    suffix='.resolved',
    src_suffix='.reports',
    src_builder='CBIReports',
    target_scanner=__resolved_scanner,
    )


########################################################################
#
#  comparison with reference output
#


__expect_action = [
    ['diff', '-u', '${SOURCE.base}.expected', '$SOURCE'],
    Touch('$TARGET'),
    ]


def __expect_scan(node, env, path):
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
        RESOLVE_SAMPLES=env.File('#tools/resolve-samples'),
        EXTRACT_SECTION=env.File('#tools/extract-section'),

        BUILDERS={
        'CBIStaticObject': __static_object_builder,
        'CBISharedObject': __shared_object_builder,
        'CBIProgram': __program_builder,
        'CBISharedLibrary': __shared_library_builder,
        'CBISitesInfo': __sites_info_builder,
        'CBICFGInfo': __cfg_info_builder,
        'CBIReports': __reports_builder,
        'CBIResolved': __resolved_builder,
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


# todo: tests should also depend on various additional files under '#driver', '#lib', ...

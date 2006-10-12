from os.path import dirname
from itertools import chain, ifilter, imap

import sys
sys.path[1:1] = ['/usr/lib/scons']
from SCons.Action import Action
from SCons.Builder import Builder
from SCons.Node.FS import File
from SCons.Scanner import Scanner

from utils import read_pipe


########################################################################


__source_to_object = {
    False: {'.mli': '.cmi', '.ml': '.cmo'},
    True:  {'.mli': '.cmi', '.ml': '.cmx'}
    }
__object_to_source = { '.cmi': '.mli', '.cmo': '.ml', '.cmx': '.ml' }


def __warn(message):
    print >>sys.stderr, 'scons-ocaml: warning:', message


########################################################################
#
#  ocamldep dependency scanner
#
#  This scanner runs ocamldep on ".ml" or ".mli" files.  It parses
#  ocamldep's output to idenfiy other modules that the scanned file
#  depends upon.
#


def __ocamldep_scan(node, env, path):
    __pychecker__ = 'no-argsused'
    suffix = node.get_suffix()
    if not suffix in __source_to_object[env['OCAML_NATIVE']]:
        __warn('%s does not have a suitable suffix' % node)
        return

    if not node.exists():
        __warn('%s does not exist' % node)

    stdout = read_pipe([['$OCAMLDEP', '$_OCAML_PATH', '$_OCAML_PP', str(node)]], env)
    if stdout == 0:
        return
    elif isinstance(stdout, int):
        env.Exit(stdout)

    target = node.target_from_source('', __source_to_object[env['OCAML_NATIVE']][suffix])
    target = str(target) + ':'

    def joinLines(stream):
        """reassemble long lines that were split using backslashed newlines"""
        accum = ''
        for line in stream:
            if line[-2:] == '\\\n':
                accum += line[0:-2]
            else:
                yield accum + line
                accum = ''

    deps = joinLines(stdout)
    deps = imap(str.split, deps)
    deps = ( fields[1:] for fields in deps if fields[0] == target )
    deps = chain(*deps)
    deps = imap(env.File, deps)
    return deps


__ocamldep_scanner = Scanner(
    function=__ocamldep_scan,
    name='ocamldep_scanner',
    node_class=File,
    skeys=['.mli', '.ml'],
    )


########################################################################


def __obj_emitter(target, source, env):
    if env['OCAML_DTYPES'] or env['OCAML_NATIVE']:
        cmo_suffix = __source_to_object[env['OCAML_NATIVE']]['.ml']
        cmos = ( node for node in target if node.get_suffix() == cmo_suffix )
        for cmo in cmos:
            if env['OCAML_DTYPES']:
                target.append(cmo.target_from_source('', '.annot'))
            if env['OCAML_NATIVE']:
                target.append(cmo.target_from_source('', '.o'))
    return target, source


def __obj_suffix(env, sources):
    [source] = sources
    result = __source_to_object[env['OCAML_NATIVE']][source.get_suffix()]
    return result


__obj_action = Action([['$_OCAMLC', '$_OCAML_DEBUG', '$_OCAML_DTYPES', '$_OCAML_PATH', '$_OCAML_PP', '$_OCAML_WARN', '$_OCAML_WARN_ERROR', '-o', '$TARGET', '-c', '$SOURCE']])


__obj_builder = Builder(
    source_scanner=__ocamldep_scanner,
    emitter=__obj_emitter,
    action=__obj_action,
    suffix=__obj_suffix,
    src_suffix=['.mli', '.ml'],
    single_source=True,
    )


########################################################################
#
#  Library builder
#
#  Building a library is fairly straightforward: run a command on a
#  list of sources to produce the target.  The only subtlety is that
#  native libraries have an extra depepdency: the ".a" file for each
#  ".cmxa" file.  We tell SCons about that using an emitter function.
#


__lib_suffix = { False: '.cma', True: '.cmxa' }


def __lib_emitter(target, source, env):
    if env['OCAML_NATIVE']:
        afiles = ( node.target_from_source('', '.a') for node in target )
        target += afiles
    return target, source


__lib_action = Action([['$_OCAMLC', '-a', '$_OCAML_WARN', '$_OCAML_WARN_ERROR', '-o', '$TARGET', '$SOURCES']])


def __lib_builder(native):
    return Builder(
        emitter=__lib_emitter,
        action=__lib_action,
        src_builder=__obj_builder,
        src_suffix=__source_to_object[native]['.ml'],
        suffix=__lib_suffix[native]
        )


########################################################################


def __exe_depends(node, env):
    obj_suffix = node.get_suffix()
    if not obj_suffix in __object_to_source: return []
    src_suffix = __object_to_source[obj_suffix]
    source = node.target_from_source('', src_suffix)
    cmis = ( cmi for cmi in node.children() if cmi != source )
    cmos = ( cmi.target_from_source('', obj_suffix) for cmi in cmis )
    cmos = ( env.FindFile(str(cmo), '#.') for cmo in cmos )
    cmos = filter(None, cmos)
    if env['OCAML_NATIVE']:
        deps = ( (cmo, cmo.target_from_source('', '.o')) for cmo in cmos )
        return chain(*deps)
    else:
        return cmos


def __exe_scan(node, env, path):
    __pychecker__ = 'no-argsused'
    return __exe_depends(node, env)


__exe_scanner = Scanner(
    function=__exe_scan,
    name='exe_scanner',
    node_class=File,
    recursive=True,
    )


def __find_libs(libs, env, path):
    path = list(path)
    for lib in libs:
        found = env.FindFile(lib, path)
        if found:
            yield found
        else:
            __warn('no %s in search path [%s]' % (lib, ', '.join(path)))


def __exe_target_scan(node, env, path):
    __pychecker__ = 'no-argsused'
    suffix = __lib_suffix[env['OCAML_NATIVE']]
    libs = ( lib + suffix for lib in env['OCAML_LIBS'] )
    libs = __find_libs(libs, env, path)
    return libs


def __exe_path_function(env, directory, target, source):
    __pychecker__ = 'no-argsused'
    stdlib = env['OCAML_STDLIB']
    if stdlib is None:
        ocamlc = env['OCAMLC']
        ocamlc = env.WhereIs(ocamlc)
        prefix = dirname(dirname(ocamlc))
        stdlib = '%s/lib/ocaml' % prefix

    return tuple(env['OCAML_PATH'] + [stdlib])


__exe_target_scanner = Scanner(
    function=__exe_target_scan,
    name='exe_target_scanner',
    path_function=__exe_path_function,
    node_class=File,
    )


__exe_action = Action([['$_OCAMLC', '$_OCAML_PATH', '-o', '$TARGET', '$_OCAML_LIBS', '$_OCAML_LINK_ORDER']])


def __exe_builder(native):
    return Builder(
        target_scanner=__exe_target_scanner,
        source_scanner=__exe_scanner,
        action=__exe_action,
        src_suffix=__source_to_object[native]['.ml'],
        src_builder=__obj_builder,
        )


########################################################################


def __var_ocamlc(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    slots = {False: 'OCAMLC', True: 'OCAMLOPT'}
    slot = slots[env['OCAML_NATIVE']]
    return env[slot]


def __var_ocaml_cma(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    return __lib_suffix[env['OCAML_NATIVE']]


def __var_ocaml_debug(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    if env['OCAML_DEBUG']:
        return '-g'


def __var_ocaml_dtypes(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    if env['OCAML_DTYPES']:
        return ['$(', '-dtypes', '$)']


def __var_ocaml_link_order(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'

    def __link_order_expand(cmo, env, seen):
        order = []
        obj_suffix = cmo.get_suffix()
        if not cmo in seen:
            prereqs = __exe_depends(cmo, env)
            prereqs = ( pre.target_from_source('', obj_suffix) for pre in prereqs )
            prereqs = ( pre for pre in prereqs if pre != cmo )
            prereqs = ( __link_order_expand(pre, env, seen) for pre in prereqs )
            prereqs = chain(*prereqs)
            order += prereqs
            order.append(cmo)
            seen.add(cmo)
        return order

    [source] = source
    return __link_order_expand(source, env, set([]))


def __var_ocaml_pp(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    if env['OCAML_PP']:
        return ['-pp', env['OCAML_PP']]


def __var_ocaml_warn(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    if env['OCAML_WARN']:
        return ['$(', '-w', env['OCAML_WARN'], '$)']


def __var_ocaml_warn_error(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    if env['OCAML_WARN_ERROR']:
        return ['$(', '-warn-error', env['OCAML_WARN_ERROR'], '$)']


def generate(env):
    env.AppendUnique(
        OCAMLC=env.Detect(['ocamlc.opt', 'ocamlc']),
        OCAMLDEP=env.Detect(['ocamldep.opt', 'ocamldep']),
        OCAMLOPT=env.Detect(['ocamlopt.opt', 'ocamlopt']),
        OCAML_DEBUG=False,
        OCAML_DTYPES=False,
        OCAML_LIBS=[],
        OCAML_NATIVE=False,
        OCAML_PATH=[],
        OCAML_PP='',
        OCAML_STDLIB=None,
        OCAML_WARN='',
        OCAML_WARN_ERROR='',
        _OCAMLC=__var_ocamlc,
        _OCAML_CMA=__var_ocaml_cma,
        _OCAML_DEBUG=__var_ocaml_debug,
        _OCAML_DTYPES=__var_ocaml_dtypes,
        _OCAML_LIBS='${_concat("", OCAML_LIBS, _OCAML_CMA, __env__)}',
        _OCAML_LINK_ORDER=__var_ocaml_link_order,
        _OCAML_PATH='${_concat("-I ", OCAML_PATH, "", __env__)}',
        _OCAML_PP=__var_ocaml_pp,
        _OCAML_WARN=__var_ocaml_warn,
        _OCAML_WARN_ERROR=__var_ocaml_warn_error,

        SCANNERS=[__ocamldep_scanner],

        BUILDERS={
        'OcamlObject': __obj_builder,
        'OcamlLibrary': __lib_builder(env['OCAML_NATIVE']),
        'OcamlProgram': __exe_builder(env['OCAML_NATIVE']),
        },
        )


def exists(env):
    return env.Detect(['ocamlc', 'ocamlc.opt', 'ocamlopt', 'ocamlopt.opt'])

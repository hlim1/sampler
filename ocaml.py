from os.path import dirname
from itertools import chain, ifilter, imap

import sys
sys.path[1:1] = ['/usr/lib/scons']
from SCons.Action import Action
from SCons.Builder import Builder
from SCons.Node.FS import File
from SCons.Scanner import Scanner

from utils import read_pipe


#__pychecker__ = 'no-argsused'


########################################################################


source_to_object = { False: {'.mli': '.cmi', '.ml': '.cmo'},
                     True:  {'.mli': '.cmi', '.ml': '.cmx'} }
object_to_source = { '.cmi': '.mli', '.cmo': '.ml', '.cmx': '.ml' }


def strs(items):
    return map(str, items)


def warn(message):
    print >>sys.stderr, 'scons-ocaml: warning:', message


def ocaml_path_function(env, node):
    __pychecker__ = 'no-argsused'
    stdlib = env['OCAML_STDLIB']
    if stdlib is None:
        ocamlc = env['OCAMLC']
        ocamlc = env.WhereIs(ocamlc)
        prefix = dirname(dirname(ocamlc))
        stdlib = '%s/lib/ocaml' % prefix

    return tuple(env['OCAML_PATH'] + [stdlib])


########################################################################


def obj_emitter(target, source, env):
    suffix = { False: '.cmo', True: '.cmx' }[env['OCAML_NATIVE']]
    cmos = [ node for node in target if node.get_suffix() == suffix ]
    if env['OCAML_DTYPES']:
        annots = ( node.target_from_source('', '.annot') for node in cmos )
        target += annots
    if env['OCAML_NATIVE']:
        ofiles = ( node.target_from_source('', '.o') for node in cmos )
        target += ofiles
    return target, source


def ocamldep(node, env, path):
    __pychecker__ = 'no-argsused'
    suffix = node.get_suffix()
    if not suffix in source_to_object[env['OCAML_NATIVE']]:
        warn('%s does not have a suitable suffix' % node)
        return

    if not node.exists():
        warn('%s does not exist' % node)

    stdout = read_pipe([['$OCAMLDEP', '$_OCAML_PATH', '$_OCAML_PP', str(node)]], env)
    if stdout == 0:
        return
    elif isinstance(stdout, int):
        env.Exit(stdout)

    target = node.target_from_source('', source_to_object[env['OCAML_NATIVE']][suffix])
    target = str(target) + ':'

    def joinLines(stream):
        accum = ''
        for line in stream:
            if line[-2] == '\\':
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


ocamldep_scanner = Scanner(function=ocamldep, name='ocamldep',
                           path_function=ocaml_path_function,
                           skeys=['.mli', '.ml'],
                           node_class=File)


def obj_suffix(env, sources):
    [source] = sources
    result = source_to_object[env['OCAML_NATIVE']][source.get_suffix()]
    return result


obj_action = Action([['$_OCAMLC', '$_OCAML_DEBUG', '$_OCAML_DTYPES', '$_OCAML_PATH', '$_OCAML_PP', '$_OCAML_WARN', '$_OCAML_WARN_ERROR', '-o', '$TARGET', '-c', '$SOURCE']])

obj_builder = Builder(source_scanner=ocamldep_scanner,
                      emitter=obj_emitter,
                      action=obj_action,
                      suffix=obj_suffix,
                      src_suffix=['.mli', '.ml'],
                      single_source=True,
                      )


########################################################################


def lib_emitter(target, source, env):
    #suffix = { False: '.cmo', True: '.cmx' }[env['OCAML_NATIVE']]
    #source = [ node for node in source if node.get_suffix() == suffix ]
    if env['OCAML_NATIVE']:
        afiles = ( node.target_from_source('', '.a') for node in target )
        target += afiles
    return target, source


lib_action = Action([['$_OCAMLC', '-a', '$_OCAML_WARN', '$_OCAML_WARN_ERROR', '-o', '$TARGET', '$SOURCES']])

lib_builder_bytecode = Builder(emitter=lib_emitter,
                               action=lib_action,
                               suffix='.cma',
                               src_suffix='.cmo',
                               src_builder=obj_builder,
                               )

lib_builder_native = Builder(emitter=lib_emitter,
                             action=lib_action,
                             suffix='.cmxa',
                             src_suffix='.cmx',
                             src_builder=obj_builder,
                             )

lib_builder = { False: lib_builder_bytecode,
                True:  lib_builder_native }


########################################################################


def link_depends(node, env):
    if node.get_suffix() == '.o': return []
    obj_suffix = node.get_suffix()
    src_suffix = object_to_source[obj_suffix]
    source = node.target_from_source('', src_suffix)
    cmis = ( cmi for cmi in node.children() if cmi != source )
    cmos = ( cmi.target_from_source('', obj_suffix) for cmi in cmis )
    cmos = ( env.FindFile(cmo, '#.') for cmo in cmos )
    cmos = filter(None, cmos)
    if env['OCAML_NATIVE']:
        cmos = list(cmos)
        objs = [ cmo.target_from_source('', '.o') for cmo in cmos ]
        return cmos + objs
    else:
        return cmos

def link_scanner(node, env, path):
    __pychecker__ = 'no-argsused'
    return list(link_depends(node, env))

exe_scanner = Scanner(function=link_scanner, name='exe_scanner',
                      path_function=ocaml_path_function,
                      node_class=File, recursive=True)


def __find_libs(libs, env, path):
    path = list(path)
    for lib in libs:
        found = env.FindFile(lib, path)
        if found:
            yield found
        else:
            warn('no %s in search path [%s]' % (lib, ', '.join(path)))


def __exe_target_scanner(node, env, path):
    __pychecker__ = 'no-argsused'
    suffix = { False: '.cma', True: '.cmxa' }[env['OCAML_NATIVE']]
    libs = ( lib + suffix for lib in env['OCAML_LIBS'] )
    libs = __find_libs(libs, env, path)
    libs = list(libs)
    return libs

exe_target_scanner = Scanner(function=__exe_target_scanner,
                             name='exe_target_scanner',
                             path_function=ocaml_path_function,
                             node_class=File)


def link_order_expand(cmo, env, seen):
    order = []
    obj_suffix = cmo.get_suffix()
    if not cmo in seen:
        prereqs = link_depends(cmo, env)
        prereqs = ( pre.target_from_source('', obj_suffix) for pre in prereqs )
        prereqs = ( pre for pre in prereqs if pre != cmo )
        prereqs = ( link_order_expand(pre, env, seen) for pre in prereqs )
        prereqs = chain(*prereqs)
        order += prereqs
        order.append(cmo)
        seen.add(cmo)
    return order

def __var_ocaml_link_order(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    order = link_order_expand(source[0], env, set([]))
    assert len(order) == len(set(order)), 'for target %s: duplicates in link order: %s' % (target[0], strs(order))
    return order


exe_action = Action([['$_OCAMLC', '$_OCAML_PATH', '-o', '$TARGET', '$_OCAML_LIBS', '$_OCAML_LINK_ORDER']])


exe_builder_bytecode = Builder(target_scanner=exe_target_scanner,
                               source_scanner=exe_scanner,
                               action=exe_action,
                               src_suffix='.cmo',
                               src_builder=obj_builder,
                               )

exe_builder_native = Builder(target_scanner=exe_target_scanner,
                             source_scanner=exe_scanner,
                             action=exe_action,
                             src_suffix='.cmx',
                             src_builder=obj_builder,
                             )

exe_builder = { False: exe_builder_bytecode,
                True:  exe_builder_native }


########################################################################


def __var_ocamlc(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    if env['OCAML_NATIVE']:
        return env['OCAMLOPT']
    else:
        return env['OCAMLC']

def __var_ocaml_cma(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    return { False: '.cma', True: '.cmxa' }[env['OCAML_NATIVE']]

def __var_ocaml_debug(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    if env['OCAML_DEBUG']:
        return '-g'

def __var_ocaml_dtypes(target, source, env, for_signature):
    __pychecker__ = 'no-argsused'
    if env['OCAML_DTYPES']:
        return ['$(', '-dtypes', '$)']

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

        SCANNERS=[ocamldep_scanner],

        BUILDERS={
        'OcamlObject': obj_builder,
        'OcamlLibrary': lib_builder[env['OCAML_NATIVE']],
        'OcamlProgram': exe_builder[env['OCAML_NATIVE']],
        },
        )


def exists(env):
    return env.Detect(['ocamlc.opt', 'ocamlc'])

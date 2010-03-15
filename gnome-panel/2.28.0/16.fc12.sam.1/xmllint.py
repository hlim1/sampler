from SCons.Builder import Builder
from SCons.Defaults import Touch
from SCons.Scanner import Scanner

import re

from itertools import ifilter, imap
from os.path import isabs
from subprocess import PIPE, Popen
from urlparse import urlsplit


########################################################################


loaded = re.compile('^Loaded URL="(.*)" ID=".*"$')


def loaded_files(loads):
    for load in loads:
        url = urlsplit(load)
        if url[0] == '':
            if isabs(url[2]):
                yield url[2]
            else:
                yield '#' + url[2]
        elif url[0] == 'file':
            yield url[2]


def load_trace(command, env):
    command = map(str, command)
    if not env.GetOption('silent'):
        print ' '.join(command)

    process = Popen(command, stderr=PIPE, env=env['ENV'])
    matches = imap(loaded.match, process.stderr)
    loads = ( match.group(1) for match in matches if match )
    files = loaded_files(loads)

    dependencies = list(files)
    process.wait()

    try:
        catalogs = env['ENV']['XML_CATALOG_FILES']
        catalogs = env.Split(catalogs)
        dependencies += catalogs
    except KeyError:
        pass

    return dependencies


########################################################################


def xmllint(args):
    return ['xmllint', '$XMLLINT_FLAGS', '--noout', '$_xmllint_validate'] + args + ['$SOURCE']


xmllint_action = [xmllint([]), Touch('$TARGET')]


def var_xmllint_validate(target, source, env, for_signature):
    result = []

    if env['xinclude']:
        result.append('--noxincludenode')

    if env['schema']:
        result += ['--schema', '$schema']
    elif env['xinclude']:
        result.append('--postvalid')
    else:
        result.append('--valid')

    return result


def xmllint_scan(node, env, path):
    command = xmllint(['--load-trace'])
    [command] = env.subst_list(command, source=node)
    return load_trace(command, env)


def xmllint_scan_check(node, env):
    return node.exists() and node.get_suffix() in ['.xml', '.html']


xmllint_scanner = Scanner(
    xmllint_scan,
    skeys=['xml', 'html'],
    scan_check=xmllint_scan_check,
    )


def xmllint_suffix(env, sources):
    return sources[0].suffix + '.passed'


xmllint_builder = Builder(
    action=xmllint_action,
    suffix=xmllint_suffix,
    src_suffix=['html', 'xml'],
    source_scanner=xmllint_scanner,
    single_source=True,
    )


########################################################################


def generate(env):
    env.AppendUnique(
        BUILDERS={
        'TestXML': xmllint_builder,
        },
        _xmllint_validate = var_xmllint_validate,
        )
    env.SetDefault(
        xinclude = False,
        schema = None,
        XMLLINT_FLAGS = [],
        )

    catalogs = ['/etc/xml/catalog', env.File('#catalog.xml').abspath]
    env.AppendENVPath('XML_CATALOG_FILES', catalogs, sep=' ')

def exists(env):
    return env.Detect('xmllint')

#!/usr/bin/python

import collections
import cPickle as pickle
import inspect
import os
import re

import config


########################################################################
#
#  derived from <https://github.com/travitch/whole-program-llvm.git>
#

# This class applies filters to GCC argument lists.  It has a few
# default arguments that it records, but does not modify the argument
# list at all.  It can be subclassed to change this behavior.
#
# The idea is that all flags accepting a parameter must be specified
# so that they know to consume an extra token from the input stream.
# Flags and arguments can be recorded in any way desired by providing
# a callback.  Each callback/flag has an arity specified - zero arity
# flags (such as -v) are provided to their callback as-is.  Higher
# arities remove the appropriate number of arguments from the list and
# pass them to the callback with the flag.
#
# Most flags can be handled with a simple lookup in a table - these
# are exact matches.  Other flags are more complex and can be
# recognized by regular expressions.  All regular expressions must be
# tried, obviously.  The first one that matches is taken, and no order
# is specified.  Try to avoid overlapping patterns.

class ArgumentListFilter(object):

    def __init__(self, inputList, exactMatches={}, patternMatches={}):
        defaultArgExactMatches = {
            '-o': ArgumentListFilter.defaultOneArgument,
            '--param': ArgumentListFilter.defaultOneArgument,
            '-aux-info': ArgumentListFilter.defaultOneArgument,
            # Preprocessor assertion
            '-A': ArgumentListFilter.defaultOneArgument,
            '-D': ArgumentListFilter.defaultOneArgument,
            '-U': ArgumentListFilter.defaultOneArgument,
            # Dependency generation
            '-MT': ArgumentListFilter.defaultOneArgument,
            '-MQ': ArgumentListFilter.defaultOneArgument,
            '-MF': ArgumentListFilter.defaultOneArgument,
            '-MD': ArgumentListFilter.defaultOneArgument,
            '-MMD': ArgumentListFilter.defaultOneArgument,
            # Include
            '-I': ArgumentListFilter.defaultOneArgument,
            '-idirafter': ArgumentListFilter.defaultOneArgument,
            '-include': ArgumentListFilter.defaultOneArgument,
            '-imacros': ArgumentListFilter.defaultOneArgument,
            '-iprefix': ArgumentListFilter.defaultOneArgument,
            '-iwithprefix': ArgumentListFilter.defaultOneArgument,
            '-iwithprefixbefore': ArgumentListFilter.defaultOneArgument,
            '-isystem': ArgumentListFilter.defaultOneArgument,
            '-isysroot': ArgumentListFilter.defaultOneArgument,
            '-iquote': ArgumentListFilter.defaultOneArgument,
            '-imultilib': ArgumentListFilter.defaultOneArgument,
            # Language
            '-x': ArgumentListFilter.defaultOneArgument,
            # Component-specifiers
            '-Xpreprocessor': ArgumentListFilter.defaultOneArgument,
            '-Xassembler': ArgumentListFilter.defaultOneArgument,
            '-Xlinker': ArgumentListFilter.defaultOneArgument,
            # Linker
            '-l': ArgumentListFilter.defaultOneArgument,
            '-L': ArgumentListFilter.defaultOneArgument,
            '-T': ArgumentListFilter.defaultOneArgument,
            '-u': ArgumentListFilter.defaultOneArgument,
            }

        # The default pattern only recognizes input filenames.  Flags can also
        # be recognized here.
        defaultArgPatterns = {
            r'.*\.(c|cc|cpp|C|cxx|i|s)$$': ArgumentListFilter.keepArgument,
            }

        self.filteredArgs = []

        argExactMatches = dict(defaultArgExactMatches)
        argExactMatches.update(exactMatches)
        argPatterns = dict(defaultArgPatterns)
        argPatterns.update(patternMatches)

        inputArgs = collections.deque(inputList)
        while inputArgs:
            # Get the next argument
            currentItem = inputArgs.popleft()
            handler = self._pickHandler(currentItem, argExactMatches, argPatterns)
            arity = len(inspect.getargspec(handler).args) - 2
            flagArgs = []
            while arity > 0:
                flagArgs.append(inputArgs.popleft())
                arity -= 1
            handler(self, currentItem, *flagArgs)

    def _pickHandler(self, currentItem, exact, patterns):
        # First, see if this exact flag has a handler in the table.
        # This is a cheap test.
        handler = exact.get(currentItem)
        if handler:
            return handler

        # Otherwise, see if the input matches some pattern with a
        # handler that we recognize.
        for pattern, handler in patterns.iteritems():
            if re.match(pattern, currentItem):
                return handler

        # If no action has been specified, this is a zero-argument
        # flag that we should just keep.
        return ArgumentListFilter.keepArgument

    def keepArgument(self, arg):
        self.filteredArgs.append(arg)

    def defaultOneArgument(self, flag, arg):
        self.keepArgument(flag)
        self.keepArgument(arg)


########################################################################


FLAG_PREFIX = '-f'
TOGGLE_FLAG_PREFIX_ON = FLAG_PREFIX
TOGGLE_FLAG_PREFIX_OFF = TOGGLE_FLAG_PREFIX_ON + 'no-'


class SamplerArgumentListFilter(ArgumentListFilter):

    def __init__(self, arglist):
        self.cludes = []
        self.dataflow = False
        self.gcc = config.gcc
        self.implications = False
        self.pthread = False
        self.random = 'online'
        self.resetAtPoints = None
        self.scales = None
        self.schemes = set()
        self.toggles = {
            'sample': True,
            }
        self.verbose = False

        patternMatches = {
            '^-f((?:in|ex)clude-(?:file|function|location))=(.*)$': SamplerArgumentListFilter._cludeCallback,
            '^-fsampler-random=.': SamplerArgumentListFilter._randomCallback,
            '^-fsampler-reset-at-points=.': SamplerArgumentListFilter._resetAtPointsCallback,
            '^-fsampler-scales=.': SamplerArgumentListFilter._scalesCallback,
            '^-fsampler-scheme=.': SamplerArgumentListFilter._schemeCallback,
            }

        exactMatches = {
            '-mt': SamplerArgumentListFilter._pthreadCallback,
            '-pthread': SamplerArgumentListFilter._pthreadCallback,
            '-pthreads': SamplerArgumentListFilter._pthreadCallback,
            '-fsampler-dataflow': SamplerArgumentListFilter._dataflowCallback,
            '-fsampler-implications': SamplerArgumentListFilter._implicationsCallback,
            '-v': SamplerArgumentListFilter._verboseCallback,
            '--verbose': SamplerArgumentListFilter._verboseCallback,
            }

        toggles = (
            'add-blast-markers',
            'assign-across-pointer',
            'assign-into-field',
            'assign-into-index',
            'assume-weighty-externs',
            'assume-weighty-interns',
            'assume-weighty-libraries',
            'balance-paths',
            'cache-countdown',
            'compare-constants',
            'compare-uninitialized',
            'isolate-shared-accesses',
            'predict-checks',
            'relative-paths',
            'rename-locals',
            'sample',
            'save-dataflow-fields',
            'show-stats',
            'specialize-empty-regions',
            'specialize-singleton-regions',
            'threads',
            'timestamp-first',
            'timestamp-last',
            'use-points-to',
            )

        for toggle in toggles:
            exactMatches[TOGGLE_FLAG_PREFIX_ON + toggle] = SamplerArgumentListFilter._toggleOnCallback
            exactMatches[TOGGLE_FLAG_PREFIX_OFF + toggle] = SamplerArgumentListFilter._toggleOffCallback

        ArgumentListFilter.__init__(self, arglist, exactMatches=exactMatches, patternMatches=patternMatches)

        self.toggles.setdefault('threads', self.pthread)
        if self.schemes & set(('atoms', 'atoms-rw', 'compare-swap')):
            self.toggles['isolate-shared-accesses'] = True

    def _cludeCallback(self, flag):
        aspect, argument = flag.split('=', 1)
        assert aspect.startswith(FLAG_PREFIX)
        aspect = aspect[len(FLAG_PREFIX):]
        self.cludes.append((aspect, argument))

    def _pthreadCallback(self, flag):
        __pychecker__ = 'unusednames=flag'
        self.pthread = True

    def _randomCallback(self, flag):
        self.random = flag.split('=', 1)[1]

    def _dataflowCallback(self, flag):
        __pychecker__ = 'unusednames=flag'
        self.dataflow = True

    def _implicationsCallback(self, flag):
        __pychecker__ = 'unusednames=flag'
        self.implications = True

    def _resetAtPointsCallback(self, flag):
        self.resetAtPoints = flag.split('=', 1)[1]

    def _scalesCallback(self, flag):
        self.scales = flag.split('=', 1)[1]

    def _schemeCallback(self, flag):
        scheme = flag.split('=', 1)[1]
        self.schemes.add(scheme)

    def _toggle(self, flag, prefix, value):
        assert flag.startswith(prefix)
        key = flag[len(prefix):]
        self.toggles[key] = value

    def _toggleOnCallback(self, flag):
        self._toggle(flag, TOGGLE_FLAG_PREFIX_ON, True)

    def _toggleOffCallback(self, flag):
        self._toggle(flag, TOGGLE_FLAG_PREFIX_OFF, False)

    def _verboseCallback(self, flag):
        self.verbose = True
        self.keepArgument(flag)


########################################################################


import subprocess
import sys

DRIVER_DIR = os.path.abspath(os.path.dirname(__file__))

def sysheader(relpath):
    path = os.path.join(DRIVER_DIR, 'sampler', relpath)
    assert os.path.isfile(path)
    return path

def extraArgs(argFilter, samplerLibDir):

    toggles = argFilter.toggles

    if toggles.get('add-blast-markers'):
        yield '-include'
        yield sysheader('blast-markers.h')

    if config.cpp_tuple_counter_bits_default:
        yield config.cpp_tuple_counter_bits_default

    if toggles['threads']:
        yield '-DCBI_THREADS'

    timestamp = toggles.get('timestamp-first') or toggles.get('timestamp-last')
    if timestamp:
        if toggles.get('timestamp-first'):
            yield '-DCBI_TIMESTAMP_FIRST'

        if toggles.get('timestamp-last'):
            yield '-DCBI_TIMESTAMP_LAST'

        yield '-include'
        yield sysheader('timestamps.h')

    if toggles['sample']:
        yield '-include'
        yield sysheader('threads/countdown.h')

    yield '-include'
    yield sysheader('threads/random-{0}.h'.format(argFilter.random))

    for scheme in argFilter.schemes:
        yield '-include'
        yield sysheader('schemes/{0}-unit.h'.format(scheme))

    if argFilter.schemes:
        yield '-include'
        yield sysheader('unit.h')

    if samplerLibDir:
        yield '-L' + samplerLibDir
        yield '-Wl,-rpath,' + samplerLibDir

    for scheme in argFilter.schemes:
        yield '-lsampler-' + scheme

    if timestamp:
        yield '-lsampler-schemes'

    reentrant = '_r' if toggles['threads'] else ''

    if not toggles['sample']:
        yield '-lsampler-always'
    else:
        yield '-lsampler-' + argFilter.random + reentrant

    yield '-lsampler' + reentrant

    if toggles['threads']:
        yield '-lpthread'


def main(samplerLibDir=None):
    # parse GCC command line
    argFilter = SamplerArgumentListFilter(sys.argv[1:])

    # pass parsed configuration down to custom "cc1" and "as"
    os.environ['SAMPLER_CC_PARSED_CONFIG'] = pickle.dumps(argFilter)

    # some configuration aspects can simply use the GCC command line
    argFilter.filteredArgs += extraArgs(argFilter, samplerLibDir)

    # interject our own search prefix and specs file
    specs = 'sampler-specs'
    assert os.path.exists(os.path.join(DRIVER_DIR, specs))
    gcc = [config.gcc, '-B', DRIVER_DIR, '-specs=' + specs] + argFilter.filteredArgs
    if argFilter.verbose:
        print >>sys.stderr, ' '.join(gcc)

    # run the real GCC driver
    result = subprocess.call(gcc)
    sys.exit(result)

# -*- coding: utf-8 -*-

"""gcc-emulating front end for LLVM-based CBI instrumenting compilation"""

import re

from collections import deque
from inspect import getargspec
from os.path import basename, dirname, join, splitext
from sys import argv
from tempfile import NamedTemporaryFile


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
# a callback.  Each callback implicitly determines the arity of flags
# it handles - zero arity flags (such as -v) are provided to their
# callback as-is.  Higher arities remove the appropriate number of
# arguments from the list and pass them to the callback with the flag.
#
# Most flags can be handled with a simple lookup in a table - these
# are exact matches.  Other flags are more complex and can be
# recognized by regular expressions.  All regular expressions must be
# tried, obviously.  The first one that matches is taken, and no order
# is specified.  Try to avoid overlapping patterns.

class ArgumentListFilter(object):
    """generic filter for gcc command-line arguments"""

    __slots__ = 'filteredArgs',

    def __init__(self, inputList, exactMatches=dict(), patternMatches=dict()):

        argExactMatches = dict([ (flag, ArgumentListFilter.defaultOneArgument) for flag in (
                '-o',
                '--param',
                '-aux-info',
                # Preprocessor assertion
                '-A',
                '-D',
                '-U',
                # Dependency generation
                '-MT',
                '-MQ',
                '-MF',
                '-MD',
                '-MMD',
                # Include
                '-I',
                '-idirafter',
                '-include',
                '-imacros',
                '-iprefix',
                '-iwithprefix',
                '-iwithprefixbefore',
                '-isystem',
                '-isysroot',
                '-iquote',
                '-imultilib',
                # Language
                '-x',
                # Component-specifiers
                '-Xpreprocessor',
                '-Xassembler',
                '-Xlinker',
                # Linker
                '-l',
                '-L',
                '-T',
                '-u',
                )])

        argPatterns = {}

        argExactMatches.update(exactMatches)
        argPatterns.update(patternMatches)

        self.filteredArgs = []

        inputArgs = deque(inputList)
        while inputArgs:
            # Get the next argument
            currentItem = inputArgs.popleft()
            handler, args = self.__pickHandler(currentItem, argExactMatches, argPatterns)
            arity = len(getargspec(handler)[0])
            while len(args) < arity:
                args.append(inputArgs.popleft())
            # pylint: disable=W0142
            handler(*args)

    def __pickHandler(self, currentItem, exact, patterns):
        """find the handler and partial argument list for a given command-line argument"""

        # First, see if this exact flag has a handler in the table.
        # This is a cheap test.
        handler = exact.get(currentItem)
        if handler:
            return handler, [self, currentItem]

        # Otherwise, see if the input matches some pattern with a
        # handler that we recognize.
        for pattern, handler in patterns.iteritems():
            match = re.match(pattern, currentItem)
            if match:
                return handler, [self] + list(match.groups())

        # If no action has been specified, this is a zero-argument
        # flag that we should just keep.
        return ArgumentListFilter.keepArgument, [self, currentItem]

    def keepArgument(self, arg):
        """retain an argument for no additional processing"""
        self.filteredArgs.append(arg)

    def defaultOneArgument(self, flag, arg):
        """retain a flag plus a single following argument"""
        self.keepArgument(flag)
        self.keepArgument(arg)


########################################################################


from atexit import register
from errno import ENOENT
from os import remove
from subprocess import CalledProcessError, check_call
from sys import stderr


class SamplerArgumentListFilter(ArgumentListFilter):
    """specialized filter for sampler-cc command-line arguments"""

    __slots__ = '__infiles', '__outfile', '__schemes', '__target', '__temporaryFile', '__toggles', '__verbose'

    def __init__(self, arglist):
        self.__infiles = []
        self.__outfile = None
        self.__schemes = set()
        self.__target = 'linked'
        self.__temporaryFile = self.__namedTemporaryFile
        self.__toggles = {
            'sample': True,
            }
        self.__verbose = False

        patternMatches = {
            '^-fsampler-scheme=(.+)$': SamplerArgumentListFilter.__schemeCallback,
            '^(-o)=?(.+)$': SamplerArgumentListFilter.__outfileCallback,
            '^([^-].*)$': SamplerArgumentListFilter.__infileCallback,
            }

        exactMatches = {
            '--verbose': SamplerArgumentListFilter.__verboseCallback,
            '-E': SamplerArgumentListFilter.__targetPreprocessedCallback,
            '-c': SamplerArgumentListFilter.__targetObjectCallback,
            '-v': SamplerArgumentListFilter.__verboseCallback,
            '-save-temps': SamplerArgumentListFilter.__saveTempsCallback,
            '-o': SamplerArgumentListFilter.__outfileCallback,
            }

        toggles = (
            'predict-checks',
            'sample',
            )

        for toggle in toggles:
            exactMatches['-' + toggle] = SamplerArgumentListFilter.__toggleOnCallback
            exactMatches['-no-' + toggle] = SamplerArgumentListFilter.__toggleOffCallback

        ArgumentListFilter.__init__(self, arglist, exactMatches=exactMatches, patternMatches=patternMatches)

        finisher = {
            'preprocessed': self.__preprocess,
            'compiled': self.__compile,
            'linked': self.__link,
            }[self.__target]
        finisher()

    ####################################################################
    #
    #  command line parsing callbacks
    #

    def __infileCallback(self, arg):
        """record an input file name, possibly one of several"""
        self.__infiles.append(arg)

    def __outfileCallback(self, flag, arg):
        """record an explicit output file name"""
        # pylint: disable=W0613
        __pychecker__ = 'unusednames=flag'
        self.__outfile = arg

    def __saveTempsCallback(self, flag):
        """retain all intermediate "temporary" files"""
        self.__temporaryFile = self.__derivedFile
        self.keepArgument(flag)

    def __schemeCallback(self, scheme):
        """add a CBI instrumentation scheme, possibly one of several"""
        self.__schemes.add(scheme)

    def __targetObjectCallback(self, flag):
        """set final target to compile only, without linking"""
        self.__target = 'compiled'
        self.keepArgument(flag)

    def __targetPreprocessedCallback(self, flag):
        """set final target to preprocess only, without compiling"""
        self.__target = 'preprocessed'
        self.keepArgument(flag)

    def __toggle(self, flag, prefix):
        """turn a Boolean toggle either on or off"""
        assert flag.startswith(prefix)
        key = flag[len(prefix):]
        value = prefix == '-'
        self.__toggles[key] = value

    def __toggleOnCallback(self, flag):
        """turn on a Boolean toggle"""
        self.__toggle(flag, '-')

    def __toggleOffCallback(self, flag):
        """turn off a Boolean toggle"""
        self.__toggle(flag, '-no-')

    def __verboseCallback(self, flag):
        """verbosely trace all executed subcommands"""
        self.__verbose = True
        self.keepArgument(flag)

    ####################################################################
    #
    #  generic compilation stage helpers
    #

    def __compileTo(self, infile, outfile):
        """compile a single input file to a single output object file"""
        uninst = self.__temporaryFile(infile, '.uninst.bc')
        command = ['clang', '-Qunused-arguments', '-emit-llvm', '-c', '-o', uninst, infile]
        command += self.filteredArgs
        self.__run(command)

        runtime = self.__temporaryFile(infile, '.runtime.bc')
        extra = join(dirname(__file__), 'runtime.bc')
        self.__run(['llvm-link', '-o', runtime, uninst, extra])

        inst = self.__temporaryFile(infile, '.inst.bc')
        phases = ['-' + phase for phase in self.__extraPhases()]
        self.__run(['opt', '-o', inst, runtime] + phases)

        command = ['clang', '-Qunused-arguments', '-c', '-o', outfile, inst]
        command += self.filteredArgs
        self.__run(command)

    @staticmethod
    def __derivedFile(basis, extension):
        """create a (non-temporary) file based on some other file name, but with a new extension"""
        return splitext(basename(basis))[0] + extension

    @staticmethod
    def __namedTemporaryFile(basis, extension):
        """create a temporary file with a given extension"""
        # pylint: disable=W0613
        __pychecker__ = 'unusednames=basis'
        handle = NamedTemporaryFile(prefix='cbi-', suffix=extension, mode='wb', delete=False)
        handle.close()
        register(SamplerArgumentListFilter.__tryRemove, handle.name)
        return handle.name

    def __extraPhases(self):
        """extra LLVM phases to be applied to each object file, in order"""
        # pylint: disable=C0321

        schemes = self.__schemes
        if not schemes: return

        if 'branches' in schemes: yield 'branches'
        if 'returns' in schemes: yield 'returns'

        toggles = self.__toggles

        if toggles.get('sample'):
            yield 'reg2mem'
            yield 'sampler'
            #yield 'mem2reg'

        if toggles.get('predict-checks'):
            yield 'predict-checks'

    def __run(self, command):
        """run some subcommand, possibly with verbose tracing"""
        if self.__verbose:
            print >> stderr, '⌘', ' '.join(command)
        check_call(command)

    @staticmethod
    def __tryRemove(chaff):
        """Remove a file that may already be gone."""
        try:
            remove(chaff)
        except OSError, error:
            if error.errno != ENOENT:
                raise error

    ####################################################################
    #
    #  preprocessing
    #

    def __preprocess(self):
        """build final target by preprocessing only, without compiling"""
        command = ['clang']
        if self.__outfile:
            command += ['-o', self.__outfile]
        command += self.filteredArgs
        command += self.__infiles
        self.__run(command)

    ####################################################################
    #
    #  compilation
    #

    def __compile(self):
        """build final target by compiling only, without linking"""
        if self.__outfile and len(self.__infiles) > 1:
            print >> stderr, '%s: error: cannot specify -o when generating multiple output files' % argv[0]
            exit(1)

        for infile in self.__infiles:
            outfile = self.__outfile or self.__derivedFile(infile, '.o')
            self.__compileTo(infile, outfile)

    ####################################################################
    #
    #  linking
    #

    def __link(self):
        """build final target by linking an executable"""
        # pylint: disable=W0141
        objects = map(self.__prelink, self.__infiles)
        command = ['clang']
        if self.__outfile:
            command += ['-o', self.__outfile]
        command += self.filteredArgs
        command += objects
        self.__run(command)

    def __prelink(self, infile):
        """compile to a temporary object file in preparation for linking"""
        outfile = self.__temporaryFile(infile, '.o')
        self.__compileTo(infile, outfile)
        return outfile


########################################################################


def main():
    """imitate gcc using command-line arguments passed to script"""
    try:
        SamplerArgumentListFilter(argv[1:])
    except CalledProcessError, error:
        exit(error.returncode or 1)

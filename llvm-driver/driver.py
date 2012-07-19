# -*- coding: utf-8 -*-

"""gcc-emulating front end for LLVM-based CBI instrumenting compilation"""

import re

from atexit import register
from collections import deque, namedtuple
from errno import ENOENT
from inspect import getargspec
from itertools import chain, imap
from os import remove
from os.path import basename, dirname, join, splitext
from subprocess import CalledProcessError, check_call
from sys import argv, stderr
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

    def discardNoArgument(self, flag):
        """discard a flag with no following argument"""
        pass


########################################################################


class SourceToBitcodeFilter(ArgumentListFilter):
    """filter out command-line arguments that should not be used when compiling source code to LLVM bitcode"""

    def __init__(self, arglist):

        exactMatches = {
            # Linker
            '-fopenmp': ArgumentListFilter.discardNoArgument,
            }

        patternMatches = {
            '^(-Wl),': ArgumentListFilter.discardNoArgument,
            }

        ArgumentListFilter.__init__(self, arglist, exactMatches, patternMatches)

    def __discardOneArgument(self, flag, arg):
        """discard a flag and a single following argument"""
        pass


class BitcodeToObjectFilter(ArgumentListFilter):
    """filter out command-line arguments that should not be used when compiling LLVM bitcode to native object code"""

    def __init__(self, arglist):

        exactMatches = {
            # Preprocessor assertion
            '-A': BitcodeToObjectFilter.__discardOneArgument,
            '-D': BitcodeToObjectFilter.__discardOneArgument,
            '-U': BitcodeToObjectFilter.__discardOneArgument,
            # Dependency generation
            '-MT': BitcodeToObjectFilter.__discardOneArgument,
            '-MQ': BitcodeToObjectFilter.__discardOneArgument,
            '-MF': BitcodeToObjectFilter.__discardOneArgument,
            '-MD': BitcodeToObjectFilter.__discardOneArgument,
            '-MMD': BitcodeToObjectFilter.__discardOneArgument,
            # Include
            '-I': BitcodeToObjectFilter.__discardOneArgument,
            '-idirafter': BitcodeToObjectFilter.__discardOneArgument,
            '-include': BitcodeToObjectFilter.__discardOneArgument,
            '-imacros': BitcodeToObjectFilter.__discardOneArgument,
            '-iprefix': BitcodeToObjectFilter.__discardOneArgument,
            '-iwithprefix': BitcodeToObjectFilter.__discardOneArgument,
            '-iwithprefixbefore': BitcodeToObjectFilter.__discardOneArgument,
            '-isystem': BitcodeToObjectFilter.__discardOneArgument,
            '-isysroot': BitcodeToObjectFilter.__discardOneArgument,
            '-iquote': BitcodeToObjectFilter.__discardOneArgument,
            '-imultilib': BitcodeToObjectFilter.__discardOneArgument,
            # Linker
            '-fopenmp': ArgumentListFilter.discardNoArgument,
            }

        patternMatches = {
            '^(-[ADIU])': ArgumentListFilter.discardNoArgument,
            '^(-Wl),': ArgumentListFilter.discardNoArgument,
            }

        ArgumentListFilter.__init__(self, arglist, exactMatches, patternMatches)

    def __discardOneArgument(self, flag, arg):
        """discard a flag and a single following argument"""
        pass


class ObjectsToExecutableFilter(ArgumentListFilter):
    """filter out command-line arguments that should not be used when linking native object code into an executable"""

    __slots__ = '__discardPthread'

    def __init__(self, arglist):

        self.__discardPthread = False

        exactMatches = {
            # Linker
            '-nostartfiles': ObjectsToExecutableFilter.__discardPthreadHandler,
            '-nostdlib': ObjectsToExecutableFilter.__discardPthreadHandler,
            }

        ArgumentListFilter.__init__(self, arglist, exactMatches)

        if self.__discardPthread:
            self.filteredArgs = [arg for arg in self.filteredArgs if arg != '-pthread']

    def __discardPthreadHandler(self, flag):
        """remember to discard "-pthread" later"""
        self.__discardPthread = True
        self.keepArgument(flag)


########################################################################


class InputFile(object):
    """file name and source language of a single input file"""

    __slots = 'filename', 'language'

    def __init__(self, filename, language=None):
        self.filename = filename
        self.language = language or self.__guessLanguage(filename)

    __standardSuffixes = {
        '.c': 'c',
        '.i': 'cpp-output',
        '.ii': 'c++-cpp-output',
        '.m': 'objective-c',
        '.mi': 'objective-c-cpp-output',
        '.mm': 'objective-c++',
        '.M': 'objective-c++',
        '.mii': 'objective-c++-cpp-output',
        '.h': 'c-header',
        '.cc': 'c++',
        '.cp': 'c++',
        '.cxx': 'c++',
        '.cpp': 'c++',
        '.CPP': 'c++',
        '.c++': 'c++',
        '.C': 'c++',
        '.mm': 'objective-c++',
        '.M': 'objective-c++',
        '.mii': 'objective-c++-cpp-output',
        '.hh': 'c++-header',
        '.H': 'c++-header',
        '.hp': 'c++-header',
        '.hxx': 'c++-header',
        '.hpp': 'c++-header',
        '.HPP': 'c++-header',
        '.h++': 'c++-header',
        '.tcc': 'c++-header',
        '.f': 'f77',
        '.for': 'f77',
        '.ftn': 'f77',
        '.F': 'f77-cpp-input',
        '.FOR': 'f77-cpp-input',
        '.fpp': 'f77-cpp-input',
        '.FPP': 'f77-cpp-input',
        '.FTN': 'f77-cpp-input',
        '.f90': 'f95',
        '.f95': 'f95',
        '.f03': 'f95',
        '.f08': 'f95',
        '.F90': 'f95-cpp-input',
        '.F95': 'f95-cpp-input',
        '.F03': 'f95-cpp-input',
        '.F08': 'f95-cpp-input',
        '.go': 'go',
        '.ads': 'ada',
        '.adb': 'ada',
        '.s': 'assembler',
        '.S': 'assembler-with-cpp',
        '.sx': 'assembler-with-cpp',
        }

    @staticmethod
    def __guessLanguage(filename):
        """guess a file's language based on its name"""
        extension = splitext(filename)[1]
        return InputFile.__standardSuffixes.get(extension, 'object')

    def args(self):
        """return arguments suitable for use on a clang/gcc command line"""
        return '-x', self.language, self.filename


class SamplerArgumentListFilter(ArgumentListFilter):
    """specialized filter for sampler-cc command-line arguments"""

    __slots__ = '__args_bitcodeToObject', '__args_sourceToBitcode', '__infiles', '__inputLanguage', '__outfile', '__schemes', '__target', '__temporaryFile', '__toggles', '__verbose'

    def __init__(self, arglist):
        self.__args_bitcodeToObject = None
        self.__args_sourceToBitcode = None
        self.__infiles = []
        self.__inputLanguage = None
        self.__outfile = None
        self.__schemes = set()
        self.__target = 'linked'
        self.__temporaryFile = self.__namedTemporaryFile
        self.__toggles = {
            'sample': True,
            }
        self.__verbose = False

        patternMatches = {
            '^(-o)=?(.+)$': SamplerArgumentListFilter.__outfileCallback,
            '^([^-].*)$': SamplerArgumentListFilter.__infileCallback,
            '^-fsampler-scheme=(.+)$': SamplerArgumentListFilter.__schemeCallback,
            '^(-l)(.+)$': SamplerArgumentListFilter.__librarySearchCallback,
            }

        exactMatches = {
            '--verbose': SamplerArgumentListFilter.__verboseCallback,
            '-E': SamplerArgumentListFilter.__targetPreprocessedCallback,
            '-c': SamplerArgumentListFilter.__targetObjectCallback,
            '-l': SamplerArgumentListFilter.__librarySearchCallback,
            '-o': SamplerArgumentListFilter.__outfileCallback,
            '-save-temps': SamplerArgumentListFilter.__saveTempsCallback,
            '-v': SamplerArgumentListFilter.__verboseCallback,
            '-x': SamplerArgumentListFilter.__languageCallback,
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
        infile = InputFile(arg, self.__inputLanguage)
        self.__infiles.append(infile)

    def __languageCallback(self, arg):
        """explicitly specify the language for following input files"""
        self.__inputLanguage = None if arg == 'none' else arg

    def __librarySearchCallback(self, flag, arg):
        """record a searched-for library"""
        infile = InputFile(flag + arg, 'object')
        self.__infiles.append(infile)

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
        command = ['clang', '-emit-llvm', '-c', '-o', uninst]
        command += infile.args()
        if self.__args_sourceToBitcode is None:
            subfilter = SourceToBitcodeFilter(self.filteredArgs)
            self.__args_sourceToBitcode = subfilter.filteredArgs
            assert self.__args_sourceToBitcode is not None
        command += self.__args_sourceToBitcode
        self.__run(command)

        runtime = self.__temporaryFile(infile, '.runtime.bc')
        extra = join(dirname(__file__), 'runtime.bc')
        self.__run(['llvm-link', '-o', runtime, uninst, extra])

        inst = self.__temporaryFile(infile, '.inst.bc')
        phases = ['-' + phase for phase in self.__extraPhases()]
        self.__run(['opt', '-o', inst, runtime] + phases)

        command = ['clang', '-c', '-o', outfile, inst]
        if self.__args_bitcodeToObject is None:
            subfilter = BitcodeToObjectFilter(self.filteredArgs)
            self.__args_bitcodeToObject = subfilter.filteredArgs
            assert self.__args_bitcodeToObject is not None
        command += self.__args_bitcodeToObject
        self.__run(command)

    @staticmethod
    def __derivedFile(basis, extension):
        """create a (non-temporary) file based on some other file name, but with a new extension"""
        filename = basename(basis.filename)
        return splitext(filename)[0] + extension

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
        command += chain.from_iterable(infile.args() for infile in self.__infiles)
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
        command = ['clang']
        if self.__outfile:
            command += ['-o', self.__outfile]
        command += imap(self.__prelink, self.__infiles)
        command += ObjectsToExecutableFilter(self.filteredArgs).filteredArgs
        self.__run(command)

    def __prelink(self, infile):
        """compile to a temporary object file in preparation for linking"""
        if infile.language == 'object':
            return infile.filename
        else:
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

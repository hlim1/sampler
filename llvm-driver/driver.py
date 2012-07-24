# -*- coding: utf-8 -*- 

"""gcc-emulating front end for LLVM-based instrumenting compilation"""

import re

from atexit import register
from errno import ENOENT
from inspect import getargspec
from itertools import chain, imap, starmap
from os import remove
from os.path import basename, splitext
from pipes import quote
from shlex import split
from subprocess import CalledProcessError, check_call
from sys import argv, stderr
from tempfile import NamedTemporaryFile


########################################################################


class ArgumentError(ValueError):
    """raised when a command-line flag is used incorrectly"""

    __slots__ = 'flag'

    def __init__(self, flag, message):
        ValueError.__init__(self, message % flag)
        self.flag = flag


class ParsedArgument(object):
    """structured sequence of one or more command-line flags treated as a unit"""
    # pylint: disable=R0903

    def __str__(self):
        raise NotImplementedError('must be implemented in subclass')

    def forCommandLine(self):
        """sequence of arguments used when this option appears on a command line"""
        raise NotImplementedError('must be implemented in subclass')


class Option(ParsedArgument):
    """command-line option, possibly with a value argument"""
    # pylint: disable=R0903

    __slots__ = 'flag', 'value'

    def __init__(self, flag, value=None):
        ParsedArgument.__init__(self)
        self.flag = flag
        self.value = value

    def __str__(self):
        return str((self.flag, self.value))

    def forCommandLine(self):
        yield self.flag
        if self.value:
            yield self.value


class InputFile(ParsedArgument):
    """file name and source language of a single input file"""
    # pylint: disable=R0903

    __slots__ = 'filename', 'language'

    def __init__(self, filename, language=None):
        ParsedArgument.__init__(self)
        self.filename = filename
        self.language = language or self.__guessLanguage(filename)

    __STANDARD_SUFFIXES = {
        '.adb': 'ada',
        '.ads': 'ada',
        '.c': 'c',
        '.c++': 'c++',
        '.C': 'c++',
        '.cc': 'c++',
        '.cp': 'c++',
        '.cpp': 'c++',
        '.CPP': 'c++',
        '.cxx': 'c++',
        '.f03': 'f95',
        '.F03': 'f95-cpp-input',
        '.f08': 'f95',
        '.F08': 'f95-cpp-input',
        '.f90': 'f95',
        '.F90': 'f95-cpp-input',
        '.f95': 'f95',
        '.F95': 'f95-cpp-input',
        '.f': 'f77',
        '.F': 'f77-cpp-input',
        '.for': 'f77',
        '.FOR': 'f77-cpp-input',
        '.fpp': 'f77-cpp-input',
        '.FPP': 'f77-cpp-input',
        '.ftn': 'f77',
        '.FTN': 'f77-cpp-input',
        '.go': 'go',
        '.h': 'c-header',
        '.h++': 'c++-header',
        '.H': 'c++-header',
        '.hh': 'c++-header',
        '.hp': 'c++-header',
        '.hpp': 'c++-header',
        '.HPP': 'c++-header',
        '.hxx': 'c++-header',
        '.i': 'cpp-output',
        '.ii': 'c++-cpp-output',
        '.mii': 'objective-c++-cpp-output',
        '.mi': 'objective-c-cpp-output',
        '.mm': 'objective-c++',
        '.m': 'objective-c',
        '.M': 'objective-c++',
        '.s': 'assembler',
        '.S': 'assembler-with-cpp',
        '.sx': 'assembler-with-cpp',
        '.tcc': 'c++-header',
        }

    @staticmethod
    def __guessLanguage(filename):
        """guess a file's language based on its name"""
        extension = splitext(filename)[1]
        return InputFile.__STANDARD_SUFFIXES.get(extension, 'linker')

    def forCommandLine(self):
        return '-x', self.language, self.filename

    def __str__(self):
        return "%s [%s]" % (self.filename, self.language)


def precompilePatterns(*choices):
    """build a regular expression matching a set of command-line flags"""
    joined = '|'.join(choices)
    anchored = '^-(%s)$' % joined
    return re.compile(anchored)


def regexpHandlerTable(*entries):
    """compile patterns in a regular expression handler table"""

    def compileEntry(pattern, handler):
        """compile a single regular expression handler table entry"""
        return re.compile(pattern), handler
    return tuple(starmap(compileEntry, entries))


class Driver(object):
    """emulator for an invocation of gcc"""
    # pylint: disable=R0902

    __slots__ = (
        '__finalGoal',
        '__flagExactHandlers',
        '__flagRegexpHandlers',
        '__inputFiles',
        '__inputLanguage',
        '__outputFile',
        '__verbose',
        'temporaryFile',
        )

    def __init__(self, extraExact=dict(), extraRegexp=tuple()):
        self.__finalGoal = self.__buildLinked
        self.__flagExactHandlers = Driver.__FLAG_EXACT_HANDLERS.copy()
        self.__flagExactHandlers.update(extraExact)
        self.__flagRegexpHandlers = extraRegexp + Driver.__FLAG_REGEXP_HANDLERS
        self.__inputFiles = []
        self.__inputLanguage = None
        self.__outputFile = None
        self.temporaryFile = self.__namedTemporaryFile
        self.__verbose = False

    ####################################################################
    #
    #  preliminary command-line processing
    #

    def __handleFlagGoalPreprocessed(self, _flag):
        """handle "-E" flag"""
        __pychecker__ = 'unusednames=_flag'
        self.__finalGoal = self.__buildPreprocessed

    def __handleFlagGoalAssembly(self, _flag):
        """handle "-S" flag"""
        __pychecker__ = 'unusednames=_flag'
        self.__finalGoal = self.__buildAssembly

    def __handleFlagGoalObject(self, _flag):
        """handle "-c" flag"""
        __pychecker__ = 'unusednames=_flag'
        self.__finalGoal = self.__buildObject

    def __handleFlagSaveTemps(self, flag):
        """handle "-save-temps" flag"""
        self.temporaryFile = self.derivedFile
        return self.__handleFlagOptionNoValue(flag)

    def __handleFlagOutputFilename(self, _flag, filename):
        """handle "-o FILE" flag"""
        __pychecker__ = 'unusednames=_flag'
        self.__outputFile = filename

    def __handleFlagInputLanguage(self, _flag, language):
        """handle "-x LANGUAGE" flag"""
        __pychecker__ = 'unusednames=_flag'
        self.__inputLanguage = None if language == 'none' else language

    def __handleFlagVerbose(self, flag):
        """handle "-v" flag"""
        self.__verbose = True
        return self.__handleFlagOptionNoValue(flag)

    def __handleInputFilename(self, filename):
        """handle input file name"""
        inputFile = InputFile(filename, self.__inputLanguage)
        self.__inputFiles.append(inputFile)
        return inputFile

    def __handleFlagOptionNoValue(self, flag):
        """keep flag with no additional value argument"""
        # pylint: disable=R0201
        return Option(flag)

    def __handleFlagOptionOneValue(self, flag, value):
        """keep flag with one additional value argument"""
        # pylint: disable=R0201
        return Option(flag, value)

    __FLAG_EXACT_HANDLERS = {
        # overall options
        '-E': __handleFlagGoalPreprocessed,
        '-S': __handleFlagGoalAssembly,
        '-c': __handleFlagGoalObject,
        '-save-temps': __handleFlagSaveTemps,
        '-o': __handleFlagOutputFilename,
        '-x': __handleFlagInputLanguage,
        '-v': __handleFlagVerbose,
        '-wrapper': __handleFlagOptionOneValue,

        # C dialect options
        '-aux-info': __handleFlagOptionOneValue,

        # optimize options
        '--param': __handleFlagOptionOneValue,

        # preprocessor options
        '-Xpreprocessor': __handleFlagOptionOneValue,
        '-D': __handleFlagOptionOneValue,
        '-U': __handleFlagOptionOneValue,
        '-I': __handleFlagOptionOneValue,
        '-MF': __handleFlagOptionOneValue,
        '-MT': __handleFlagOptionOneValue,
        '-MQ': __handleFlagOptionOneValue,
        '-include': __handleFlagOptionOneValue,
        '-imacros': __handleFlagOptionOneValue,
        '-idirafter': __handleFlagOptionOneValue,
        '-iprefix': __handleFlagOptionOneValue,
        '-iwithprefix': __handleFlagOptionOneValue,
        '-iwithprefixbefore': __handleFlagOptionOneValue,
        '-isysroot': __handleFlagOptionOneValue,
        '-imultilib': __handleFlagOptionOneValue,
        '-isystem': __handleFlagOptionOneValue,
        '-iquote': __handleFlagOptionOneValue,
        '-A': __handleFlagOptionOneValue,

        # assembler options
        '-Xassembler': __handleFlagOptionOneValue,

        # link options
        '-l': __handleFlagOptionOneValue,
        '-T': __handleFlagOptionOneValue,
        '-Xlinker': __handleFlagOptionOneValue,
        '-u': __handleFlagOptionOneValue,

        # Darwin options
        '-bundle_loader': __handleFlagOptionOneValue,
        '-allowable_client': __handleFlagOptionOneValue,

        # M32R/D options; MIPS options; RS/6000 and PowerPC options
        '-G': __handleFlagOptionOneValue,
        }

    __FLAG_REGEXP_HANDLERS = regexpHandlerTable(
        ('^(-.*)$', __handleFlagOptionNoValue),
        ('^(.*)$', __handleInputFilename),
        )
            
    def __pickHandler(self, arg):
        """pick handler for one command line argument"""
        __pychecker__ = 'no-returnvalues'

        handler = self.__flagExactHandlers.get(arg)
        if handler:
            return handler, [arg]

        for pattern, handler in self.__flagRegexpHandlers:
            match = pattern.match(arg)
            if match:
                groups = match.groups()
                return handler, list(groups)

        raise LookupError('no handler for "%s"' % arg)

    def __parse(self, args):
        """parse command line, recognizing a few options with special meaning"""
        args = iter(args)
        for arg in args:
            if arg.startswith('@'):
                filename = arg[1:]
                with open(filename) as stream:
                    subargs = split(stream, comments=False)
                    for subarg in self.__parse(subargs):
                        yield subarg
            else:
                handler, values = self.__pickHandler(arg)
                arity = len(getargspec(handler)[0]) - 1
                try:
                    while len(values) < arity:
                        values.append(args.next())
                except StopIteration:
                    raise ArgumentError(arg, "argument to '%s' is missing")
                # pylint: disable=W0142
                parsed = handler(self, *values)
                if parsed is not None:
                    yield parsed

    def process(self, args):
        """process a single command line, building whatever is requested"""
        parsed = tuple(self.__parse(args))
        self.__finalGoal(parsed)

    def __checkMultipleOutputFiles(self):
        """raise an error if multiple output files will be created but a single output file was explicitly named"""
        if self.__outputFile and len(self.__inputFiles) > 1:
            raise ArgumentError('-o', "cannot specify '%s' when generating multiple output files")


    ####################################################################
    #
    #  file management
    #

    @staticmethod
    def derivedFile(inputFile, extension):
        """create a (non-temporary) file based on some other file name, but with a new extension"""
        filename = basename(inputFile.filename)
        return splitext(filename)[0] + extension

    @staticmethod
    def __namedTemporaryFile(_inputFile, extension):
        """create a temporary file with a given extension"""
        __pychecker__ = 'unusednames=_inputFile'
        handle = NamedTemporaryFile(prefix='cbi-', suffix=extension, mode='wb', delete=False)
        handle.close()
        register(Driver.__tryRemove, handle.name)
        return handle.name

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
    #  compilation helpers
    #

    __SOURCE_TO_BITCODE_UNWANTED = precompilePatterns(
        'Wl,.*',
        'Xlinker',
        'fopenmp',
        )

    def sourceToBitcodeCommand(self, inputFile, outputFile, args):
        """command line for building bitcode from source code"""
        # pylint: disable=R0201

        for arg in 'clang', '-emit-llvm', '-c', '-o', outputFile:
            yield arg

        for arg in args:
            if isinstance(arg, InputFile):
                if arg == inputFile:
                    yield arg
            elif Driver.__SOURCE_TO_BITCODE_UNWANTED.match(arg.flag):
                pass
            else:
                yield arg

    __BITCODE_TO_OBJECT_UNWANTED = precompilePatterns(
        'I.*',
        'MD',
        'MF',
        'MMD',
        'MP',
        'MT',
        'Wl,.*',
        'Xlinker',
        'fopenmp',
        'idirafter',
        'imacros',
        'imultilib',
        'include',
        'iprefix',
        'iquote',
        'isysroot',
        'isystem',
        'iwithprefix',
        'iwithprefixbefore',
        )

    def bitcodeToObjectCommand(self, inputFile, outputFile, intermediateFile, args, targetFlag):
        """command line for building native object code from bitcode"""
        # pylint: disable=R0201,R0913

        for arg in 'clang', targetFlag, '-o', outputFile:
            yield arg

        for arg in args:
            if isinstance(arg, InputFile):
                if arg == inputFile:
                    yield intermediateFile
            elif Driver.__BITCODE_TO_OBJECT_UNWANTED.match(arg.flag):
                pass
            else:
                yield arg

    def instrumentBitcode(self, inputFile, uninstrumented, instrumented):
        """add instrumentation to a single source file's bitcode"""
        # pylint: disable=W0613
        __pychecker__ = 'unusednames=inputFile'
        phases = self.getOptPhases()
        self.run(('opt', '-o', instrumented, uninstrumented), phases)

    def getOptPhases(self):
        """sequence of LLVM phases to use when transforming bitcode"""
        raise NotImplementedError('must be implemented in subclass')

    def __compileTo(self, inputFile, objectFile, args, targetFlag='-c'):
        """compile a single input file to a single output object file"""
        uninstrumented = self.temporaryFile(inputFile, '.uninstrumented.bc')
        command = self.sourceToBitcodeCommand(inputFile, uninstrumented, args)
        self.run(command)

        instrumented = self.temporaryFile(inputFile, '.instrumented.bc')
        self.instrumentBitcode(inputFile, uninstrumented, instrumented)

        command = self.bitcodeToObjectCommand(inputFile, objectFile, instrumented, args, targetFlag)
        self.run(command)

    ####################################################################
    #
    #  linking helpers
    #

    MAKE_PTHREAD_UNUSED = set(('-nostartfiles', '-nostdlib'))

    def __makeLinkable(self, inputFile, args):
        """compile to a temporary object file in preparation for linking"""
        if inputFile.language == 'linker':
            return inputFile.filename
        else:
            objectFile = self.temporaryFile(inputFile, '.o')
            self.__compileTo(inputFile, objectFile, args)
            return objectFile

    def objectsToLinkedCommand(self, outputFile, args):
        """command line for building native executable from native objects"""
        for arg in 'clang', '-o', outputFile:
            yield arg

        discardPthread = False
        for arg in args:
            if isinstance(arg, Option):
                if arg.flag in self.MAKE_PTHREAD_UNUSED:
                    discardPthread = True
                    break

        for arg in args:
            if isinstance(arg, InputFile):
                yield self.__makeLinkable(arg, args)
            elif discardPthread and arg.flag == '-pthread':
                pass
            else:
                yield arg

    def linkTo(self, outputFile, args):
        """link to the given output file"""
        self.run(self.objectsToLinkedCommand(outputFile, args))

    ####################################################################
    #
    #  final goal builders
    #

    def __buildLinked(self, args):
        """build linked executable or shared library"""
        outputFile = self.__outputFile or 'a.out'
        self.linkTo(outputFile, args)

    def __buildObject(self, args):
        """build native object file, but do not link"""
        self.__checkMultipleOutputFiles()
        for inputFile in self.__inputFiles:
            outputFile = self.__outputFile or self.derivedFile(inputFile, '.o')
            self.__compileTo(inputFile, outputFile, args)

    def __buildAssembly(self, args):
        """build native assembly file, but do not assemble"""
        self.__checkMultipleOutputFiles()
        for inputFile in self.__inputFiles:
            outputFile = self.__outputFile or self.derivedFile(inputFile, '.s')
            self.__compileTo(inputFile, outputFile, args, '-S')

    def __buildPreprocessed(self, args):
        """preprocess, but do not compile"""
        outputFlags = ('-o', self.__outputFile) if self.__outputFile else ()
        self.run(('clang', '-E'), outputFlags, args)

    ####################################################################
    #
    #  subprocess management
    #

    @staticmethod
    def __expandArg(arg):
        """expand an option to a sequence of strings, unless it is a string already"""
        if isinstance(arg, str):
            return arg,
        else:
            return arg.forCommandLine()

    def run(self, *args):
        """run an external subcommand"""
        chained = chain.from_iterable(args)
        expanded = imap(self.__expandArg, chained)
        flattened = tuple(chain.from_iterable(expanded))
        if self.__verbose:
            quoted = imap(quote, flattened)
            print >> stderr, '⌘', ' '.join(quoted)
        check_call(flattened)


def drive(driver):
    """imitate gcc using the given driver"""
    try:
        driver.process(argv[1:])
    except ArgumentError, error:
        print >> stderr, "%s: error: %s" % (argv[0], error)
        exit(1)
    except CalledProcessError, error:
        exit(error.returncode or 1)


__all__ = 'drive', 'Driver', 'regexpHandler'

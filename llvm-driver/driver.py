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


# pylint: disable=C0103
Stages = type('Stages', (object,), {
        'UNSPECIFIED': 'unspecified',
        'SOURCE_TO_BITCODE': 'source to bitcode',
        'BITCODE_TO_OBJECT': 'bitcode to object',
        'OBJECTS_TO_LINKED': 'objects to linked',
        })


class ParsedArgument(object):
    """structured sequence of one or more command-line flags treated as a unit"""
    # pylint: disable=R0903

    def __str__(self):
        raise NotImplementedError('must be implemented in subclass')

    def forCommandLine(self, stage=Stages.UNSPECIFIED, substitutions=None):
        """arguments used for a given stage's command line"""
        # pylint: disable=R0201,W0613
        __pychecker__ = 'unusednames=stage,substitutions'
        raise NotImplementedError('must be implemented in subclass')


class Option(ParsedArgument):
    """command-line option, possibly with a value argument"""
    # pylint: disable=R0903

    __slots__ = 'applicableStages', 'flag', '__value'

    def __init__(self, applicableStages, flag, value=None):
        ParsedArgument.__init__(self)
        self.applicableStages = applicableStages
        self.flag = flag
        self.__value = value

    def __str__(self):
        return str((self.applicableStages, self.flag, self.__value))

    def forCommandLine(self, stage=Stages.UNSPECIFIED, substitutions=None):
        __pychecker__ = 'unusednames=substitutions'
        if stage in self.applicableStages:
            yield self.flag
            if self.__value:
                yield self.__value


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

    def forCommandLine(self, stage=Stages.UNSPECIFIED, substitutions=None):
        __pychecker__ = 'unusednames=stage, no-returnvalues'
        if substitutions:
            if self in substitutions:
                substitution = substitutions[self]
                if substitution:
                    return (substitution,)
            else:
                return ()

        return ('-x', self.language, self.filename)

    def __str__(self):
        return "%s [%s]" % (self.filename, self.language)


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
        '__derivedFilesNearOutputFile',
        '__finalGoal',
        '__flagExactHandlers',
        '__flagRegexpHandlers',
        '__inputFiles',
        '__inputLanguage',
        '__outputFile',
        '__pthreadOptions',
        '__pthreadUsedByLinker',
        '__verbose',
        'temporaryFile',
        )

    def __init__(self, extraExact=dict(), extraRegexp=tuple()):
        self.__derivedFilesNearOutputFile = False
        self.__finalGoal = self.__buildLinked
        self.__flagExactHandlers = Driver.__FLAG_EXACT_HANDLERS.copy()
        self.__flagExactHandlers.update(extraExact)
        self.__flagRegexpHandlers = extraRegexp + Driver.__FLAG_REGEXP_HANDLERS
        self.__inputFiles = []
        self.__inputLanguage = None
        self.__outputFile = None
        self.__pthreadOptions = set()
        self.__pthreadUsedByLinker = True
        self.__verbose = False
        self.temporaryFile = self.__namedTemporaryFile

    ####################################################################
    #
    #  command-line parsing
    #

    __STAGES_ONLY_TO_BITCODE = frozenset((Stages.SOURCE_TO_BITCODE,))
    __STAGES_ONLY_TO_OBJECT = frozenset((Stages.BITCODE_TO_OBJECT,))
    __STAGES_ONLY_TO_LINKED = frozenset((Stages.OBJECTS_TO_LINKED,))
    __STAGES_ONLY_UNSPECIFIED = frozenset((Stages.UNSPECIFIED,))
    __STAGES_ALL = __STAGES_ONLY_TO_BITCODE | __STAGES_ONLY_TO_OBJECT | __STAGES_ONLY_TO_LINKED | __STAGES_ONLY_UNSPECIFIED
    __STAGES_NOT_TO_LINKED = __STAGES_ALL - __STAGES_ONLY_TO_LINKED

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

    def __handleFlagSaveTempsCwd(self, flag):
        """handle "-save-temps" and "-save-temps=cwd" flags"""
        self.temporaryFile = self.derivedFile
        self.__derivedFilesNearOutputFile = False
        return self.__handleFlagOptionNoValue(flag)

    def __handleFlagSaveTempsObj(self, flag):
        """handle "-save-temps=obj" flag"""
        self.temporaryFile = self.derivedFile
        self.__derivedFilesNearOutputFile = True
        return self.__handleFlagOptionNoValue(flag)

    def __handleFlagOutputFilename(self, _flag, filename):
        """handle "-o FILE" flag"""
        __pychecker__ = 'unusednames=_flag'
        self.__outputFile = filename

    def __handleFlagPthread(self, flag):
        """handle "-pthread" and "-pthreads" flags"""
        option = self.__handleFlagOptionNoValue(flag)
        self.__pthreadOptions.add(option)
        return option

    def __handleFlagInputLanguage(self, _flag, language):
        """handle "-x LANGUAGE" flag"""
        __pychecker__ = 'unusednames=_flag'
        self.__inputLanguage = None if language == 'none' else language

    def __handleFlagVerbose(self, flag):
        """handle "-v" flag"""
        self.__verbose = True
        return self.__handleFlagOptionNoValue(flag)

    def __handleFlagLinkerPthreadUnused(self, flag):
        """handle various linker flags that make "-pthread" unused at link time"""
        self.__pthreadUsedByLinker = False
        return self.__handleFlagOnlyToLinkedNoValue(flag)

    def __handleInputFilename(self, filename):
        """handle input file name"""
        inputFile = InputFile(filename, self.__inputLanguage)
        self.__inputFiles.append(inputFile)
        return inputFile

    def __handleFlagOnlyToBitcodeNoValue(self, flag):
        """handle various compilation-to-bitcode-only flags with no additional value argument"""
        return Option(self.__STAGES_ONLY_TO_BITCODE, flag)

    def __handleFlagOnlyToBitcodeOneValue(self, flag, value):
        """handle various compilation-to-bitcode-only flags with one additional value argument"""
        return Option(self.__STAGES_ONLY_TO_BITCODE, flag, value)

    def __handleFlagOnlyToObjectNoValue(self, flag):
        """handle various compilation-to-object-only flags with no additional value argument"""
        return Option(self.__STAGES_ONLY_TO_OBJECT, flag)

    def __handleFlagOnlyToObjectOneValue(self, flag, value):
        """handle various compilation-to-object-only flags with one additional value argument"""
        return Option(self.__STAGES_ONLY_TO_OBJECT, flag, value)

    def __handleFlagOnlyToLinkedNoValue(self, flag):
        """handle various linker-only flags with no additional value argument"""
        return Option(self.__STAGES_ONLY_TO_LINKED, flag)

    def __handleFlagOnlyToLinkedOneValue(self, flag, value):
        """handle various linker-only flags with one additional value argument"""
        return Option(self.__STAGES_ONLY_TO_LINKED, flag, value)

    def __handleFlagOptionNoValue(self, flag):
        """keep flag with no additional value argument"""
        # pylint: disable=R0201
        return Option(self.__STAGES_ALL, flag)

    def __handleFlagOptionOneValue(self, flag, value):
        """keep flag with one additional value argument"""
        # pylint: disable=R0201
        return Option(self.__STAGES_ALL, flag, value)

    __FLAG_EXACT_HANDLERS = {
        # overall options
        '-E': __handleFlagGoalPreprocessed,
        '-S': __handleFlagGoalAssembly,
        '-c': __handleFlagGoalObject,
        '-save-temps': __handleFlagSaveTempsCwd,
        '-save-temps=cwd': __handleFlagSaveTempsCwd,
        '-save-temps=obj': __handleFlagSaveTempsObj,
        '-o': __handleFlagOutputFilename,
        '-pthread': __handleFlagPthread,
        '-pthreads': __handleFlagPthread,
        '-x': __handleFlagInputLanguage,
        '-v': __handleFlagVerbose,
        '-wrapper': __handleFlagOptionOneValue,

        # C dialect options
        '-aux-info': __handleFlagOptionOneValue,

        # optimize options
        '--param': __handleFlagOptionOneValue,

        # preprocessor options
        '-A': __handleFlagOnlyToBitcodeOneValue,
        '-D': __handleFlagOnlyToBitcodeOneValue,
        '-I': __handleFlagOnlyToBitcodeOneValue,
        '-MF': __handleFlagOnlyToBitcodeOneValue,
        '-MD': __handleFlagOnlyToBitcodeNoValue,
        '-MMD': __handleFlagOnlyToBitcodeNoValue,
        '-MP': __handleFlagOnlyToBitcodeNoValue,
        '-MQ': __handleFlagOnlyToBitcodeOneValue,
        '-MT': __handleFlagOnlyToBitcodeOneValue,
        '-U': __handleFlagOnlyToBitcodeOneValue,
        '-Xpreprocessor': __handleFlagOnlyToBitcodeOneValue,
        '-idirafter': __handleFlagOnlyToBitcodeOneValue,
        '-imacros': __handleFlagOnlyToBitcodeOneValue,
        '-imultilib': __handleFlagOnlyToBitcodeOneValue,
        '-include': __handleFlagOnlyToBitcodeOneValue,
        '-iprefix': __handleFlagOnlyToBitcodeOneValue,
        '-iquote': __handleFlagOnlyToBitcodeOneValue,
        '-isysroot': __handleFlagOnlyToBitcodeOneValue,
        '-isystem': __handleFlagOnlyToBitcodeOneValue,
        '-iwithprefix': __handleFlagOnlyToBitcodeOneValue,
        '-iwithprefixbefore': __handleFlagOnlyToBitcodeOneValue,

        # assembler options
        '-Xassembler': __handleFlagOnlyToObjectOneValue,

        # link options
        '-L': __handleFlagOnlyToLinkedOneValue,
        '-T': __handleFlagOnlyToLinkedOneValue,
        '-Xlinker': __handleFlagOnlyToLinkedOneValue,
        '-fopenmp': __handleFlagOnlyToLinkedNoValue,
        '-l': __handleFlagOnlyToLinkedOneValue,
        '-nostartfiles': __handleFlagLinkerPthreadUnused,
        '-nostdlib': __handleFlagLinkerPthreadUnused,
        '-u': __handleFlagOnlyToLinkedOneValue,

        # Darwin options
        '-bundle_loader': __handleFlagOptionOneValue,
        '-allowable_client': __handleFlagOptionOneValue,

        # M32R/D options; MIPS options; RS/6000 and PowerPC options
        '-G': __handleFlagOptionOneValue,
        }

    __FLAG_REGEXP_HANDLERS = regexpHandlerTable(
        # overall options
        ('^(-o)(.+)$', __handleFlagOutputFilename),
        ('^(-x)(.+)$', __handleFlagInputLanguage),

        # preprocessor options
        ('^(-[ADIU])(.+)$', __handleFlagOnlyToBitcodeOneValue),
        ('^(-Wp,.*)$', __handleFlagOnlyToBitcodeNoValue),

        # assembler options
        ('^(-Wa,.*)$', __handleFlagOnlyToObjectNoValue),

        # link options
        ('^(-[Llt])(.+)$', __handleFlagOnlyToLinkedOneValue),
        ('^(-Wl,.*)$', __handleFlagOnlyToLinkedNoValue),

        # M32R/D options; MIPS options; RS/6000 and PowerPC options
        ('^(-G)(.+)$', __handleFlagOptionOneValue),

        # all other options and input files; must appear last
        ('^(-.*)$', __handleFlagOptionNoValue),
        ('^(.*)$', __handleInputFilename),
        )
            
    def __pickHandler(self, arg):
        """pick handler for one command line argument"""
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

        if not self.__pthreadUsedByLinker:
            for option in self.__pthreadOptions:
                option.applicableStages = self.__STAGES_NOT_TO_LINKED

        self.__finalGoal(parsed)

    def __checkMultipleOutputFiles(self):
        """raise an error if multiple output files will be created but a single output file was explicitly named"""
        if self.__outputFile and len(self.__inputFiles) > 1:
            raise ArgumentError('-o', "cannot specify '%s' when generating multiple output files")


    ####################################################################
    #
    #  file management
    #

    def derivedFile(self, inputFile, extension):
        """create a (non-temporary) file based on some other file name, but with a new extension"""
        basedOnOutput = self.__derivedFilesNearOutputFile and self.__outputFile
        basis = self.__outputFile if basedOnOutput else basename(inputFile.filename)
        return splitext(basis)[0] + extension

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

    def sourceToBitcodeCommand(self, inputFile, outputFile, args):
        """command line for building bitcode from source code"""
        return chain(
            ('clang', '-emit-llvm', '-c', '-o', outputFile),
            self.__expandArgs(args, 'source to bitcode', {inputFile: None}),
            )

    def bitcodeToObjectCommand(self, inputFile, outputFile, intermediateFile, args, targetFlag):
        """command line for building native object code from bitcode"""
        # pylint: disable=R0913
        return chain(
            ('clang', targetFlag, '-o', outputFile),
            self.__expandArgs(args, 'bitcode to object', {inputFile: intermediateFile}),
            )

    def instrumentBitcode(self, inputFile, uninstrumented, instrumented):
        """add instrumentation to a single source file's bitcode"""
        # pylint: disable=W0613
        __pychecker__ = 'unusednames=inputFile'
        prelude = ('opt', '-o', instrumented, uninstrumented)
        phases = self.getExtraOptArgs()
        command = chain(prelude, phases)
        self.run(command)

    def getExtraOptArgs(self):
        """arguments used when running "opt" to transform bitcode"""
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
        prelude = ('clang', '-o', outputFile)
        objectsForInputs = { inputFile: self.__makeLinkable(inputFile, args) for inputFile in self.__inputFiles }
        expanded = self.__expandArgs(args, 'objects to linked', objectsForInputs)
        return chain(prelude, expanded)

    def linkTo(self, outputFile, args):
        """link to the given output file"""
        command = self.objectsToLinkedCommand(outputFile, args)
        self.run(command)

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
        prelude = ('clang', '-E')
        outputFlags = ('-o', self.__outputFile) if self.__outputFile else ()
        userArgs = self.__expandArgs(args)
        command = chain(prelude, outputFlags, userArgs)
        self.run(command)

    ####################################################################
    #
    #  subprocess management
    #

    @staticmethod
    def __expandArgs(args, stage=Stages.UNSPECIFIED, substitutions=None):
        """expand a sequence of parsed arguments to a sequence of strings"""
        return chain.from_iterable(arg.forCommandLine(stage, substitutions) for arg in args)

    def run(self, command):
        """run an external subcommand"""
        command = tuple(command)
        if self.__verbose:
            quoted = imap(quote, command)
            print >> stderr, '⌘', ' '.join(quoted)
        check_call(command)


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

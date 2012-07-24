# pylint: disable=C0103

"""gcc-emulating front end for LLVM-based CBI instrumenting compilation"""

from os.path import dirname, join

from driver import drive, Driver, regexpHandlerTable


class SamplerDriver(Driver):
    """emulator for an invocation of gcc plus CBI instrumentation"""

    __slots__ = '__predict_checks', '__sample', '__schemes'

    HOME = dirname(__file__)

    def __handleFlagToggle(self, negated, feature):
        """handle various "-fTOGGLE" and "-fno-TOGGLE" flags"""
        name = '_SamplerDriver__' + feature.replace('-', '_')
        value = not negated
        setattr(self, name, value)

    def __handleFlagScheme(self, scheme):
        """handle "-fssampler-scheme=SCHEME" flag"""
        self.__schemes.add(scheme)

    EXTRA_FLAG_REGEXP_HANDLERS = regexpHandlerTable(
        ('^-fsampler-scheme=(.+)$', __handleFlagScheme),
        ('^-f(no-)?(predict-checks|sample)$', __handleFlagToggle),
        )

    def __init__(self):
        Driver.__init__(self, extraRegexp=self.EXTRA_FLAG_REGEXP_HANDLERS)
        self.__predict_checks = True
        self.__sample = True
        self.__schemes = set()

    def getExtraOptArgs(self):
        # pylint: disable=C0321

        schemes = self.__schemes
        if not schemes: return
        yield '-load'
        yield join(self.HOME, 'libInstrumentor.so')

        if 'branches' in schemes: yield '-branches'
        if 'returns' in schemes: yield '-returns'

        if self.__sample:
            yield '-reg2mem'
            yield '-sampler'
            #yield '-mem2reg'

        if self.__predict_checks:
            yield '-predict-checks'

    def instrumentBitcode(self, inputFile, uninstrumented, instrumented):
        runtime = join(self.HOME, 'runtime.bc')
        plusRuntime = self.temporaryFile(inputFile, '.plus-runtime.bc')
        command = ('llvm-link', '-o', plusRuntime, uninstrumented, runtime)
        self.run(command)
        Driver.instrumentBitcode(self, inputFile, plusRuntime, instrumented)


def main():
    """imitate gcc using CBI-instrumenting driver"""
    drive(SamplerDriver())

__all__ = 'main',

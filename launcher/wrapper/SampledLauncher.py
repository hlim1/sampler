import os

from Launcher import Launcher
from Outcome import Outcome
from ReportsReader import ReportsReader

import Uploader


########################################################################


class SampledLauncher(Launcher):
    '''Launch an application with sampling enabled.'''

    def __init__(self, app, user, sparsity):
        Launcher.__init__(self, app)
        self.__user = user
        self.__sparsity = sparsity

    def spawn(self):
        # set up random number generator
        os.environ['SAMPLER_SPARSITY'] = str(self.__sparsity)
        if 'GSL_RNG_TYPE' in os.environ: del os.environ['GSL_RNG_TYPE']
        if 'GSL_RNG_SEED' in os.environ: del os.environ['GSL_RNG_SEED']

        # set up reporting
        self.__pipe = os.pipe()
        os.environ['SAMPLER_FILE'] = '/dev/fd/%d' % self.__pipe[1]
        os.environ['SAMPLER_REPORT_FD'] = '%d' % self.__pipe[1]
        os.environ['GNOME_DISABLE_CRASH_DIALOG'] = '1'
        os.environ['SAMPLER_REAL_EXECUTABLE'] = self.app.executable()
        if self.app.debug_reporter():
            os.environ['SAMPLER_DEBUGGER'] = self.app.debug_reporter()

        # away we go!
        Launcher.spawn(self)

        # close writing end before creating any other subprocesses
        os.close(self.__pipe[1])

        return

    def prep_outcome(self, outcome):
        outcome.sparsity = self.__sparsity

        # collect reports
        outcome.reports = ReportsReader(os.fdopen(self.__pipe[0]))

    def wait(self):
        outcome = Launcher.wait(self)
        if self.__user.enabled():
            Uploader.upload(self.app, self.__user, outcome, 'text/html')

        return outcome

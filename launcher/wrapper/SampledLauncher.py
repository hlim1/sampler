from fcntl import *
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

        # tidy up pipe ends
        os.close(self.__pipe[1])
        flags = fcntl(self.__pipe[0], F_GETFD)
        if flags >= 0:
            flags |= FD_CLOEXEC
            fcntl(self.__pipe[0], F_SETFD, flags)

        return

    def prep_outcome(self, outcome):
        outcome.sparsity = self.__sparsity
        outcome.reports = ReportsReader(os.fdopen(self.__pipe[0]))

    def wait(self):
        outcome = Launcher.wait(self)
        if self.__user.enabled():
            Uploader.upload(self.app, self.__user, outcome, 'text/html')

        return outcome

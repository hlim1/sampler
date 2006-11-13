import os


########################################################################


class Launcher(object):
    '''Manage launching and waiting for an application.'''

    __slots__ = ['__pid', 'app']

    def __init__(self, app):
        self.app = app

    def spawn(self):
        import sys
        self.__pid = os.spawnv(os.P_NOWAIT, self.app.executable, sys.argv)

    def prep_outcome(self, outcome):
        pass

    def wait(self):
        import Outcome
        outcome = Outcome.Outcome()
        self.prep_outcome(outcome)
        
        [pid, exit_codes] = os.waitpid(self.__pid, 0)

        if os.WIFEXITED(exit_codes):
            outcome.status = os.WEXITSTATUS(exit_codes)
        else:
            outcome.status = 0

        if os.WIFSIGNALED(exit_codes):
            outcome.signal = os.WTERMSIG(exit_codes)
        else:
            outcome.signal = 0

        return outcome

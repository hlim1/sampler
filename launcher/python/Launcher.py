import os
import signal
import struct
import sys

import Outcome
import ReportsReader


def run_without_sampling(app):
    '''Run an application with sampling forced off.

    This function does not return!
    '''

    # force sampling off
    if 'SAMPLER_SPARSITY' in os.environ:
        del os.environ['SAMPLER_SPARSITY']

    # away we go!
    os.execv(app.executable(), sys.argv)


def run_with_sampling(app, sparsity):
    '''Run an application with sampling according to user preferences.

    Returns an Outcome object describing the outcome of the run.'''

    outcome = Outcome.Outcome()

    # set up random number generator
    format = 'L'
    outcome.seed = str(struct.unpack(format, file('/dev/urandom').read(struct.calcsize(format)))[0])
    outcome.sparsity = sparsity
    os.environ['SAMPLER_SEED'] = outcome.seed
    os.environ['SAMPLER_SPARSITY'] = str(outcome.sparsity)
    if 'GSL_RNG_TYPE' in os.environ:
        del os.environ['GSL_RNG_TYPE']
    if 'GSL_RNG_SEED' in os.environ:
        del os.environ['GSL_RNG_SEED']

    # set up reporting
    pipe = os.pipe()
    os.environ['SAMPLER_FILE'] = '/dev/fd/%d' % pipe[1]
    os.environ['GNOME_DISABLE_CRASH_DIALOG'] = '1'
    if app.debug_reporter():
        os.environ['SAMPLER_DEBUGGER'] = app.debug_reporter()

    # away we go!
    pid = os.spawnv(os.P_NOWAIT, app.executable(), sys.argv)
    old_handler = signal.signal(signal.SIGINT, lambda signum, frame: os.kill(pid, signum))

    # collect reports
    os.close(pipe[1])
    outcome.reports = ReportsReader.ReportsReader(os.fdopen(pipe[0]))

    # collect exit status
    [pid, exit_codes] = os.wait()
    outcome.status = os.WIFEXITED(exit_codes) and os.WEXITSTATUS(exit_codes)
    outcome.signal = os.WIFSIGNALED(exit_codes) and os.WTERMSIG(exit_codes)
    signal.signal(signal.SIGINT, old_handler)

    # finis
    return outcome

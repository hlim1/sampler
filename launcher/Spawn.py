import cStringIO
import os
import shutil
import struct
import sys


########################################################################
#
#  GUI-independent code for spawning off sampled applications
#

class Spawn:
    def __init__(self, sparsity, application):
        format = 'L'
        self.seed = str(struct.unpack(format, file('/dev/urandom').read(struct.calcsize(format)))[0])

        pipe = os.pipe()
        os.environ['GNOME_DISABLE_CRASH_DIALOG'] = '1'
        os.environ['SAMPLER_FILE'] = '/dev/fd/%d' % pipe[1]
        os.environ['SAMPLER_DEBUGGER'] = application.path('print-debug-info')
        os.environ['SAMPLER_SPARSITY'] = str(sparsity)
        os.environ['SAMPLER_SEED'] = self.seed
        if 'GSL_RNG_TYPE' in os.environ:
            del os.environ['GSL_RNG_TYPE']
            if 'GSL_RNG_SEED' in os.environ:
                del os.environ['GSL_RNG_SEED']

        os.spawnv(os.P_NOWAIT, application.executable, sys.argv)

        os.close(pipe[1])
        self.reportsFile = os.fdopen(pipe[0])

    def wait(self):
        [None, exitCodes] = os.wait()
        exitStatus = os.WIFEXITED(exitCodes) and os.WEXITSTATUS(exitCodes)
        exitSignal = os.WIFSIGNALED(exitCodes) and os.WTERMSIG(exitCodes)
        return [exitStatus, exitSignal]

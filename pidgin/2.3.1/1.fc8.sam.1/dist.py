import sys
sys.path[1:1] = ['/s/scons/lib/scons']
from SCons.Action import Action
from SCons.Builder import Builder
from SCons.Util import splitext

from itertools import imap

import tarfile


def dist_action(target, source, env):
    distdir = splitext(splitext(str(target[0]))[0])[0]
    archive = tarfile.open(str(target[0]), 'w:gz')

    for member in sorted(map(str, source)):
        archive.add(member, distdir + '/' + member, False)

    archive.close()


def dist_string(target, source, env):
    return 'build distribution archive "%s" with %s members' % (target[0], len(source))


dist_builder = Builder(
    action=Action(dist_action, dist_string),
    multi=True,
    )


def generate(env):
    env.AppendUnique(BUILDERS={
        'Dist': dist_builder,
        })

def exists(env):
    return True

from SCons.Action import Action
from SCons.Builder import Builder


def __instantiate_old(target, source, env):
    source = file(str(source[0]))
    target = file(str(target[0]), 'w')

    for line in source:
        print >>target, env.subst(line)


def __instantiate(target, source, env):
    source = source[0].get_contents()
    target = file(str(target[0]), 'w')
    instance = env.subst(source)
    print >>target, instance


__instantiate_action = Action(__instantiate, varlist=['prefix', 'version'])


__template_builder = Builder(
    action=__instantiate_action,
    src_suffix=['.template'],
    single_source=True,
    )


def generate(env):
    env.AppendUnique(BUILDERS={
        'Template': __template_builder,
        })

def exists(env):
    return True

from string import Template


class AtTemplate(Template):

    delimiter = '@'

    pattern = r"""
    (?:
    (?P<escaped>@@) |
    (?P<named>(?!)) |
    @(?P<braced>%(id)s)@ |
    (?P<invalid>(?!))
    )
    """ % {'id': Template.idpattern}


def instantiate(source, sink, **kwargs):
    source = file(source)
    sink = file(sink, 'w')
    for line in source:
        sink.write(AtTemplate(line).substitute(kwargs))
    sink.close()

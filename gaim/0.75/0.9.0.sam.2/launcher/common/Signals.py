import new
import types


def __fill_callbacks(self, kind, callbacks):
    members = kind.__dict__
    for name in members:
        if name.startswith('on_') and not name in callbacks:
            value = members[name]
            if type(value) == types.FunctionType:
                callbacks[name] = new.instancemethod(value, self, self.__class__)

    for base in kind.__bases__:
        __fill_callbacks(self, base, callbacks)


def autoconnect(self, xml):
    callbacks = {}
    __fill_callbacks(self, self.__class__, callbacks)
    xml.signal_autoconnect(callbacks)

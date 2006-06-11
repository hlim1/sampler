import bonobo


class Factory(bonobo.GenericFactory):

    __slots__ = []
    __pychecker__ = 'no-emptyslots'

    def __builder(self, factory, product):
        __pychecker__ = 'no-argsused'
        import monitor
        return monitor.Monitor()

    def __init__(self):
        bonobo.GenericFactory.__init__(self, 'OAFIID:SamplerMonitor_Factory:0.1', self.__builder)
        bonobo.running_context_auto_exit_unref(self)

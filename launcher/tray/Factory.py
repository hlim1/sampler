import bonobo


class Factory(bonobo.GenericFactory):
    def __builder(self, factory, product):
        import monitor
        return monitor.Monitor()

    def __init__(self):
        bonobo.GenericFactory.__init__(self, 'OAFIID:SamplerMonitor_Factory:0.1', self.__builder)
        bonobo.running_context_auto_exit_unref(self)

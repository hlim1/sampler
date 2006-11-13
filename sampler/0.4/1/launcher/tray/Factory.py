import bonobo

import Config
import monitor


class Factory(bonobo.GenericFactory):
    def __builder(self, factory, product):
        return monitor.Monitor()

    def __init__(self):
        bonobo.GenericFactory.__init__(self, 'OAFIID:SamplerMonitor_Factory:' + Config.version, self.__builder)
        bonobo.running_context_auto_exit_unref(self)

import bonobo

import sampler


class Factory(bonobo.GenericFactory):
    def __builder(self, factory, product):
        return sampler.Monitor()

    def __init__(self):
        bonobo.GenericFactory.__init__(self, "OAFIID:SamplerMonitor_Factory:1.0", self.__builder)
        bonobo.running_context_auto_exit_unref(self)

import bonobo
import gconf

from ReportCollector import ReportCollector

import Keys


class Factory(bonobo.GenericFactory):
    def __builder(self, factory, product):
        if self.__client.get_bool(Keys.asked):
            if self.__client.get_bool(Keys.master):
                return ReportCollector()

    def __init__(self, client):
        bonobo.GenericFactory.__init__(self, "OAFIID:SamplerReportCollector_Factory:1.0", self.__builder)
        bonobo.running_context_auto_exit_unref(self)

        self.__client = client

import sampler


class ReportCollector(sampler.ReportCollector):

    def sparsity(self, *args):
        print 'python: sparsity:', args
        return 197

    def reportUnit(self, *args):
        print 'python: reportUnit:', args

    def exitStatus(self, status):
        print 'python: exitStatus:', status

    def exitSignal(self, signal):
        print 'python: exitSignal:', signal

    def __init__(self):
        sampler.ReportCollector.__init__(self,
                                         sparsity = self.sparsity,
                                         reportUnit = self.reportUnit,
                                         exitStatus = self.exitStatus,
                                         exitSignal = self.exitSignal)

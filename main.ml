let splitter = new SplitAfterCalls.visitor
and weigher = new WeighPaths.visitor in
ignore(TestHarness.main [splitter; weigher])

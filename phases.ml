open Cil


let main transformer =
  let phases =
    [
     Choices.phase;
     transformer;
     "RemoveUnusedTemps", Rmtmps.removeUnusedTemps;
     FilterLabels.phase;
     "dump", dumpFile (new Printer.printer) stdout
   ]
  in
  
  ignore(TestHarness.main phases)

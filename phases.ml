open Cil


let main transformer =
  let phases =
    [
     transformer;
     "RemoveUnusedTemps", Rmtmps.removeUnusedTemps;
     FilterLabels.phase;
     "dump", dumpFile defaultCilPrinter stdout
   ]
  in
  
  ignore(TestHarness.main phases)

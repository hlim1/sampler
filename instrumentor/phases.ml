open Cil


let main transformer =
  let phases =
    [
     Choices.phase;
     transformer;
     "RemoveUnusedTemps", (fun file -> Rmtmps.removeUnusedTemps file);
     FilterLabels.phase;
     "dump", dumpFile (new Printer.printer) stdout
   ]
  in
  
  TestHarness.main phases

open Cil

let phases =
  [
   Transform.phase;
   "RemoveUnusedTemps", Rmtmps.removeUnusedTemps;
   FilterLabels.phase;
   "dump", dumpFile defaultCilPrinter stdout
 ]
    
;;

ignore(TestHarness.main phases)

open Cil

let phases =
  [
   Countdown.phase;
   SkipLog.phase;
   Transform.phase;
   "RemoveUnusedTemps", Rmtmps.removeUnusedTemps;
   FilterLabels.phase;
   "dump", dumpFile defaultCilPrinter stdout
 ]
    
;;

ignore(TestHarness.main phases)

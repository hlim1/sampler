open Cil

let phases =
  [
   Countdown.phase;
   LogWrite.phase;
   SkipWrite.phase;
   Transform.phase;
   "RemoveUnusedTemps", Rmtmps.removeUnusedTemps;
   FilterLabels.phase;
   "dump", dumpFile defaultCilPrinter stdout
 ]
    
;;

ignore(TestHarness.main phases)

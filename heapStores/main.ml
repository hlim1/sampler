open Cil

let phases =
  [
   Countdown.phase;
   LogWrite.phase;
   SkipWrite.phase;
   HeapStoresTransform.phase;
   "RemoveUnusedTemps", Rmtmps.removeUnusedTemps;
   FilterLabels.phase;
   "dump", dumpFile defaultCilPrinter stdout
 ]
    
;;

ignore(TestHarness.main phases)

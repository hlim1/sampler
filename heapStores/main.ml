open Cil

let phases =
  [
   LogWrite.phase;
   HeapStoresTransform.phase;
   "RemoveUnusedTemps", Rmtmps.removeUnusedTemps;
   FilterLabels.phase;
   "dump", dumpFile defaultCilPrinter stdout
 ]
    
;;

ignore(TestHarness.main phases)

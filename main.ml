open Cil

let phases =
  [
   LogIsImminent.phase;
   LogSkip.phase;
   LogWrite.phase;
   Transform.phase;
   "dump", dumpFile defaultCilPrinter stdout
 ]
    
;;

ignore(TestHarness.main phases)

open Cil

let phases =
  [
   Countdown.phase;
   LogWrite.phase;
   Transform.phase;
   "dump", dumpFile defaultCilPrinter stdout
 ]
    
;;

ignore(TestHarness.main phases)

open Cil

let phases =
  [
   Transform.phase ();
   "dump", dumpFile defaultCilPrinter stdout
 ]
    
;;

ignore(TestHarness.main phases)

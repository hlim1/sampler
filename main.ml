open Cil

let phases =
  [
   SimplifyReturns.phase ();
   SimplifyLefts.phase ();
   SimplifyRights.phase ();
   CheckSimplicity.phase ();
   Instrument.phase ();
   "dump", dumpFile defaultCilPrinter stdout
 ]
    
;;

ignore(TestHarness.main phases)

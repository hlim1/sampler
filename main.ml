open Cil

let phases =
  [
   SimplifyReturns.phase ();
   SimplifyLefts.phase ();
   SimplifyRights.phase ();
   CheckSimplicity.phase ();
   Transform.phase ();
   "dump", dumpFile defaultCilPrinter stdout
 ]
    
;;

ignore(TestHarness.main phases)

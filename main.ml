open Cil

let stages =
  [
   visitCilFileSameGlobals new SimplifyReturns.visitor;
   visitCilFileSameGlobals new SimplifyLefts.visitor;
   visitCilFileSameGlobals new SimplifyRights.visitor;
   visitCilFileSameGlobals new CheckSimplicity.visitor;
   Instrument.addPrototype;
   visitCilFileSameGlobals new Instrument.visitor;
   dumpFile defaultCilPrinter stdout
 ]
    
;;

ignore(TestHarness.main stages)

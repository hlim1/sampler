open Cil

let main visitor =
  let file = Frontc.parse "hello.i" () in
  Rmtmps.removeUnusedTemps file;

  visitCilFileSameGlobals (visitor :> cilVisitor) file;
  file

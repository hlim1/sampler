open Cil
open Arg


let main preparator =
  let phases =
    [
     Choices.phase;
     "Transform", Interproc.visit preparator;
     "RemoveUnusedTemps", (fun file -> Rmtmps.removeUnusedTemps file);
     Options.phase;
     "dump", dumpFile (new Printer.printer) stdout
   ]
  in
  
  initCIL ();
  parse (Options.argspecs ())
    (TestHarness.doOne phases)
    ("Usage:" ^ Sys.executable_name ^ " [<flag> | <source>] ...")

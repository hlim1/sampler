open Cil
open Arg


let main manager =
  let phases =
    [
     "Transform", (fun file -> (manager file)#visit);
     Idents.phase;
     "dump", dumpFile (new Printer.printer) stdout
   ]
  in
  
  initCIL ();
  parse (Options.argspecs ())
    (TestHarness.doOne phases)
    ("Usage:" ^ Sys.executable_name ^ " [<flag> | <source>] ...")

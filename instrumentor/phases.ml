open Cil


let main manager =
  let phases =
    [
     "removing unused symbols", (fun file -> Rmtmps.removeUnusedTemps file);
     "instrumenting", (fun file -> ignore (manager file));
     "removind unused symbols", (fun file -> Rmtmps.removeUnusedTemps file);
     Idents.phase;
     "printing transformed code", dumpFile (new Printer.printer) stdout
   ]
  in
  
  initCIL ();
  Arg.parse (Options.argspecs ())
    (TestHarness.doOne phases)
    ("Usage:" ^ Sys.executable_name ^ " [<flag> | <source>] ...")

open Cil


let main manager =
  let phases =
    [
     Unused.removeUnusedFunctions;
     (fun file -> ignore (manager file));
     (fun file -> Rmtmps.removeUnusedTemps file);
     Idents.phase;
     dumpFile (new Printer.printer) stdout
   ]
  in
  
  initCIL ();
  Arg.parse (Options.argspecs ())
    (TestHarness.doOne phases)
    ("Usage:" ^ Sys.executable_name ^ " [<flag> | <source>] ...")

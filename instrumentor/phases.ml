open Cil


let main manager =
  let phases =
    [
     Unused.removeUnusedFunctions;
     (fun file -> (manager file)#visit);
     (fun file -> Rmtmps.removeUnusedTemps file);
     Idents.phase;
     dumpFile (new Printer.printer) stdout
   ]
  in
  
  initCIL ();
  Arg.parse (Options.argspecs ())
    (TestHarness.doOne phases)
    ("Usage:" ^ Sys.executable_name ^ " [<flag> | <source>] ...")

open Cil


let main manager =
  let phases =
    [
     "Rmtmps", (fun file -> Rmtmps.removeUnusedTemps file);
     "Transform", (fun file -> (manager file)#visit);
     (* add another Rmtmps phase here? *)
     Idents.phase;
     "dump", dumpFile (new Printer.printer) stdout
   ]
  in
  
  initCIL ();
  Arg.parse (Options.argspecs ())
    (TestHarness.doOne phases)
    ("Usage:" ^ Sys.executable_name ^ " [<flag> | <source>] ...")

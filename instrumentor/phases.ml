open Cil


let _ = Version.require


let main manager =
  let phases =
    [
     "removing unused symbols (early)", (fun file -> Rmtmps.removeUnusedTemps file);
     "instrumenting", (fun file -> ignore (manager file));
     "removing unused symbols (late)", (fun file -> Rmtmps.removeUnusedTemps file);
     Idents.phase;
     "printing transformed code", dumpFile (new Printer.printer) stdout
   ]
  in
  
  initCIL ();
  lineDirectiveStyle := Some LinePreprocessorOutput;

  Arg.parse (Options.argspecs ())
    (TestHarness.doOne phases)
    ("Usage:" ^ Sys.executable_name ^ " [<flag> | <source>] ...")

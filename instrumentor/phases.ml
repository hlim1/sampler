open Cil


let main manager =
  let phases =
    [
     "removing unused symbols", (fun file -> Rmtmps.removeUnusedTemps file);
     "embedding control flow graph", EmbedCFG.visit;
     "instrumenting", (fun file -> ignore (manager file));
     "removind unused symbols", (fun file -> Rmtmps.removeUnusedTemps file);
     Idents.phase;
     "printing transformed code", dumpFile (new Printer.printer) stdout
   ]
  in
  
  initCIL ();
  lineDirectiveStyle := Some LinePreprocessorOutput;

  Arg.parse (Options.argspecs ())
    (TestHarness.doOne phases)
    ("Usage:" ^ Sys.executable_name ^ " [<flag> | <source>] ...")

open Cil


let _ =

  let phases =
    [
     "removing unused symbols (early)", (fun file -> Rmtmps.removeUnusedTemps file);
     Instrumentor.phase;
     "removing unused symbols (late)", (fun file -> Rmtmps.removeUnusedTemps file);
     Idents.phase;
     "printing transformed code", dumpFile (new Printer.printer) stdout
   ]
  in

  initCIL ();
  Ptranal.conservative_undefineds := false;
  lineDirectiveStyle := Some LinePreprocessorOutput;

  NothingScheme.register ();
  ScalarPairScheme.register ();
  BranchScheme.register ();
  ReturnScheme.register ();

  Arg.parse (Options.argspecs ())
    (TestHarness.doOne phases)
    ("Usage:" ^ Sys.executable_name ^ " [<flag> | <source>] ...")

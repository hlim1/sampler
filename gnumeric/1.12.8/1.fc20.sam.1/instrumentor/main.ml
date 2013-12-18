open Cil


let _ =

  try
    let phases =
      [
       "removing unused symbols (early)", (fun file -> Rmtmps.removeUnusedTemps file);
       Locals.rename;
       Instrumentor.phase;
       "removing unused symbols (late)", (fun file -> Rmtmps.removeUnusedTemps file);
       Idents.phase;
       "printing transformed code", (dumpFile (new Printer.printer) stdout "")
     ]
    in

    initCIL ();
    lineDirectiveStyle := Some LinePreprocessorOutput;
    assert (not !useCaseRange);
    assert (not !useComputedGoto);

    (* back-ported from CIL; can be removed for CIL 1.4.1+ *)
    let addSwap sizeInBits =
      try
	let name = Printf.sprintf "__builtin_bswap%d" sizeInBits in
	if not (Hashtbl.mem builtinFunctions name) then
	  begin
	    assert (sizeInBits mod 8 = 0);
	    let sizeInBytes = sizeInBits / 8 in
	    let sizedIntType = TInt (intKindForSize sizeInBytes false, []) in
	    Hashtbl.add builtinFunctions name (sizedIntType, [ sizedIntType ], false)
	  end
      with Not_found ->
	()
    in
    addSwap 32;
    addSwap 64;

    (* back-ported from CIL; can be removed for CIL 1.4.1+ *)
    List.iter (fun attr -> Hashtbl.add attributeHash attr (AttrFunType false))
      [
       "artificial";
       "leaf";
       "nonnull";
       "warn_unused_result";
     ];

    Arg.parse (Options.argspecs ())
      (TestHarness.doOne phases)
      ("Usage:" ^ Sys.executable_name ^ " [<flag> | <source>] ...")

  with Errormsg.Error ->
    exit 2

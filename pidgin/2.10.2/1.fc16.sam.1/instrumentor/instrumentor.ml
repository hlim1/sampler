open Cil
open Scanners
open TestHarness


let sample =
  Options.registerBoolean
    ~flag:"sample"
    ~desc:"randomly sample instrumentation sites at run time"
    ~ident:"Sample"
    ~default:true

let impls = Implications.getAccumulator

let schemes = [
  ScalarPairScheme.factory impls;
  YieldScheme.factory;
  AtomScheme.factory;
  BranchScheme.factory;
  BoundScheme.factory;
  FunctionEntryScheme.factory;
  ReturnScheme.factory;
  FloatKindScheme.factory;
  GObjectUnrefScheme.factory;
  FunReentryScheme.factory;
  CompareSwapScheme.factory;
  AtomRWScheme.factory;
]

let moveFnsToEndIfNeeded file =
  let handle g =
    match g with
    | GFun (fdec, loc) when BranchFinder.shouldMoveToEnd fdec ->
        ignore (Pretty.eprintf "==== Moving %s to the end\n" fdec.svar.vname);
        let newVD = GVarDecl (fdec.svar, loc) in
        (newVD, [g])
    | _ -> (g, [])
  in
  let globals, epilogue = List.split (List.rev_map handle file.globals) in
  let globals = List.rev globals in
  let epilogue = List.flatten epilogue in
  file.globals <- globals @ epilogue;
  ()

let phase =
  "instrumenting",
  fun file ->
    Dynamic.analyze file;
    FunctionFilter.filter#collectPragmas file;
    SharedAccesses.isolate file;
    iterFuncs file IsolateInstructions.visit;
    Blast.markTerminations file;
    iterFuncs file ElaborateIfs.visit;

    let schemes = List.map (fun scheme -> scheme file) schemes in
    List.iter (fun scheme -> scheme#findAllSites) schemes;
    moveFnsToEndIfNeeded file;

    let digest = lazy (Digest.file file.fileName) in
    EmbedSignature.visit file digest;
    EmbedCFG.visit file digest;
    EmbedDataflow.visit file digest;
    EmbedSiteInfo.visit schemes digest;
    EmbedImplications.visit ((Lazy.force impls)#getInfos ()) digest;
    AddResetCode.visit file;

    if !sample then
      begin
	let tester = Weighty.collect file in
	let countdown = new Countdown.countdown file in
	time "loading site scales" Sites.setScales;
	time "applying sampling transformation"
	  (fun () -> Transformer.visit file tester countdown)
      end;

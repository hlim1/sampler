open Cil
open Scanners


let sample =
  Options.registerBoolean
    ~flag:"sample"
    ~desc:"randomly sample instrumentation sites at run time"
    ~ident:"Sample"
    ~default:true


let schemes = [
  ScalarPairScheme.factory;
  BranchScheme.factory;
  ReturnScheme.factory;
]


let phase =
  "instrumenting",
  fun file ->
    Dynamic.analyze file;
    FunctionFilter.filter#collectPragmas file;

    iterFuncs file RemoveLoops.visit;
    iterFuncs file IsolateInstructions.visit;

    let schemes = List.map (fun scheme -> scheme file) schemes in
    List.iter (fun scheme -> scheme#findAllSites) schemes;

    let digest = lazy (Digest.file file.fileName) in
    EmbedSignature.visit file digest;
    EmbedCFG.visit file digest;
    List.iter (fun scheme -> scheme#embedInfo digest) schemes;

    if !sample then
      begin
	let tester = Weighty.collect file in
	let countdown = new Countdown.countdown file in
	TestHarness.time "  applying sampling transformation"
	  (fun () -> Transform.visit file tester countdown)
      end

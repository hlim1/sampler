open Cil


let sample =
  Options.registerBoolean
    ~flag:"sample"
    ~desc:"randomly sample instrumentation sites at run time"
    ~ident:"Sample"
    ~default:true


let schemes = ref []


let addScheme scheme =
  schemes := scheme :: !schemes


let phase =
  "instrumening",
  fun file ->
    Dynamic.analyze file;
    FunctionFilter.filter#collectPragmas file;

    let schemes = List.map (fun scheme -> scheme file) !schemes in
    List.iter (fun scheme -> scheme#findAllSites) schemes;

    let digest = lazy (Digest.file file.fileName) in
    EmbedCFG.visit file digest;
    List.iter (fun scheme -> scheme#embedInfo digest) schemes;

    if !sample then
      begin
	let tester = Weighty.collect file in
	let countdown = new Countdown.countdown file in
	TestHarness.time "  applying sampling transformation"
	  (fun () -> Transform.visit file tester countdown)
      end

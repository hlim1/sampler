open Cil
open FuncInfo
open Idents
 

(**********************************************************************)


let sample =
  Options.registerBoolean
    ~flag:"sample"
    ~desc:"randomly sample instrumentation sites at run time"
    ~ident:"Sample"
    ~default:true


(**********************************************************************)


class virtual visitor schemeName file =
  object (self)
    method private virtual statementClassifier : fundec -> Classifier.visitor

    method private classifyStatements func =
      let visitor = self#statementClassifier func in
      ignore (visitCilFunction (visitor :> cilVisitor) func);
      visitor#sites

    method private finalize = ignore

    initializer
      Idents.register ("Scheme", fun () -> schemeName);
      Dynamic.analyze file;
      FunctionFilter.filter#collectPragmas file;

      let allSites =
	TestHarness.time "  classifying / inserting instrumentation"
	  (fun () ->
	    let folder others = function
	      | GFun (func, _) ->
		  begin
		    match self#classifyStatements func with
		    | [] -> others
		    | sites -> (func, sites) :: others
		  end
	      | _ ->
		  others
	    in
	    foldGlobals file folder [])
      in

      let digest = lazy (Digest.file file.fileName) in
      TestHarness.time "  embedding CFG" (fun () -> EmbedCFG.visit file digest);
      TestHarness.time "  finalizing" (fun () -> self#finalize digest);

      if !sample then
	begin
	  let tester = Weighty.collect file allSites in
	  let countdown = new Countdown.countdown file in
	  TestHarness.time "  applying sampling transformation"
	  (fun () -> List.iter (Transform.visit tester countdown) allSites)
	end
  end

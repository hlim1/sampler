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

    method private finalize = ()

    initializer
      Idents.register ("Scheme", fun () -> schemeName);
      Dynamic.analyze file;
      FunctionFilter.filter#collectPragmas file;

      let allSites =
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
	foldGlobals file folder []
      in

      EmbedCFG.visit file;
      self#finalize;

      if !sample then
	begin
	  let tester = Weighty.collect file allSites in
	  let countdown = new Countdown.countdown file in
	  List.iter (Transform.visit tester countdown) allSites
	end
  end

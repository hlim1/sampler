open Cil
open FuncInfo
 

(**********************************************************************)


let sample =
  Options.registerBoolean
    ~flag:"sample"
    ~desc:"randomly sample instrumentation sites at run time"
    ~ident:"Sample"
    ~default:true


(**********************************************************************)


class virtual visitor file =
  object (self)
    method private virtual statementClassifier : fundec -> Classifier.visitor

    method private classifyStatements func =
      let visitor = self#statementClassifier func in
      ignore (visitCilFunction (visitor :> cilVisitor) func);
      { sites = visitor#sites;
	calls = visitor#calls }

    method private finalize = ()

    initializer
      Dynamic.analyze file;
      FunctionFilter.collectPragmas file;

      let infos = new FileInfo.container in
      let iterator = function
	| GFun (func, _) ->
	    let info = self#classifyStatements func in
	    infos#add func info
	| _ -> ()
      in
      iterGlobals file iterator;

      if !sample then
	begin
	  let tester = Weighty.collect file infos in
	  let countdown = new Countdown.countdown file in
	  infos#iter (Transform.visit tester countdown)
	end;

      self#finalize
  end

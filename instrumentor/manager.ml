open Cil
open FuncInfo
 

(**********************************************************************)


let sample = ref true

let _ =
  Options.registerBoolean
    sample
    ~flag:"sample"
    ~desc:"randomly sample instrumentation sites at run time"
    ~ident:"Sample"


(**********************************************************************)


class virtual visitor file =
  object (self)
    val mutable infos = new FileInfo.container

    initializer
      Dynamic.analyze file

    method private virtual statementClassifier : fundec -> Classifier.visitor

    method private classifyStatements func =
      let visitor = self#statementClassifier func in
      ignore (visitCilFunction (visitor :> cilVisitor) func);
      { sites = visitor#sites;
	calls = visitor#calls }


    method private normalize func =
      prepareCFG func;
      RemoveLoops.visit func;
      IsolateInstructions.visit func;

    method private finalize =
      Rmtmps.removeUnusedTemps file


    method private shouldTransform =
      ShouldTransform.shouldTransform 

    method private iterator = function
      | GFun (func, _)
	when self#shouldTransform func ->
	  self#normalize func;
	  let info = self#classifyStatements func in
	  infos#add func info
      | _ ->
	  ()

    method visit =
      assert infos#isEmpty;
      iterGlobals file self#iterator;

      if !sample then
	begin
	  let tester = Weightless.collect infos in
	  let countdown = new Countdown.countdown file in
	  infos#iter (Transform.visit tester countdown)
	end;

      self#finalize
  end

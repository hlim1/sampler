open Cil
open FuncInfo
 

(**********************************************************************)

let fileFilter = ref []


let _ =
  Clude.register
    ~flag:"file"
    ~desc:"<file-name> instrument this file"
    ~ident:"FilterFile"
    fileFilter


let funcFilter = ref []


let _ =
  Clude.register
    ~flag:"function"
    ~desc:"<function> instrument this function"
    ~ident:"FilterFunction"
    funcFilter


let selected func site =
  Clude.selected !funcFilter func.svar.vname
    && Clude.selected !fileFilter (get_stmtLoc site.skind).file


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

      let sites =
	let unfiltered = visitor#sites in
	let folder sites site =
	  let location = get_stmtLoc site.skind in
	  if selected func site then
	    site :: sites
	  else
	    begin
	      site.skind <- Instr [];
	      sites
	    end
	in
	List.fold_left folder [] unfiltered
      in

      { sites = sites;
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

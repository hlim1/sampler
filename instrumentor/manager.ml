open Cil
open Clude
open FuncInfo
 

(**********************************************************************)

let fileFilter = ref []


let _ =
  Clude.register
    ~flag:"file"
    ~desc:"<file-name> instrument this file"
    ~ident:"FilterFile"
    fileFilter


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
    inherit SkipVisitor.visitor

    val mutable infos = new FileInfo.container


    method private virtual statementClassifier : fundec -> Classifier.visitor

    method private classifyStatements func =
      let visitor = self#statementClassifier func in
      ignore (visitCilFunction (visitor :> cilVisitor) func);

      let sites =
	let unfiltered = visitor#sites in
	let folder sites site =
	  let location = get_stmtLoc site.skind in
	  match filter !fileFilter location.file with
	  | Include ->
	      site :: sites
	  | Exclude ->
	      site.skind <- Instr [];
	      sites
	in
	List.fold_left folder [] unfiltered
      in

      { sites = sites;
	calls = visitor#calls;
	globals = visitor#globals }


    method private normalize func =
      prepareCFG func;
      RemoveLoops.visit func;
      IsolateInstructions.visit func;

    method private finalize =
      Rmtmps.removeUnusedTemps file


    method private shouldTransform =
      ShouldTransform.shouldTransform 

    method vglob = function
      | GFun (func, _) as global
	when self#shouldTransform func ->
	  self#normalize func;
	  let info = self#classifyStatements func in
	  infos#add func info;
	  ChangeTo (info.globals @ [global])
      | _ ->
	  SkipChildren

    method visit =
      assert infos#isEmpty;
      visitCilFile (self :> cilVisitor) file;

      if !sample then
	begin
	  let tester = Weightless.collect infos in
	  let countdown = new Countdown.countdown file in
	  infos#iter (Transform.visit tester countdown)
	end;

      self#finalize
  end

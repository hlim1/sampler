open Calls
open Cil
open FuncInfo
open Str


let assumeWeightlessExterns = ref false
let assumeWeightlessLibraries = ref true

let _ =
  Options.registerBoolean
    assumeWeightlessExterns
    ~flag:"assume-weightless-externs"
    ~desc:"assume that functions defined elsewhere have no sample sites"
    ~ident:"AssumeWeightlessExterns";

  Options.registerBoolean
    assumeWeightlessLibraries
    ~flag:"assume-weightless-libraries"
    ~desc:"assume that functions defined in libraries have no sample sites"
    ~ident:"AssumeWeightlessLibraries"


(**********************************************************************)


type tester = exp -> bool


type stmtMap = stmt list FunctionMap.container


let isBuiltin =
  let pattern = regexp "^__builtin_" in
  fun var -> 
    string_match pattern var.vname 0


let collect (infos : FileInfo.container) : tester =
  let weightless = new StringMap.container in

  let isWeightlessFunction callee =
    try
      weightless#find callee.vname
    with Not_found ->
      isBuiltin callee || !assumeWeightlessExterns
  in

  let isWeightlessCallee = function
    | Lval (Var callee, NoOffset) ->
	isWeightlessFunction callee
    | _ ->
	(* !!!: use points-to analysis here *)
	false
  in

  let isWeightlessCall info =
    isWeightlessCallee info.callee
  in

  if !assumeWeightlessLibraries then
    Libraries.functions#iter
      (fun symbol -> weightless#add symbol true);

  infos#iter
    (fun func info ->
      let assumption = (info.sites == []) in
      weightless#replace func.svar.vname assumption);

  Fixpoint.compute
    (fun madeProgress ->
      infos#iter
	(fun func info ->
	  if isWeightlessFunction func.svar then
	    if not (List.for_all isWeightlessCall info.calls) then
	      begin
		weightless#replace func.svar.vname false;
		madeProgress := true
	      end));

  if !Stats.showStats then
    begin
      let numFuncs, numWeightless =
	infos#fold
	  (fun func _ (numFuncs, numWeightless) ->
	    (numFuncs + 1,
	     if isWeightlessFunction func.svar then
	       numWeightless + 1
	     else
	       numWeightless))
	  (0, 0)
      in
      Printf.eprintf "stats: weightless: %d functions, %d weightless\n" numFuncs numWeightless
    end;

  infos#iter
    (fun func _ ->
      if isWeightlessFunction func.svar then
	infos#remove func);

  isWeightlessCallee

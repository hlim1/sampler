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


type tester = lval -> bool


type stmtMap = stmt list FunctionMap.container


let isBuiltin =
  let pattern = regexp "^__builtin_" in
  fun var -> 
    string_match pattern var.vname 0


let collect (infos : FileInfo.container) =
  let weightless = new StringMap.container in

  let isWeightlessVarinfo callee =
    try
      weightless#find callee.vname
    with Not_found ->
      isBuiltin callee || !assumeWeightlessExterns
  in

  let isWeightlessLval callee =
    match Dynamic.resolve callee with
    | Dynamic.Unknown ->
	false
    | Dynamic.Known possibilities ->
	List.for_all isWeightlessVarinfo possibilities
  in

  let isWeightlessCall info =
    isWeightlessLval info.callee
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
	  if isWeightlessVarinfo func.svar then
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
	     if isWeightlessVarinfo func.svar then
	       numWeightless + 1
	     else
	       numWeightless))
	  (0, 0)
      in
      Printf.eprintf "stats: weightless: %d functions, %d weightless\n" numFuncs numWeightless
    end;

  infos#iter
    (fun func _ ->
      if isWeightlessVarinfo func.svar then
	infos#remove func);

  isWeightlessLval

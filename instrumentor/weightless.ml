open Calls
open Cil
open Prepare


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
    ~flag:"assume-loopless-libraries"
    ~desc:"assume that functions defined in libraries have no sample sites"
    ~ident:"AssumeWeightlessLibraries"


(**********************************************************************)


type tester = Calls.info -> bool


let collect infos =
  let weightless = new StringMap.container in

  let isWeightlessFunction callee =
    try
      weightless#find callee.vname
    with Not_found ->
      !assumeWeightlessExterns
  in

  let isWeightlessCall call =
    match call.callee with
    | Lval (Var callee, NoOffset) ->
	isWeightlessFunction callee
    | _ ->
	false
  in

  if !assumeWeightlessLibraries then
    Libraries.functions#iter
      (fun symbol -> weightless#add symbol true);

  infos#iter
    (fun func info ->
      let assumption = info.sites#isEmpty in
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

  infos#iter
    (fun func info ->
      if isWeightlessFunction func.svar then
	infos#remove func);

  isWeightlessCall

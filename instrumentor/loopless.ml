open Cil


exception FoundLoop


class visitor loopless changed =
  object (self)
    inherit FunctionBodyVisitor.visitor

    val mutable definitelyLoopless = true

    method vfunc func =
      if not (loopless#mem func.svar.vname) then
	begin
	  try
	    definitelyLoopless <- true;
	    ignore (visitCilBlock (self :> cilVisitor) func.sbody);
	    if definitelyLoopless then
	      begin
		loopless#add func.svar.vname true;
		changed := true
	      end
	  with FoundLoop ->
	    loopless#add func.svar.vname false;
	    changed := true
	end;
      SkipChildren

    method vstmt _ =
      DoChildren

    method vinst inst =
      begin
	match inst with
	| Call (_, Lval (Var callee, NoOffset), _, _) ->
	    begin
	      try
		if not (loopless#find callee.vname) then
		  raise FoundLoop
	      with Not_found ->
		definitelyLoopless <- false
	    end
	| Call _ ->
	    raise FoundLoop
	| _ ->
	    ()
      end;
      SkipChildren
  end


let assumeLooplessLibraries () =
  let loopless = new StringMap.container in
  Libraries.functions#iter (fun name -> loopless#add name true);
  List.iter loopless#remove ["bsearch"; "qsort"];
  loopless


let assumeLooplessExterns file =
  let loopless = new StringMap.container in

  iterGlobals file
    begin
      function
	| GVarDecl ({ vtype = TFun _; vname = vname }, _) ->
	    loopless#add vname true
	| _ -> ()
    end;

  iterGlobals file
    begin
      function
	| GFun ({ svar = { vname = vname }}, _) ->
	    loopless#remove vname
	| _ -> ()
    end;

  loopless


let loopless file =
  let loopless = assumeLooplessExterns file in

  let considerGlobal = function
    | GFun (func, _) ->
	prepareCFG func;
	RemoveLoops.visit func;
	ignore (computeCFGInfo func false);
	if snd (ClassifyJumps.visit func) != [] then
	  loopless#add func.svar.vname false
    | _ ->
	()
  in
  iterGlobals file considerGlobal;

  let changed = ref false in
  let visitor = new visitor loopless changed in
  let iterate () = visitCilFile visitor file in
  iterate ();
  while !changed do
    changed := false;
    iterate ()
  done;

  fun varinfo ->
    try
      loopless#find varinfo.vname
    with Not_found ->
      false


;;


initCIL ();

let process filename =
  let file = Frontc.parse filename () in
  let loopless = loopless file in
  let considerGlobal = function
    | GFun ({svar = varinfo}, _) ->
	Printf.printf "%s\t%b\n" varinfo.vname (loopless varinfo)
    | _ ->
	()
  in
  iterGlobals file considerGlobal
in
let filenames = List.tl (Array.to_list Sys.argv) in
List.iter process filenames

open Cil


let const = [Attrs.const]


let initField info name exp =
  try
    Field (getCompField info name, NoOffset), SingleInit exp
  with Not_found ->
    failwith ("cannot find field " ^ info.cname ^ "." ^ name)


let arrayType elementType length =
  TArray (elementType, Some (integer length), [])


let unsigned = kinteger IUInt


let makeCFGVar kind varinfo typ =
  let var = makeGlobalVar ("__CFG_" ^ kind ^ "_" ^ varinfo.vname) typ in
  var.vattr <- [Attr("section", [AStr ".debug_cfg"])];
  var


let visit file =
  let functionIndex = FunctionIndex.build file in

  let funcStruct = FindStruct.find "__CFG_func" file in
  let funcType = TComp (funcStruct, const) in

  let forwards = new VariableNameMap.container in
  let buildForward funcvar _ globals =
    let info = makeCFGVar "func" funcvar funcType in
    if funcvar.vstorage == Static then info.vstorage <- Static;
    forwards#add funcvar info;
    GVarDecl (info, locUnknown) :: globals
  in
  let forwardGlobals = functionIndex#fold buildForward [] in

  let buildCFG funcvar strongest globals =
    let funcInfo = forwards#find funcvar in
    match strongest with
    | FunctionIndex.Declared _ ->
	let init = makeZeroInit funcInfo.vtype in
	let definition = GVar (funcInfo, {init = Some init}, locUnknown) in
	funcInfo.vattr <- addAttribute (Attr ("weak", [])) funcInfo.vattr;
	definition :: globals
    | FunctionIndex.Defined fundec ->
	let initFunc nodeCount nodesInfo flowCount flowsInfo callCount callsInfo =
	  let initFuncField name = initField funcStruct name in
	  CompoundInit
	    (funcType,
	     [
	      initFuncField "name" (mkString funcvar.vname);
	      initFuncField "nodeCount" (integer (nodeCount + 1));
	      initFuncField "nodes" (StartOf (var nodesInfo));
	      initFuncField "flowCount" (integer flowCount);
	      initFuncField "flows" (StartOf (var flowsInfo));
	      initFuncField "callCount" (integer callCount);
	      initFuncField "calls" (StartOf (var callsInfo))
	    ])
	in
	let funcPtrType = TPtr (funcType, const) in
	let callsType = arrayType funcPtrType in

	let nodeStruct = FindStruct.find "__CFG_node" file in
	let nodeType = TComp (nodeStruct, const) in
	let initNode location =
	  let initNodeField name = initField nodeStruct name in
	  let line = if location.line == -1 then 0 else location.line in
	  CompoundInit (nodeType,
			[ initNodeField "file" (mkString location.file);
			  initNodeField "line" (unsigned line) ])
	in
	let nodesType = arrayType nodeType in

	let flowStruct = FindStruct.find "__CFG_flow" file in
	let flowType = TComp (flowStruct, const) in
	let initFlow start finish =
	  let initFlowField name = initField flowStruct name in
	  CompoundInit (flowType,
			[ initFlowField "start" (unsigned start);
			  initFlowField "finish" (unsigned finish) ])
	in
	let flowsType = arrayType flowType in

	let callStruct = FindStruct.find "__CFG_call" file in
	let callType = TComp (callStruct, const) in
	let initCall caller callee =
	  let initCallField name = initField callStruct name in
	  CompoundInit (callType,
			[ initCallField "caller" (unsigned caller);
			  initCallField "callee" (mkAddrOf (var callee)) ])
	in
	let callsType = arrayType callType in

	IsolateInstructions.visit fundec;
	let stmts =
	  prepareCFG fundec;
	  computeCFGInfo fundec false
	in

	let nodeCount = List.length stmts in
	let nodesType = nodesType (nodeCount + 1) in
	let nodesInfo = makeCFGVar "nodes" funcvar nodesType in
	nodesInfo.vstorage <- Static;

	let funcDecl = GVarDecl (funcInfo, locUnknown) in

	let nodeInits =
	  let folder nodeInits node =
	    let nodeInit = initNode (get_stmtLoc node.skind) in
	    let nodeOffset = Index (integer node.sid, NoOffset) in
	    (nodeOffset, nodeInit) :: nodeInits
	  in

	  let exitNodeInit =
	    Index (integer nodeCount, NoOffset),
	    initNode locUnknown
	  in
	  
	  List.fold_left folder [exitNodeInit] stmts
	in

	let nodesVar = GVar (nodesInfo,
			     {init = Some
				(CompoundInit
				   (nodesType, nodeInits))},
			     locUnknown)
	in

	let flowInits =
	  let folder flowInits stmt =
	    let initFlow = initFlow stmt.sid in
	    if stmt.succs == [] then
	      [initFlow nodeCount]
	    else
	      let folder flowInits succ = initFlow succ.sid :: flowInits in
	      List.fold_left folder flowInits stmt.succs
	  in
	  List.fold_left folder [] stmts
	in

	let flowCount = List.length flowInits in
	let flowsType = flowsType flowCount in
	let flowsInfo = makeCFGVar "flows" funcvar flowsType in
	flowsInfo.vstorage <- Static;

	let flowVar =
	  let inits = ArrayInit.build flowInits in
	  let init = CompoundInit (flowsType, inits) in
	  GVar (flowsInfo, {init = Some init}, locUnknown)
	in

	let callInits =
	  let folder callInits stmt =
	    let initCall = initCall stmt.sid in
	    match stmt.skind with
	    | Instr [Call (_, expr, _, _)] ->
		let callees = match expr with
		| Lval (Var varinfo, NoOffset) ->
		    [varinfo]
		| Lval (Mem (Lval lval), NoOffset) ->
		    Ptranal.resolve_lval lval
		| _ ->
		    failwith "weird call expression; expected non-offset lvalue"
		in
		(*
		   ignore (Pretty.eprintf "%a: call expression \"%a\" has %d possible referents: %a\n"
		   d_loc !currentLoc
		   d_exp expr
		   (List.length callees)
		   (Pretty.d_list ", " (fun () varinfo -> Pretty.text varinfo.vname)) callees);
		 *)
		let folder callInits callee =
		  initCall (forwards#find callee) :: callInits
		in
		List.fold_left folder callInits callees
	    | _ ->
		callInits
	  in
	  List.fold_left folder [] stmts
	in

	let callCount = List.length callInits in
	let callsType = callsType callCount in
	let callsInfo = makeCFGVar "calls" fundec.svar callsType in
	callsInfo.vstorage <- Static;

	let callVar =
	  let inits = ArrayInit.build callInits in
	  let init = CompoundInit (callsType, inits) in
	  GVar (callsInfo, {init = Some init}, locUnknown)
	in

	let funcInit = initFunc nodeCount nodesInfo flowCount flowsInfo callCount callsInfo in
	let funcVar = GVar (funcInfo, {init = Some funcInit}, locUnknown) in

	nodesVar :: flowVar :: callVar :: funcVar :: globals
  in
  let cfgGlobals = functionIndex#fold buildCFG [] in

  file.globals <- file.globals @ forwardGlobals @ cfgGlobals

open Cil


class visitor fundec tracker =
  object (self)
    inherit FunctionBodyVisitor.visitor

    method vstmt stmt =
      match stmt.skind with
      | Return (Some result, location) ->
	  let skinds =
	    match result with
	    | Lval (Var simple, NoOffset) ->
		[ Instr (tracker#update simple);
		  stmt.skind ]
	    | complex ->
		let temp = makeTempVar fundec tracker#typ in
		[ Instr (Set (var temp, complex, locUnknown)
			 :: tracker#update temp);
		  Return (Some (Lval (var temp)), location) ]
	  in
	  
	  let stmts = List.map mkStmt skinds in
	  stmt.skind <- Block (mkBlock stmts);
	  SkipChildren

      | _ ->
	  ();
	  DoChildren
  end


let transform fundec factory =
  let returnType, _, _, _ = splitFunctionTypeVI fundec.svar in
  if Tracker.trackable returnType then
    let tracker = factory "" returnType in
    let visitor = new visitor fundec tracker in
    ignore (visitCilBlock visitor fundec.sbody)

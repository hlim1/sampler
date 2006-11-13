open Cil


class visitor closure =
  let closurePtrFormal = ("",  TPtr (closure.vtype, []), []) in
  let closurePtr = mkAddrOf (var closure) in
  
  object
    inherit SkipVisitor.visitor

    val pointers = Stack.create
    method result = pointers

    method vglob global =
      match global with
      | GFun ({svar = {vtype = TFun (returnType, Some formals, false, attributes)}} as fundec, _) ->
	  let pointer =
	    let name = fundec.svar.vname ^ "$replacement" in
	    let formals = closurePtrFormal :: formals in
	    let typ = TPtr (TFun (returnType, Some formals, false, attributes), []) in
	    makeGlobalVar name typ
	  in
	  pointer.vstorage <- fundec.svar.vstorage;
	  Stack.push pointers (fundec.svar.vname, pointer);

	  let call =
	    let makeCall result =
	      let actuals = List.map (fun formal -> Lval (var formal)) fundec.sformals in
	      let actuals = closurePtr :: actuals in
	      mkStmtOneInstr (Call (result, Lval (var pointer), actuals, locUnknown))
	    in
	    if isVoidType returnType then
	      [makeCall None]
	    else
	      let result = var (makeTempVar fundec returnType) in
	      [makeCall (Some result);
	       mkStmt (Return (Some (Lval result), locUnknown))]
	  in

	  fundec.sbody <-
	    mkBlock [mkStmt (If (Lval (var pointer),
				 mkBlock call,
				 fundec.sbody,
				 locUnknown))];
	  ChangeTo [GVarDecl (pointer, locUnknown);
		    global]

      | _ ->
	  SkipChildren
  end


let visit file closure =
  let visitor = new visitor closure in
  visitCilFile (new visitor closure) file

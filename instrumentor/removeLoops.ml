open Cil


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt stmt =
      begin
	match stmt.skind with
	| Loop (block, location, Some continue, _) ->
	    let goto = mkStmt (Goto (ref continue, location)) in
	    block.bstmts <- block.bstmts @ [goto];
	    stmt.skind <- Block block;
	| Loop _ ->
	    ignore(bug "cannot remove loop without continue; call prepareCFG first")
	| _ -> ()
      end;
      DoChildren
  end


let phase = visitCilFileSameGlobals new visitor


let visit original =
  let replacement = visitCilFunction (new visitor) original in
  assert (replacement == original)

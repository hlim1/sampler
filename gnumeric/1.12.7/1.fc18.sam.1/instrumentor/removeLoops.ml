open Cil


let buildGoto =
  Labels.buildGoto (Labels.build "removeLoops")


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    method! vstmt stmt =
      begin
	match stmt with
	| { skind = Loop (block, location, _, _); _ } ->
	    let goto = mkStmt (buildGoto stmt location) in
	    block.bstmts <- block.bstmts @ [goto];
	    stmt.skind <- Block block
	| { skind = Break location; succs = []; _ } ->
	    stmt.skind <- Return (None, location)
	| { skind = Break location; succs = [target]; _ } ->
	    stmt.skind <- buildGoto target location
	| { skind = Break _; _ } ->
	    failwith "break cannot have more than one successor"
	| { skind = Continue location; succs = [target]; _ } ->
	    stmt.skind <- buildGoto target location
	| { skind = Continue _; _ } ->
	    failwith "continue must have exactly one successor"
	| _ -> ()
      end;
      DoChildren

    method! vfunc func =
      CfgUtils.build func;
      DoChildren
  end


let visit original =
  let replacement = visitCilFunction (new visitor) original in
  assert (replacement == original)

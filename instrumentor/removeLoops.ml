open Cil


let buildLabel = Labels.build "removeLoops"


let buildGoto =
  let nextId = ref 0 in
  fun target location ->
    Labels.ensureHasGotoLabel target buildLabel;
    Goto (ref target, location)


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt stmt =
      begin
	match stmt.skind with
	| Loop (block, location, _, _) ->
	    let goto = mkStmt (buildGoto stmt location) in
	    block.bstmts <- block.bstmts @ [goto];
	    stmt.skind <- Block block
	| Break location when stmt.succs = [] ->
	    stmt.skind <- Return (None, location)
	| Break location
	| Continue location ->
	    begin
	      match stmt.succs with
	      | [target] -> stmt.skind <- buildGoto target location
	      | _ -> failwith "break or continue must have exactly one successor"
	    end
	| _ -> ()
      end;
      DoChildren

    method vfunc func =
      Cfg.build func;
      DoChildren
  end


let phase = visitCilFileSameGlobals new visitor


let visit original =
  let replacement = visitCilFunction (new visitor) original in
  assert (replacement == original)

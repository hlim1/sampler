open Cil


class visitor =
  object
    inherit FunctionBodyVisitor.visitor
	
    method vstmt statement =
      match statement.skind with
      | Instr (_ :: _ :: _ as instructions) ->
	  let statements = List.map mkStmtOneInstr instructions in
	  let block = mkBlock statements in
	  statement.skind <- Block block;
	  SkipChildren
      | _ ->
	  DoChildren
  end


let visit func =
  ignore (visitCilFunction new visitor func)


let isolated {skind = skind} =
  match skind with
  | Instr [singleton] ->
      Some singleton
  | Instr (_ :: _ :: _) ->
      ignore (bug "instr should have been atomized");
      failwith "internal error"
  | _ ->
      None

open Cil
open Classify


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt stmt =
      match classifyStatement stmt.skind with
      | Check ->
	  stmt.skind <- Instr [];
	  SkipChildren
      | _ ->
	  DoChildren
  end


let visit func =
  ignore (visitCilFunction (new visitor) func)

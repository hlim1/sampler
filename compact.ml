open Cil


class visitor file = object
  inherit FunctionBodyVisitor.visitor

  method vblock block =
    block.bstmts <- compactStmts block.bstmts;
    DoChildren
end


let phase =
  "Compact",
  fun file ->
    visitCilFileSameGlobals (new visitor file :> cilVisitor) file

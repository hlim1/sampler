open Cil


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    method vfunc func =
      prepareCFG func;
      SkipChildren
  end


let phase =
  "PrepareCfg",
  visitCilFileSameGlobals new visitor

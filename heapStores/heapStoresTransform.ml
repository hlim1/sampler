open Cil


class visitor = object
  inherit FunctionBodyVisitor.visitor

  method vfunc func =
    Simplify.visit func;
    Transform.transform Stores.count_stmt SkipWrites.visit func;
    SkipChildren
end


let phase =
  "Transform",
  visitCilFileSameGlobals new visitor

open Cil


class visitor = object
  inherit FunctionBodyVisitor.visitor

  val currentFunction = ref dummyFunDec

  method vfunc func =
    currentFunction := func;
    DoChildren

  method vstmt _ = DoChildren
end

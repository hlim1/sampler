open Cil


class virtual visitor = object
  inherit FunctionBodyVisitor.visitor

  val currentFunction = ref dummyFunDec

  method vfunc func =
    currentFunction := func;
    DoChildren

  method vstmt _ = DoChildren
end

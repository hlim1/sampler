open Cil


class virtual visitor = object(self)
  inherit FunctionBodyVisitor.visitor

  method virtual weigh : stmt -> int
  method virtual insertSkips : cilVisitor
  method virtual insertLogs : cilVisitor

  method vfunc func =
    Transform.transform
      self#weigh
      self#insertSkips
      self#insertLogs
      func;
    SkipChildren
end

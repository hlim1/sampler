open Cil


class virtual visitor : file -> object
  inherit cilVisitor
  method private virtual collector : fundec -> Collector.visitor
end

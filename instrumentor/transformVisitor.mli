open Cil


class virtual visitor : file -> object
  inherit cilVisitor
  method private virtual collector : fundec -> Collector.visitor
  method private prepatchCalls : fundec -> Calls.placeholders
  method private shouldTransform : fundec -> bool
  method private transform : fundec -> global list
end

open Cil


class visitor : file -> object
  inherit TransformVisitor.visitor
  method private collector : fundec -> Collector.visitor
end


val phase : TestHarness.phase

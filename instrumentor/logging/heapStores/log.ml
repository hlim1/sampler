open Cil


class visitor file =
  object
    inherit LogCollector.visitor file

    method private collectOutputs = FindOutputs.collect
    method private placeInstrumentation code log = [log; code]
  end


let collect file =
  let visitor = new visitor file in
  fun func ->
    Simplify.visit func;
    ignore (visitCilFunction (visitor :> cilVisitor) func);
    visitor#result

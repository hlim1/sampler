open Cil


class visitor file =
  object
    inherit LogCollector.visitor file

    method private collectOutputs = FindOutputs.collect
    method private placeInstrumentation code log = [code; log]
  end


let collect file =
  let visitor = new visitor file in
  fun func ->
    ignore (visitCilFunction (visitor :> cilVisitor) func);
    visitor#result

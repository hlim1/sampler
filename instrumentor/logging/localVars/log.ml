open Cil


class visitor file func =
  object
    inherit LogCollector.visitor file

    val outputs = Collect.collect func

    method private collectOutputs = FindOutputs.select outputs

    method private placeInstrumentation code log = [log; code]
  end


let collect file func =
  let visitor = new visitor file func in
  ignore (visitCilFunction (visitor :> cilVisitor) func);
  visitor#result

open Cil


class visitor file func =
  object
    inherit LogCollector.visitor file ()

    val outputs = Collect.collect func

    method private collectOutputs = FindOutputs.select outputs

    method private placeInstrumentation code log = [log; code]
  end

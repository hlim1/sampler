open Cil


class visitor file () =
  object
    inherit LogCollector.visitor file ()

    method private collectOutputs = FindOutputs.collect
    method private placeInstrumentation code log = [log; code]
  end

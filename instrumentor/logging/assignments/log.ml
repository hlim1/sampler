class visitor file =
  object
    inherit LogCollector.visitor file

    method private collectOutputs = FindOutputs.collect
    method private placeInstrumentation code log = [code; log]
  end

class visitor file func =
  object
    inherit LogCollector.visitor file

    method private collectOutputs = FindOutputs.collect
    method private placeInstrumentation code log = [log; code]

    initializer
      Simplify.visit func
  end

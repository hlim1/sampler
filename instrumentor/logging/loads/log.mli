open Cil


class visitor : file -> unit ->
  object
    inherit LogCollector.visitor

    method private collectOutputs : stmtkind -> OutputSet.container
    method private placeInstrumentation : stmt -> stmt -> stmt list
  end

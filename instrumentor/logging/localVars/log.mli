open Cil


class visitor : file -> fundec ->
  object
    inherit LogCollector.visitor

    method private collectOutputs : stmtkind -> OutputSet.container
    method private placeInstrumentation : stmt -> stmt -> stmt list
  end

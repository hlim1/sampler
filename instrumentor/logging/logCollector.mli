open Cil


class virtual visitor : file ->
  object
    inherit FunctionBodyVisitor.visitor

    method result : Sites.info

    method private virtual collectOutputs : stmtkind -> OutputSet.container
    method private virtual placeInstrumentation : stmt -> stmt -> stmt list
  end

open Cil


class virtual visitor : file -> unit ->
  object
    inherit Classifier.visitor

    method private virtual collectOutputs : stmtkind -> OutputSet.container
    method private virtual placeInstrumentation : stmt -> stmt -> stmt list
  end

open Cil


class virtual visitor : file -> unit ->
  object
    inherit Classifier.visitor

    method sites : stmt list
    method globals : global list

    method private virtual collectOutputs : stmtkind -> OutputSet.container
    method private virtual placeInstrumentation : stmt -> stmt -> stmt list
  end

open Cil


class virtual visitor : file -> object
  inherit cilVisitor

  val logger : Logger.builder

  method virtual collectOutputs : fundec -> stmtkind -> Sites.outputs
  method virtual placeInstrumentation : stmt -> stmt list -> stmt list

  method instrumentFunction : fundec -> global list
end

open Cil


class virtual visitor : file -> object
  inherit cilVisitor

  val logger : Logger.builder

  method virtual findSites : fundec -> Sites.visitor
  method virtual placeInstrumentation : stmt -> stmt list -> stmt list
end

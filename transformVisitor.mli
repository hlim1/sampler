open Cil


class virtual visitor : file -> object
  inherit cilVisitor

  method virtual findSites : fundec -> Sites.visitor
  method virtual placeInstrumentation : stmt -> stmt -> stmt list
end

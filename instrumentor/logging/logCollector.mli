open Cil


class virtual visitor : file -> object
  inherit Collector.visitor
  method private virtual collectOutputs : stmtkind -> OutputSet.container
  method private virtual placeInstrumentation : stmt -> stmt -> stmt list
end

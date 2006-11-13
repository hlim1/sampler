open Cil


val trackable : typ -> bool


class tracker : fundec -> string -> typ -> object
  method typ : typ
  method define : global list
  method update : varinfo -> instr list
end


type factory = string -> typ -> tracker

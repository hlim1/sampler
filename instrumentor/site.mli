open Cil


class virtual c : fundec ->
  object
    method virtual enact : stmt
  end


type index = stmt list FunctionNameHash.c

val enactAll : unit -> index

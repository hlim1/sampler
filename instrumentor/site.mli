open Cil


class virtual c : fundec -> stmt ->
  object
    method embodiment : stmt
  end


val all : c list ref FunctionNameHash.c

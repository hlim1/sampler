open Cil


class virtual c : fundec -> stmt ->
  object
    method embodiment : stmt
  end


val all : unit -> c StmtHash.c

open Cil


let registry = ref []

let count = ref 0


class virtual c (func : fundec) (embodiment : stmt) =
  object (self)
    initializer
      registry := (self :> c) :: !registry;
      incr count

    method embodiment = embodiment
  end


let all () =
  let hash = new StmtHash.c !count in
  List.iter (fun site -> hash#add site#embodiment site) !registry;
  hash

open Cil


let all = new FunctionNameHash.c 0

let count = ref 0


class virtual c func =
  let sites =
    let list = ref [] in
    all#add func list;
    incr count;
    list
  in

  object (self)
    initializer
      sites := (self :> c) :: !sites

    method virtual enact : stmt
  end


type index = stmt list FunctionNameHash.c

let enactAll () =
  let result = new FunctionNameHash.c !count in
  let enactFunctionSites host sites =
    let statements = List.map (fun site -> site#enact) !sites in
    result#add host statements
  in
  all#iter enactFunctionSites;
  result

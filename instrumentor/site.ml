open Cil


let hosts = new FunctionNameHash.c 0
let sites = new FunctionNameHash.c 0

let hostCount = ref 0


class virtual c host =
  object (self)
    initializer
      hosts#replace host ();
      sites#add host (self :> c);
      incr hostCount

    method virtual enact : stmt
  end


type index = stmt list FunctionNameHash.c

let enactAll () =
  let result = new FunctionNameHash.c !hostCount in
  let enactFunc host () =
    let sites = sites#findAll host in
    let enactments = List.map (fun site -> site#enact) sites in
    result#add host enactments
  in
  hosts#iter enactFunc;
  result

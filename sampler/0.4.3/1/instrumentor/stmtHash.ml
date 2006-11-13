open Cil


type t = stmt

let equal = (==)
    
let hash {sid = sid} =
  assert (sid != -1);
  sid

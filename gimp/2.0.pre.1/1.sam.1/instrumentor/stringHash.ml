open Cil


type t = string

let equal = (=)
    
let hash = Hashtbl.hash

open Cil


type t = varinfo

let equal = (==)

let hash {vname = vname} =
  StringHash.hash vname

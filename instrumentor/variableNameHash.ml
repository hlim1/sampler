open Cil


type t = varinfo

let equal a b = StringHash.equal a.vname b.vname

let hash {vname = vname} =
  StringHash.hash vname

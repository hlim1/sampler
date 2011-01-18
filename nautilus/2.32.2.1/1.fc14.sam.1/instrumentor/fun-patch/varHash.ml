open Cil


type t = varinfo
let equal = (==)
let hash {vid = vid} = vid

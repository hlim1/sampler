open Cil

type t = stmt
let compare a b = Pervasives.compare a.sid b.sid

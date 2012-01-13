open Cil


type clonesMap = (stmt * stmt) array


let findCloneOf pairs {sid; _} =
  snd pairs.(sid)

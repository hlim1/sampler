open Cil


let locationOf = function
  | Set (_, _, location)
  | Call (_, _, _, location)
  | Asm (_, _, _, _, _, location) ->
      location

open Cil


let bump file =
  let bumper = BumpSign.bump file in
  fun location exp ->
    bumper location exp zero

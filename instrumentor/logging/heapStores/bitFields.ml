open Cil


let rec present = function
  | Field ({fbitfield = Some _}, _) ->
      true
  | Field (_, suboffset)
  | Index (_, suboffset) ->
      present suboffset
  | NoOffset ->
      false


let absent offset = not (present offset)

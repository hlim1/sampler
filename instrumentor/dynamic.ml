open Cil
open Ptranal


let usePointsTo = ref false

let _ =
  Options.registerBoolean
    usePointsTo
    ~flag:"use-points-to"
    ~desc:"use a points-to analysis to resolve dynamic function calls"
    ~ident:"UsePointsTo"


let analyze =
  if !usePointsTo then
    analyze_file
  else
    ignore


let resolve = function
  | (Var varinfo, NoOffset) ->
      [varinfo]
  | _ ->
      []

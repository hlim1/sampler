open Cil
open OutputSet


type outputs = OutputSet.t

class map = [outputs] StmtMap.container


let collect collector cfg =
  let map = new map in
  let iterator statement =
    let outputs = collector statement.skind in
    if not (OutputSet.is_empty outputs) then
      map#add statement outputs
  in
  List.iter iterator cfg;
  map

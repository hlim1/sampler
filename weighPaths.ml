open Cil


class weightsMap = [int] StmtMap.container


let rec weigh sites headers =
  
  let cache = new weightsMap in

  let rec subweight succ =
    if List.mem succ headers then
      0
    else
      weight succ

  and weight node =
    try cache#find node with
      Not_found ->
	let myWeight = if sites#mem node then 1 else 0 in
	let maximize best succ = max best (subweight succ) in
	let maxChildWeight = List.fold_left maximize 0 node.succs in
	let total = myWeight + maxChildWeight in
	cache#add node total;
	total
  in

  let weights = new StmtMap.container in
  
  let record header =
    weights#add header (weight header)
  in
  
  List.iter record headers;
  weights

open Cil
open Printf


type weightsMap = int StmtMap.container


let rec weigh headers =
  
  let cache = new StmtMap.container in

  let rec subweight succ =
    if List.mem succ headers then
      0
    else
      weight succ

  and weight node =
    try cache#find node with
      Not_found ->
	let myWeight = Stores.count_stmt node in
	let childWeights = List.map subweight node.succs in
	let maxChildWeight = List.fold_left max 0 childWeights in
	let total = myWeight + maxChildWeight in
	cache#add node total;
	total
  in

  let weights = new StmtMap.container in

  let compute header =
    weights#add header (weight header)
  in
  
  eprintf "weighing %i headers\n" (List.length headers);
  List.iter compute headers;
  weights

open Cil


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
	let maximize best succ = max best (subweight succ) in
	let maxChildWeight = List.fold_left maximize 0 node.succs in
	let total = myWeight + maxChildWeight in
	cache#add node total;
	total
  in

  let weights = new StmtMap.container in
  let trivial = ref true in
  
  let compute header =
    let w = weight header in
    weights#add header w;
    if w != 0 then trivial := false;
    Printf.eprintf "weigher: CFG #%i has weight %i\n" header.sid w
  in
  
  List.iter compute headers;
  if !trivial then None else Some weights

open Cil


class weightsMap = [int] StmtIdHash.c 0


let rec weigh (sites : Site.c list) (headers : stmt list) =
  
  let siteSet = new StmtIdHash.c 0 in
  List.iter (fun site -> siteSet#add site#embodiment ()) sites;

  let cache = new weightsMap in

  let rec subweight succ =
    if List.mem succ headers then
      0
    else
      weight succ

  and weight node =
    try cache#find node with
      Not_found ->
	let myWeight = if siteSet#mem node then 1 else 0 in
	let maximize best succ = max best (subweight succ) in
	let maxChildWeight = List.fold_left maximize 0 node.succs in
	let total = myWeight + maxChildWeight in
	cache#add node total;
	total
  in

  let weights = new weightsMap in
  
  let record header =
    let weight = weight header in
    (* ignore (Pretty.eprintf "%a: weight %d@!" Utils.d_stmt header weight); *)
    weights#add header weight
  in
  
  List.iter record headers;
  weights

open Cil
open Site
open Weight


class weightsMap = [t] StmtIdHash.c 0


let weigh sites headers =
  
  let siteMap = new StmtIdHash.c 0 in
  List.iter
    (fun site ->
      siteMap#add site.statement site.scale)
    sites;

  let cache = new weightsMap in

  let rec subweight succ =
    if List.mem succ headers then
      weightless
    else
      weight succ

  and weight node =
    try cache#find node with
      Not_found ->
	let me =
	  try { threshold = siteMap#find node; count = 1; }
	  with Not_found -> weightless
	in
	let children =
	  let maximize best succ = max best (subweight succ) in
	  List.fold_left maximize weightless node.succs
	in
	let total = sum me children in
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

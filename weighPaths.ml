open Cil
open Printf


let rec weighPaths headers =
  
  let cache = new StmtMap.container in

  let rec subweight node succ =
    if headers#mem (node, succ) then
      0
    else
      weight succ

  and weight node =
    try cache#find node with
      Not_found ->
	let myWeight = Stores.count_stmt node in
	let childWeights = List.map (subweight node) node.succs in
	let maxChildWeight = List.fold_left max 0 childWeights in
	let total = myWeight + maxChildWeight in
	cache#add node total;
	total
  in

  let weights = new StmtMap.container in

  headers#iter begin
    fun (s, destination) ->
      weights#add destination (weight destination)
  end;

  weights
    
    
(**********************************************************************)
	  
	  
class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  method vfunc func =
    printf "  weighing %s()" func.svar.vname;
    print_newline ();
    
    let cfg = Cfg.cfg func in
    let headers = CollectHeaders.collectHeaders cfg in
    printf "    collected %i headers\n" headers#size;
    let weights = weighPaths headers in
    printf "    weighed %i paths\n" weights#size;
    if headers#size != weights#size then
      failwith "headers/weights size mismatch";

    let printWeight node weight =
      printf "    weight below %i: %i" node.sid weight;
      print_newline ()
    in

    weights#iter printWeight;
    SkipChildren
end

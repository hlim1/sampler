open Basics
open FlowGraph
open Known
open Types.Statement


type result = data


let parse =
  let location = Location.parse in

  let successors =
    let successor = integerTab in
    sequenceLine successor
  in

  let callees =
    let unknown =
      parser
	  [< ''?'; ''?'; ''?'; ''\n' >] -> ()
    in
    let known =
      let callee = wordTab in
      sequenceLine callee
    in
    parser
      | [< _ = unknown >] -> Unknown
      | [< callees = known >] -> Known callees
  in

  parser
      [< location = location;
	 successors = successors;
	 callees = callees >]
      ->
	{ location = location;
	  successors = successors;
	  callees = callees;
	}


let isReturn node =
  node.successors = []


let addNodes key data =
  graph#addNode (Before, key) data;
  graph#addNode (After, key) data


let addEdges statics ((func, _) as originKey) data =
  let addFlow destinationId =
    let destinationKey = (func, destinationId) in
    graph#addEdge (After, originKey) () (Before, destinationKey)
  in
  List.iter addFlow data.successors;

  let shortcut = ref false in

  begin
    match data.callees with
    | Unknown
    | Known [] ->
	shortcut := true

    | Known callees ->
	let addCall calleeName =
	  try
	    let callee =
	      try statics#find calleeName
	      with Not_found -> Symtab.externs#find calleeName
	    in

	    let entryNode = (fst callee, 0) in
	    graph#addEdge (Before, originKey) () (Before, entryNode);

	    let addReturnEdge return =
	      graph#addEdge (After, (fst callee, return)) () (After, originKey)
	    in
	    List.iter addReturnEdge (snd callee).Types.Function.returns

	  with Not_found ->
	    shortcut := true
	in
	List.iter addCall callees
  end;

  if !shortcut then
    graph#addEdge (Before, originKey) () (After, originKey)

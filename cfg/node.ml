open Basics
open Known
open Location
open Types


let noParent = {
  fid = -1;
  linkage = Static;
  name = "";
  start = { file = ""; line = -1 };
  nodes = [| |];
  callers = [];
  returns = [];
}


let p =
  let location = Location.p in

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
      let callee stream = Raw (wordTab stream) in
      sequenceLine callee
    in
    parser
      | [< _ = unknown >] -> Unknown
      | [< callees = known >] -> Known callees
  in

  parser
      [< location = location; successors = successors; callees = callees >] ->
	{ nid = Uid.next ();
	  location = location;
	  parent = noParent;
	  successors = [];
	  callees = callees;
	  visited = ClockMark.unmark ();
	}, successors


let fixParent func node =
  node.parent <- func


let fixSuccessors nodes (node, successors) =
  let fixer successor = nodes.(successor) in
  node.successors <- List.map fixer successors


let fixCallees environment node =
  match node.callees with
  | Unknown -> ()
  | Known callees ->
      let fixer callee =
	match callee with
	| Resolved _ -> callee
	| Raw symbol ->
	    try
	      let referent =
		try StringMap.M.find symbol environment.locals
		with Not_found -> StringMap.M.find symbol environment.globals
	      in
	      referent.callers <- node :: referent.callers;
	      Resolved referent
	    with Not_found ->
	      callee
      in
      node.callees <- Known (List.map fixer callees)


let isReturn node = node.successors = []


let addCallSuccessors node =
  match node.callees with
  | Unknown -> ()
  | Known callees ->
      let fixer = function
	| Raw _ -> ()
	| Resolved callee ->
	    node.successors <- callee.nodes.(0) :: node.successors
      in
      List.iter fixer callees

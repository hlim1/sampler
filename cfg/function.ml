open Basics
open Types


(**********************************************************************)


let p =
  let linkage = parser
    | [< ''-' >] -> Static
    | [< ''+' >] -> External
  in

  let name = wordTab in
  let location = Location.p in
  let rawNodes = sequenceLine Node.p in

  parser
      [< linkage = linkage; ''\t'; name = name; location = location; raws = rawNodes >] ->

	let nodesList = List.map fst raws in
	let nodes = Array.of_list nodesList in
	List.iter (Node.fixSuccessors nodes) raws;

	let callers = List.filter Node.isReturn nodesList in
	let func = {
	  fid = Uid.next ();
	  linkage = linkage;
	  name = name;
	  start = location;
	  nodes = nodes;
	  callers = callers;
	  returns = [];
	} in

	Array.iter (Node.fixParent func) nodes;
	func


(**********************************************************************)


let entry func = func.nodes.(0)


(**********************************************************************)


let emptySymtab = StringMap.M.empty


let collectAll symtab ({ name = name } as func) =
  if StringMap.M.mem name symtab then
    Printf.eprintf "duplicate symbol: %s\n" name;
  StringMap.M.add name func symtab


let collectExports symtab = function
  | { linkage = Static } -> symtab
  | { linkage = External } as export ->
      collectAll symtab export


let fixCallees environment func =
  let fixer = Node.fixCallees environment in
  Array.iter fixer func.nodes

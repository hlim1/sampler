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
  let nodes stream = Array.of_list (sequenceLine Node.p stream) in

  parser
      [< linkage = linkage; ''\t'; name = name; location = location; nodes = nodes >] ->
	Array.iter (Node.connect nodes) nodes;
	{ fid = Uid.next (); linkage = linkage; name = name; start = location; nodes = nodes }


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


let resolve environment func =
  let fixer = Node.resolve environment in
  Array.iter fixer func.nodes

open Basics
open Types


let p =
  let location = Location.p in

  let successors =
    let successor stream = ref (Raw (integerTab stream)) in
    sequenceLine successor
  in

  let callees =
    let unknown =
      parser
	  [< ''?'; ''?'; ''?'; ''\n' >] -> ()
    in
    let known =
      let callee stream = ref (Raw (wordTab stream)) in
      sequenceLine callee
    in
    parser
      | [< _ = unknown >] -> Unknown
      | [< callees = known >] -> Known callees
  in

  parser
      [< location = location; successors = successors; callees = callees >] ->
	{ nid = Uid.next (); location = location; successors = successors; callees = callees }


let connect nodes node =
  let fixer successor =
    match !successor with
    | Raw slot -> successor := Resolved nodes.(slot)
    | Resolved _ -> ()
  in
  List.iter fixer node.successors


let resolve { locals = locals; globals = globals } = function
  | { callees = Unknown } -> ()
  | { callees = Known callees } ->
      let fixer callee =
	match !callee with
	| Raw symbol ->
	    begin
	      try
		let referent =
		  try StringMap.M.find symbol locals
		  with Not_found -> StringMap.M.find symbol globals
		in
		callee := Resolved referent
	      with Not_found -> ()
	    end
	| Resolved _ -> ()
      in
      List.iter fixer callees

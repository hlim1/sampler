open Basics
open FlowGraph


type site = Types.Function.extension * Types.Statement.extension


exception Eliminate of site * site


let _ = Args.process ()


let sites =
  let parseOne = parser
      [< func = wordTab; id = integerLine >] ->
	(func, id)
  in
  let parseAll = sequence Stream.empty parseOne in

  let list = parseAll (Stream.of_channel stdin) in
  let table = new HashClass.t 2 in

  let insert ((func, id) as site) =
    try
      ignore (Find.findNode site);
      table#add site ()
    with Not_found ->
      Printf.eprintf "warning: invalid site: %s:%d\n" func id
  in
  List.iter insert list;
  table


let reach =
  Memoize.memoize (fun (a, b) ->
    let aNode = Find.findNode a in
    let bNode = Find.findNode b in
    Transitive.reach ignore graph#succ aNode bNode)


let iteration progress =
  let compare a b =
    let (aFunc, aId) = a in
    let (bFunc, bId) = b in
    let description = Printf.sprintf "reach %s:%d <-?-> %s:%d" aFunc aId bFunc bId in
    Phase.time description (fun () ->
      match (reach (a, b), reach (b, a)) with
      | (false, true) ->
	  raise (Eliminate (a, b))
      | (true, false) ->
	  raise (Eliminate (b, a))
      | (false, false)
      | (true, true) ->
	  ())
  in
  try
    sites#iter (fun a () ->
      sites#iter (fun b () ->
	compare a b))
  with Eliminate (((iFunc, iId) as inferior), ((sFunc, sId) as superior)) ->
    sites#remove inferior;
    Printf.eprintf "eliminate %s:%d as inferior to %s:%d\n"
      iFunc iId sFunc sId;
    progress := true


;;


Fixpoint.compute iteration;

sites#iter (fun (func, id) () ->
  Printf.printf "%s\t%d\n" func id)

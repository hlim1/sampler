open Basics


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
  List.iter (fun site -> table#add site ()) list;
  table


let reach (aFunc, aId) (bFunc, bId) =
  let aNode = Find.findNode aFunc aId in
  let bNode = Find.findNode bFunc bId in
  let result = Transitive.reach ignore FlowGraph.graph#succ aNode bNode in
  result


let iteration progress =
  let compare a b =
    (* good place for memoization *)
    match (reach a b, reach b a) with
    | (false, true) ->
	raise (Eliminate (a, b))
    | (true, false) ->
	raise (Eliminate (b, a))
    | (false, false)
    | (true, true) ->
	()
  in
  try
    sites#iter (fun a () ->
      sites#iter (fun b () ->
	compare a b))
  with Eliminate (((iFunc, iId) as inferior), ((sFunc, sId) as superior)) ->
    sites#remove inferior;
    Printf.printf "eliminate %s:%d as inferior to %s:%d\n"
      iFunc iId sFunc sId;
    progress := true


;;


Fixpoint.compute iteration;

sites#iter (fun (func, id) () ->
  Printf.printf "%s\t%d\n" func id)

open Known
open Types


exception Reached


let reach origin destination =

  let frontier = new QueueClass.container in
  ClockMark.reset ();

  let reached justification prior midpoint =
    Printf.printf "reached %d --> %d by %s via %d; looking for %d\n"
      origin.nid midpoint.nid
      justification prior.nid
      destination.nid;
    if midpoint == destination then
      raise Reached
    else if not (ClockMark.marked midpoint.visited) then
      begin
	midpoint.visited <- ClockMark.mark ();
	frontier#push midpoint
      end
  in

  try
    reached "seed" origin origin;

    while not frontier#isEmpty do
      let task = frontier#pop in

      let reachSuccessors justification node =
	List.iter (reached justification task) node.successors
      in

      if task.successors = [] then
	List.iter (reachSuccessors "return") task.parent.callers
      else
	reachSuccessors "successor" task;

      match task.callees with
      | Unknown -> ()
      | Known callees ->
	  let extendCall = function
	    | Raw _ ->
		()
	    | Resolved callee ->
		reached "callee" task callee.nodes.(0)
	  in
	  List.iter extendCall callees
    done;
    false

  with Reached ->
    true

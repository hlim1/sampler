exception Reached


let reach trace succ origin destination =
  let worklist = new QueueClass.container in
  let visited = HashClass.create 2 in

  let reached midpoint =
    trace midpoint;
    if midpoint = destination then
      raise Reached
    else if not (visited#mem midpoint) then
      begin
	visited#add midpoint ();
	worklist#push midpoint
      end
  in

  try
    reached origin;

    while not worklist#isEmpty do
      let frontier = worklist#pop in
      List.iter (fun edge -> reached (snd edge)) (succ frontier)
    done;

    false

  with Reached ->
    true

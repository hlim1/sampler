let _ = () in

Args.process ();

let reach fromFunc fromSlot toFunc toSlot =
  let origin = Find.findNode fromFunc fromSlot in
  let destination = Find.findNode toFunc toSlot in
  let result = Transitive.reach ignore FlowGraph.graph#succ origin destination in
  Printf.printf "(%s, %d) --> (%s, %d) == %b\n"
    fromFunc fromSlot
    toFunc toSlot
    result
in

reach "tiny" 0 "tiny" 3;
reach "tiny" 3 "tiny" 0;
reach "tiny" 0 "pong" 0;
reach "pong" 0 "tiny" 3

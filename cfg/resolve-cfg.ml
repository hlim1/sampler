let argSpecs = []


let objects = ref []


let doOne filename =
  let channel = open_in filename in
  let stream = Stream.of_channel channel in
  objects := (Object.parse filename stream) :: !objects


;;


Arg.parse argSpecs doOne
("Usage:" ^ Sys.executable_name ^ " <module>.cfg ...");
print_endline "done parsing";

List.iter Object.addNodes !objects;
List.iter Object.addEdges !objects;
print_endline "done building graph";

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

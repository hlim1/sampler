open FlowGraph

let graph = Args.process ()

let printNode out (split, (((obj, compilation), fname), sid)) =
  let split = match split with
  | Before -> "before"
  | After -> "after"
  in
  Printf.fprintf out "%s-%s-%s-%d-%s" obj compilation fname sid split

let printEdge out edge =
  output_string out
    (match edge with
    | Flow -> "flow"
    | Call -> "call"
    | Return -> "return")

;;

print_endline "digraph CFG {";
graph#iterNodes (fun node _ ->
  Printf.printf "  %a;\n"
    printNode node);
graph#iterEdges (fun (origin, edge, destination) ->
  Printf.printf "  %a -> %a [label=\"%a\"];\n"
    printNode origin
    printNode destination
    printEdge edge);
print_endline "}"

open FlowGraph


exception Found of node


let findNode (targetFunc, targetId) =
  let description = Printf.sprintf "find node %s:%d" targetFunc targetId in
  let consider node _ =
    match node with
    | (Before, ((_, func), id)) as key
      when targetFunc = func && targetId = id ->
	raise (Found key)
    | _ -> ()
  in
  try
    graph#iterNodes consider;
    raise Not_found
  with
    Found key -> key

open Cil


let rec endsWithCall_instrs = function
  | [] -> false
  | [Call _] -> true
  | Call _ :: _ -> failwith "found call before end of instruction list"
  | _ :: tail -> endsWithCall_instrs tail
	
	
let endsWithCall {skind = skind} =
  match skind with
  | Instr(instrs) -> endsWithCall_instrs instrs
  | _ -> false
	

let collectPostCallHeader headers stmt =
  if endsWithCall stmt then
    match stmt.succs with
    | [] -> ()
    | [succ] -> headers#add (stmt, succ)
    | _ -> failwith (Printf.sprintf "CFG #%i contains call with %i successors" stmt.sid (List.length stmt.succs))
	

let collect headers =
  List.iter (collectPostCallHeader headers)

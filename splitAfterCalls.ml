open Cil

(* look into Cil.compactStmts *)

let rec slurp = function
  | [] ->
      ([], [])
  | Call _ as call :: tail ->
      ([call], tail)
  | other :: tail ->
      let more, remainder = slurp tail in
      (other :: more, remainder)

	
let rec split instrs =
  let initial, remainder = slurp instrs in
  if remainder == [] then
    [initial]
  else
    initial :: split remainder


class visitor = object
  inherit nopCilVisitor
      
  method vstmt stmt =
    match stmt.skind with
    | Instr(instrs) ->
	begin
	  match split instrs with
	  | [] -> DoChildren
	  | [_] -> DoChildren
	  | splits ->
	      ChangeTo {stmt with skind =
			Block (mkBlock (List.map
					  (fun split -> mkStmt (Instr split))
					  splits))}
	end
    | _ -> DoChildren
	  
end
    
;;

ignore(TestHarness.main new visitor)

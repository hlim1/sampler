open Cil

  
class visitor = object
  inherit nopCilVisitor
      
  method vstmt stmt =
    match stmt.skind with
    | Instr(instrs) ->
	begin
	  let rec split = function
	    | [] -> []
	    | instrs ->
		let rec slurp = function
		  | [] ->
		      ([], [])
		  | Call _ as call :: tail ->
		      ([call], tail)
		  | other :: tail ->
		      let more, remainder = slurp tail in
		      (other :: more, remainder)
		in
		
		let (initial, remainder) = slurp instrs in
		mkStmt(Instr(initial)) :: split remainder
	  in
	  
	  match split instrs with
	  | [] -> DoChildren
	  | [_] -> DoChildren
	  | splits ->
	      ChangeTo {stmt with skind = Block (mkBlock splits)}
	end
    | _ -> DoChildren
	  
end

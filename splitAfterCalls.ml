open Cil

  
class visitor = object
  inherit FunctionBodyVisitor.visitor

  val mutable calls : stmt list = []
  method result = calls

  method vstmt stmt =
    begin
      match stmt.skind with
      | Instr(instrs) ->
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
	  
	  begin
	    match split instrs with
	    | [] -> ()
	    | [_] -> ()
	    | splits -> stmt.skind <- Block (mkBlock splits)
	  end
	    
      | _ -> ()
    end;
    
    DoChildren
end


let visit {sbody = sbody} =
  let visitor = new visitor in
  ignore (visitCilBlock (visitor :> cilVisitor) sbody);
  visitor#result

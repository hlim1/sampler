open Cil

  
class visitor = object
  inherit FunctionBodyVisitor.visitor

  val mutable afterCalls : stmt list = []
  method result = afterCalls

  method vstmt stmt =
    match stmt.skind with
    | Instr(instrs) ->
	let rec split = function
	  | [] -> []
	  | instrs ->
	      let rec slurp = function
		| [] ->
		    (false, [], [])
		| Call _ as call :: tail ->
		    (true, [call], tail)
		| other :: tail ->
		    let hasCall, more, remainder = slurp tail in
		    (hasCall, other :: more, remainder)
	      in
	      
	      let (hasCall, initial, remainder) = slurp instrs in
	      let initialStmt = mkStmt (Instr initial) in
	      if hasCall then
		let placeholder = mkStmt (Block (mkBlock [])) in
		afterCalls <- placeholder :: afterCalls;
		initialStmt :: placeholder :: split remainder
	      else
		initialStmt :: split remainder
	in
	
	begin
	  match split instrs with
	  | [] -> ()
	  | [_] -> ()
	  | splits -> stmt.skind <- Block (mkBlock splits)
	end;

	SkipChildren
	  
    | _ ->
	DoChildren
end


let split {sbody = sbody} =
  let visitor = new visitor in
  ignore (visitCilBlock (visitor :> cilVisitor) sbody);
  visitor#result


(**********************************************************************)


let nextLabelNum = ref 0

let nextLabel _ =
  incr nextLabelNum;
  Label ("postCall" ^ string_of_int !nextLabelNum, locUnknown, false)


let prepatch weights =
  let prepatchOne after =
    match after.skind with
    | Block block ->
	let landing = mkStmt (Instr []) in
	landing.labels <- [nextLabel ()];
	
	let patchSite = ref landing in
	let gotoStandard = mkBlock [mkStmt (Goto (ref landing, locUnknown))] in
	let gotoInstrumented = mkBlock [mkStmt (Goto (patchSite, locUnknown))] in
	let weight = weights#find after in
	let choice = LogIsImminent.choose locUnknown weight gotoInstrumented gotoStandard in
	
	block.bstmts <- [mkStmt choice; landing];
	patchSite
	    
    | _ -> failwith "unexpected statement kind in after calls list"
  in

  List.map prepatchOne


(**********************************************************************)


let patch clones =
  let patchOne dest = dest := clones#find !dest in
  List.iter patchOne

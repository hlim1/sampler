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
		let placeholder = mkEmptyStmt () in
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

let label name = Label (name, locUnknown, false)

let nextLabels _ =
  incr nextLabelNum;
  let basis = "postCall" ^ string_of_int !nextLabelNum in
  label basis, label (basis ^ "__dup")


let patch clones weights countdown =
  let patchOne standardAfter =
    let weight = weights#find standardAfter in
    if weight != 0 then
      let instrumentedAfter = clones#find standardAfter in
	  
      let standardLabel, instrumentedLabel = nextLabels () in
      let standardLanding = mkEmptyStmt () in
      let instrumentedLanding = mkEmptyStmt () in
      standardLanding.labels <- [standardLabel];
      instrumentedLanding.labels <- [instrumentedLabel];
      
      let gotoStandard = mkBlock [mkStmt (Goto (ref standardLanding, locUnknown))] in
      let gotoInstrumented = mkBlock [mkStmt (Goto (ref instrumentedLanding, locUnknown))] in
      let choice = LogIsImminent.choose locUnknown weight countdown gotoInstrumented gotoStandard in
      
      standardAfter.skind <- Block (mkBlock [mkStmt choice; standardLanding]);
      instrumentedAfter.skind <- Block (mkBlock [mkStmt choice; instrumentedLanding])
  in
  
  List.iter patchOne

open Cil


type placeholders = stmt list


class prepatcher =
  object
    inherit FunctionBodyVisitor.visitor

    val mutable placeholders = []
    method result = placeholders

    method vstmt stmt =
      match stmt.skind with
      | Instr [Call (_, _, _, location) as call] ->
	  let placeholder = mkEmptyStmt () in
	  let block = Block (mkBlock [mkStmtOneInstr call; placeholder]) in
	  placeholders <- placeholder :: placeholders;
	  
	  let replace stmt =
	    stmt.skind <- block;
	    stmt
	  in
	  ChangeDoChildrenPost (stmt, replace)

      | _ ->
	  DoChildren
  end


let prepatch {sbody = sbody} =
  let visitor = new prepatcher in
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
      let instrumentedAfter = ClonesMap.findCloneOf clones standardAfter in
      
      let standardLabel, instrumentedLabel = nextLabels () in
      let standardLanding = mkEmptyStmt () in
      let instrumentedLanding = mkEmptyStmt () in
      standardLanding.labels <- [standardLabel];
      instrumentedLanding.labels <- [instrumentedLabel];
      
      let gotoStandard = mkBlock [mkStmt (Goto (ref standardLanding, locUnknown))] in
      let gotoInstrumented = mkBlock [mkStmt (Goto (ref instrumentedLanding, locUnknown))] in
      let choice = countdown#checkThreshold locUnknown weight
	  gotoInstrumented gotoStandard in
      
      standardAfter.skind <- Block (mkBlock [mkStmt choice; standardLanding]);
      instrumentedAfter.skind <- Block (mkBlock [mkStmt choice; instrumentedLanding])
  in
  
  List.iter patchOne


(**********************************************************************)


class postpatcher countdown =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt stmt =
      match stmt.skind with
      | Instr [Call (_, _, _, location) as call] ->
	  let before = countdown#beforeCall location in
	  let after = countdown#afterCall location in
	  let instructions = [before; call; after] in
	  stmt.skind <- Instr instructions;
	  SkipChildren

      | Return (_, location) ->
	  let export = countdown#beforeCall location in
	  stmt.skind <- Block (mkBlock [mkStmtOneInstr export; mkStmt stmt.skind]);
	  SkipChildren

      | _ ->
	  DoChildren
  end


let postpatch {sbody = sbody} countdown =
  let visitor = new postpatcher countdown in
  ignore (visitCilBlock visitor sbody)

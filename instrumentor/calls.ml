open Cil


type placeholders = (stmt * stmt) list


class prepatcher =
  object
    inherit FunctionBodyVisitor.visitor

    val mutable placeholders = []
    method result = placeholders

    method vstmt stmt =
      match stmt.skind with
      | Instr [Call _ as call] ->
	  let slotBefore = mkEmptyStmt () in
	  let slotAfter = mkEmptyStmt () in
	  placeholders <- (slotBefore, slotAfter) :: placeholders;
	  
	  let block = Block (mkBlock [slotBefore; mkStmtOneInstr call; slotAfter]) in
	  stmt.skind <- block;
	  SkipChildren

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
  let patchOne (_, standardAfter) =
    let weight = weights#find standardAfter in
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


let postpatch clones countdown =
  let postpatchOne before after =
    before.skind <- Instr [countdown#beforeCall];
    after.skind <- Instr [countdown#afterCall]
  in

  let findClone =
    ClonesMap.findCloneOf clones
  in

  let postpatchBoth (standardBefore, standardAfter) =
    let instrumentedBefore = findClone standardBefore in
    let instrumentedAfter = findClone standardAfter in
    postpatchOne standardBefore standardAfter;
    postpatchOne instrumentedBefore instrumentedAfter
  in

  List.iter postpatchBoth

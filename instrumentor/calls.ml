open Cil


type placeholders = (stmt * stmt * stmt * stmt) list


class prepatcher =
  object
    inherit FunctionBodyVisitor.visitor

    val mutable placeholders = []
    method result = placeholders

    method vstmt stmt =
      match stmt.skind with
      | Instr [Call _ as call] ->
	  let export = mkEmptyStmt () in
	  let import = mkEmptyStmt () in
	  let jump = mkEmptyStmt () in
	  let landing = mkEmptyStmt () in
	  placeholders <- (export, import, jump, landing) :: placeholders;
	  
	  let block = Block (mkBlock [export; mkStmtOneInstr call; import; jump; landing]) in
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
  let patchOne (standardExport, standardImport, standardJump, standardLanding) =
    let findClone = ClonesMap.findCloneOf clones in
    let instrumentedImport = findClone standardImport in
    let instrumentedJump = findClone standardJump in
    let instrumentedLanding = findClone standardLanding in

    let export () = Instr [countdown#import] in
    let instrumentedExport = findClone standardExport in
    standardExport.skind <- export ();
    instrumentedExport.skind <- export ();

    let import () = Instr [countdown#import] in
    standardImport.skind <- import ();
    instrumentedImport.skind <- import ();

    let weight = weights#find standardLanding in
    let choice () = countdown#checkThreshold locUnknown weight instrumentedLanding standardLanding in
    standardJump.skind <- choice ();
    instrumentedJump.skind <- choice ();

    let standardLabel, instrumentedLabel = nextLabels () in
    standardLanding.labels <- [standardLabel];
    instrumentedLanding.labels <- [instrumentedLabel]
  in
  
  List.iter patchOne

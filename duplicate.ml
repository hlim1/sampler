open Cil
open Identity


let cloneLabel = function
  | Label (name, location, fromSource) ->
      Label (name ^ "__dup", location, fromSource)
  | other -> other


(**********************************************************************)


class visitor = object
  inherit FunctionBodyVisitor.visitor

  val clones = new StmtMap.container
  val mutable forwardJumps = []

  method patchJumps =
    let patchJump dest =
      dest := clones#find !dest
    in
    List.iter patchJump forwardJumps


  method vstmt stmt =
    let clone = { stmt with sid = -1;
		  labels = mapNoCopy cloneLabel stmt.labels }
    in
    
    let result =
      match clone.skind with
      | Goto (dest, location) ->
	  begin
	    try
	      let clonedDest = clones#find !dest in
	      let choice = If (zero,
			       mkBlock [mkStmt (Goto (ref clonedDest, location))],
			       mkBlock [mkStmt clone.skind],
			       locUnknown) in
	      
	      stmt.skind <- choice;
	      
	      (* postpone the update so we don't traverse into the choice consequent *)
	      let update s =
		s.skind <- choice;
		s
	      in

	      ChangeDoChildrenPost (clone, update)

	    with
	      Not_found ->
		let patchSite = ref !dest in
		clone.skind <- Goto (patchSite, location);
		forwardJumps <- patchSite :: forwardJumps;
		ChangeTo clone
	  end
	    
      | _ -> ChangeDoChildrenPost (clone, identity)
    in
    
    clones#add stmt clone;
    result
end


let duplicateBody {sbody = original} =
  let visitor = new visitor in
  let result = visitCilBlock (visitor :> cilVisitor) original in
  visitor#patchJumps;
  result

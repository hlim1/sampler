open Cil
open Identity


let cloneLabel = function
  | Label (name, location, _) ->
      Label (name ^ "__dup", location, true)
  | other -> other


(**********************************************************************)


class visitor = object
  inherit SkipVisitor.visitor

  val clones = new StmtMap.container
  val mutable forwardJumps = []

  method patchJumps =
    let patchJump dest =
      dest := clones#find !dest
    in
    List.iter patchJump forwardJumps


  method vblock block =
    ChangeDoChildrenPost (block, identity)


  method vstmt stmt =
    let clone = { stmt with
		  labels = mapNoCopy cloneLabel stmt.labels;
		  sid = -1 }
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
	      let update s =
		clone.skind <- choice;
		stmt.skind <- choice;
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

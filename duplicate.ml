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
    let duplicate = { block with bstmts = block.bstmts } in
    ChangeDoChildrenPost (duplicate, identity)


  method vstmt stmt =
    if stmt.sid == -1 then
      SkipChildren
    else
      let clone = { stmt with
		    labels = mapNoCopy cloneLabel stmt.labels;
		    sid = -1 }
      in
      
      begin
	match clone.skind with
	| Goto (dest, location) ->
	    begin
	      try
		let clonedDest = clones#find !dest in
		let choice = If (zero,
				 mkBlock [mkStmt (Goto (ref clonedDest, location))],
				 mkBlock [mkStmt clone.skind],
				 locUnknown) in
		clone.skind <- choice;
		stmt.skind <- choice
	      with
		Not_found ->
		  let patchSite = ref !dest in
		  clone.skind <- Goto (patchSite, location);
		  forwardJumps <- patchSite :: forwardJumps
	    end
	      
	| _ -> ()
      end;

      clones#add stmt clone;
      ChangeDoChildrenPost (clone, Identity.identity)
end


let duplicateBody {sbody = original} =
  let visitor = new visitor in
  let result = visitCilBlock (visitor :> cilVisitor) original in
  visitor#patchJumps;
  result

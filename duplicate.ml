open Cil
open Identity


let cloneLabel = function
  | Label (name, location, _) ->
      Label (name ^ "__dup", location, true)
  | other -> other


class visitor = object(self)
  inherit SkipVisitor.visitor

  val nextId = ref (-1)
  method nextId = incr nextId; !nextId

  val forwardJumps = ref []
  val clones = new StmtMap.container

  method patchJumps =
    let patchJump dest =
      dest := clones#find !dest
    in
    List.iter patchJump !forwardJumps

  method vblock block =
    let duplicate = { block with bstmts = block.bstmts } in
    ChangeDoChildrenPost (duplicate, identity)

  method vstmt stmt =
    if stmt.sid != -1 then
      ignore (bug "statement sid already set by someone else");
    
    let newSkind =
      match stmt.skind with
      | Goto ({contents = {sid = -1} as dest}, location) ->
	  let indirect = ref dest in
	  forwardJumps := indirect :: !forwardJumps;
	  Goto (indirect, location);
      | other -> other
    in
    
    let newLabels = mapNoCopy cloneLabel stmt.labels in
    let clone = mkStmt newSkind in
    clone.labels <- newLabels;

    stmt.sid <- self#nextId;
    clones#add stmt clone;
    ChangeDoChildrenPost (clone, identity)
end


let duplicateBody {sbody = original} =
  let visitor = new visitor in
  let result = visitCilBlock (visitor :> cilVisitor) original in
  visitor#patchJumps;
  result

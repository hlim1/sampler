open Cil
open Identity


let cloneLabel = function
  | Label (name, location, _) ->
      Label (name ^ "__dup", location, false)
  | other -> other


class visitor = object(self)
  inherit SkipVisitor.visitor

  val nextId = ref 0
  method nextId = incr nextId; !nextId

  val forwardJumps = ref []
  val clones = new StmtMap.container

  method patchJumps =
    let patchJump = function
      |	Goto (dest, _) -> dest := clones#find !dest
      |	_ -> ignore (bug "unexpected non-goto on jumps list\n")
    in
    List.iter patchJump !forwardJumps

  method vblock block =
    let duplicate = { block with bstmts = block.bstmts } in
    ChangeDoChildrenPost (duplicate, identity)

  method vstmt stmt =

    if stmt.sid != -1 then
      ignore (bug "statement sid already set by someone else");
    
    begin
      match stmt.skind with
      | Goto ({contents = {sid = -1} as dest}, _) ->
	  forwardJumps := stmt.skind :: !forwardJumps
      |	_ -> ()
    end;

    let newLabels = mapNoCopy cloneLabel stmt.labels in
    let clone = { stmt with labels = newLabels } in
    stmt.sid <- self#nextId;
    clones#add stmt clone;
    ChangeDoChildrenPost (clone, identity)
end


let duplicateBody {sbody = original} =
  let visitor = new visitor in
  let result = visitCilBlock (visitor :> cilVisitor) original in
  visitor#patchJumps;
  result

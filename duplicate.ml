open Cil
open Identity


type clonesMap = stmt StmtMap.container


let cloneLabel = function
  | Label (name, location, fromSource) ->
      Label (name ^ "__dup", location, fromSource)
  | other -> other


(**********************************************************************)


class visitor = object
  inherit FunctionBodyVisitor.visitor

  val clones = new StmtMap.container
  method result = clones

  method vstmt stmt =
    let clone = { stmt with sid = -1;
		  labels = mapNoCopy cloneLabel stmt.labels }
    in

    if stmt.sid != -1 then
      clones#add stmt clone;
    
    ChangeDoChildrenPost (clone, identity)
end


let duplicateBody {sbody = original} =
  let visitor = new visitor in
  let clonedBody = visitCilBlock (visitor :> cilVisitor) original in
  (clonedBody, visitor#result)

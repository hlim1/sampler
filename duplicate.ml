open Cil
open Identity


let cloneLabel = function
  | Label (name, location, _) ->
      Label (name ^ "__dup", location, false)
  | other -> other
	
	
class visitor = object(self)
  inherit SkipVisitor.visitor

  method vblock block =
    let duplicate = {block with bstmts = block.bstmts} in
    ChangeDoChildrenPost (duplicate, identity)

  method vstmt stmt =
    let originals = stmt.labels in
    let replacements = mapNoCopy cloneLabel originals in
    let clone = { stmt with labels = replacements } in
    ChangeDoChildrenPost (clone, identity)
end


let duplicateBody {sbody = original} =
  visitCilBlock new visitor original

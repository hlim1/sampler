open Cil
open Identity


let cloneLabel = function
  | Label (name, location, fromSource) ->
      Label (name ^ "__dup", location, fromSource)
  | other -> other


(**********************************************************************)


class visitor pairs =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt stmt =
      let clone = { stmt with labels = mapNoCopy cloneLabel stmt.labels }
      in
      
      if stmt.sid != -1 then
	pairs.(stmt.sid) <- (stmt, clone);

      ChangeDoChildrenPost (clone, identity)
  end


let duplicateBody fundec =
  match fundec.smaxstmtid with
  | None ->
      failwith "no maximum statement id; please call Cil.computeCFGInfo before duplicating"
  | Some max ->
      let pairs = Array.make max (dummyStmt, dummyStmt) in
      let visitor = new visitor pairs in
      let clone = visitCilBlock visitor fundec.sbody in
      (fundec.sbody, clone, pairs)

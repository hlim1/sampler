open Cil
open Identity


let cloneLabel = function
  | Label (name, location, _) ->
      Label (name ^ "__dup", location, false)
  | other -> other
	
	
class visitor = object(self)
  inherit Instrument.visitor

  method vfunc func =
    let predicate = one in
    let original = func.sbody in
    let clone = visitCilBlock (self :> cilVisitor) original in
    let choice = mkStmt (If (predicate, original, clone, func.svar.vdecl)) in
    func.sbody <- mkBlock [choice];
    SkipChildren

  method vstmt stmt =
    let originals = stmt.labels in
    let replacements = mapNoCopy cloneLabel originals in
    if replacements == originals then
      SkipChildren
	else
      ChangeTo { stmt with labels = replacements }
end


let phase _ =
  ("Duplicate", visitCilFileSameGlobals new visitor)

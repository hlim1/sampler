open Cil


class visitor file =
  let logger = FindLogger.find file in

  object
    inherit TransformVisitor.visitor file

    method weigh {skind = skind} =
      match skind with
      | Instr [_] -> 1
      | _ -> 0

    method findSites = new FindSites.visitor logger
    method placeInstrumentation code log = [log; code]
  end


let phase =
  "Transform",
  fun file -> visitCilFileSameGlobals (new visitor file :> cilVisitor) file

open Cil


class visitor file =
  let logger = FindLogger.find file in

  object
    inherit [FindSites.sites] TransformVisitor.visitor file

    method weigh {skind = skind} =
      match skind with
      | Instr [_] -> 1
      | _ -> 0

    method findSites = FindSites.visit
    method insertSkips sites countdown = (new InsertSkipsBefore.visitor sites countdown :> cilVisitor)
    method insertLogs = Logs.insert logger
  end


let phase =
  "Transform",
  fun file -> visitCilFileSameGlobals (new visitor file :> cilVisitor) file

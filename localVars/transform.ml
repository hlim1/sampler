open Cil


class visitor file =
  let logger = FindLogger.find file in

  object
    inherit TransformVisitor.visitor file

    method weigh {skind = skind} =
      match skind with
      | Instr instrs -> List.length instrs
      | _ -> 0

    method insertSkips = new Skips.visitor
    method insertLogs = new Logs.visitor logger fundec
  end


let phase =
  "Transform",
  fun file -> visitCilFileSameGlobals (new visitor file :> cilVisitor) file

open Cil


class visitor file = object
  inherit TransformVisitor.visitor

  val logger = FindLogger.find file

  method weigh {skind = skind} =
    match skind with
    | Instr instrs -> List.length instrs
    | _ -> 0

  method insertSkips = new Skips.visitor
  method insertLogs = new Logs.visitor logger
end


let phase =
  "Transform",
  fun file -> visitCilFileSameGlobals (new visitor file :> cilVisitor) file

open Cil


class visitor file = object
  inherit TransformVisitor.visitor

  val loggers = FindLoggers.find file

  method weigh {skind = skind} =
    match skind with
    | Instr instrs -> List.length instrs
    | _ -> 0

  method insertSkips = new Skips.visitor
  method insertLogs fundec = new Logs.visitor loggers fundec
end


let phase =
  "Transform",
  fun file -> visitCilFileSameGlobals (new visitor file :> cilVisitor) file

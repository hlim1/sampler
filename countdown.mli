open Cil


type globalCountdown

val findGlobal : file -> globalCountdown

class countdown : globalCountdown -> fundec -> object
  method decrement : location -> instr
  method beforeCall : location -> instr
  method afterCall : location -> instr
  method choose : location -> int -> block -> block -> stmtkind
end

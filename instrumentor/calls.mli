open Cil


type placeholders = (stmt * stmt * stmt * stmt) list


class prepatcher : object
  inherit cilVisitor
  method result : placeholders
end
      

val prepatch : fundec -> placeholders
val patch : ClonesMap.clonesMap -> WeighPaths.weightsMap -> Countdown.countdown -> placeholders -> unit

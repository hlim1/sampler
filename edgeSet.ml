open Cil


type edge = stmt * stmt

class container = object
  inherit [Edge.edge] SetClass.container (fun (source, dest) -> (source.sid, dest.sid))
end

open Cil
open Edge

class container = object
  inherit [edge] SetClass.container (fun (source, dest) -> (source.sid, dest.sid))
end

open Cil

class container = object
  inherit [stmt] SetClass.container (fun {sid = sid} -> assert (sid != -1); sid)
end

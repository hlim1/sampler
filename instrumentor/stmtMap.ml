open Cil

class ['data] container = object
  inherit [stmt, 'data] MapClass.container (fun {sid = sid} -> assert (sid != -1); sid)
end

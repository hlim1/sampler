open Cil

class container = object
  inherit [stmt] SetClass.container (fun {sid = sid} -> if sid == -1 then failwith "bad statement id" else sid)
end

open Cil

class ['data] container = object
  inherit [stmt, 'data] MapClass.container (fun {sid = sid} -> if sid == -1 then failwith "bad statement id" else sid)
end

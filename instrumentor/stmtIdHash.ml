open Cil


module Key = struct
  type t = stmt

  let equal = (==)
      
  let hash {sid; _} =
    assert (sid != -1);
    sid
end


include HashClass.Make (Key)

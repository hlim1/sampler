module Key = struct
  type t = string * int

  let equal = (=)
      
  let hash = Hashtbl.hash
end


include HashClass.Make (Key)

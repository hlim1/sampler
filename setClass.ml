exception Duplicate_key 
exception Missing_key
   

class ['a] container = object(self)
    
  val storage : 'a list ref = ref []

  method add key =
    if self#mem key then raise Duplicate_key;
    storage := key :: !storage
			 
  method mem key = List.mem key !storage
      
  method isEmpty = !storage == []

  method choose = List.hd !storage

  method remove chaff =
    if not (self#mem chaff) then raise Missing_key;
    storage := List.filter ((!=) chaff) !storage

  method iter action =
    List.iter action !storage
end

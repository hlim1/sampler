exception Missing_key
   

class ['key] container indexer = object(self)
    
  val storage : ('index * 'key) list ref = ref []

  method add key =
    if not (self#mem key) then
      storage := (indexer key, key) :: !storage

  method remove chaff =
    if not (self#mem chaff) then raise Missing_key;
    storage := List.remove_assoc (indexer chaff) !storage
			 
  method mem key = List.mem_assoc (indexer key) !storage
      
  method size = List.length !storage

  method isEmpty = !storage == []

  method clear = storage := []

  method choose = snd (List.hd !storage)

  method iter action =
    List.iter (fun (_, key) -> action key) !storage
end

exception Duplicate_key
exception Missing_key
    

class ['a, 'b] container size = object(self)
    
  val storage : ('a * 'b) list ref = ref []
      
  method add key data =
    storage := (key, data) :: List.remove_assq key !storage
	
  method find key = List.assq key !storage

  method mem key = List.mem_assq key !storage

  method replace key data =
    if not (self#mem key) then
      raise Missing_key
    else
      begin
	storage := List.remove_assq key !storage;
	self#add key data
      end
	
  method iter action =
    List.iter (fun (key, data) -> action key data) !storage
end

class ['key, 'data] container indexer = object(self)

  val storage : ('index * ('key * 'data)) list ref = ref []
      
  method add key data =
    self#remove key;
    storage := (indexer key, (key, data)) :: !storage

  method remove key =
    storage := List.remove_assoc (indexer key) !storage
					      
  method find key = snd (List.assoc (indexer key) !storage)

  method mem key = List.mem_assoc (indexer key) !storage

  method size = List.length !storage

  method iter action =
    List.iter (fun (_, (key, data)) -> action key data) !storage
end

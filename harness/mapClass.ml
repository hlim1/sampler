exception Nonempty


class ['key, 'data] container indexer = object(self)

  val mutable storage
      : (_, ('key * 'data)) Hashtbl.t
      = Hashtbl.create 0
      
  method add key data =
    self#remove key;
    Hashtbl.add storage (indexer key) (key, data)

  method remove key =
    Hashtbl.remove storage (indexer key)
					      
  method find key = snd (Hashtbl.find storage (indexer key))

  method mem key = Hashtbl.mem storage (indexer key)

  method isEmpty =
    try
      Hashtbl.iter (fun _ -> raise Nonempty) storage;
      true
    with Nonempty ->
      false

  method iter action =
    let action _ (key, data) = action key data in
    Hashtbl.iter action storage
end

exception Chosen


class ['key] container indexer = object(self)

  val storage = new MapClass.container indexer

  method add key = storage#add key ()

  method remove = storage#remove

  method mem = storage#mem

  method isEmpty = storage#isEmpty

  method choose =
    let result = ref None in
    begin
      try
	self#iter (fun key -> result := Some key; raise Chosen);
	raise Not_found
      with Chosen -> ()
    end;
    match !result with
      None -> raise Not_found
    | Some chosen -> chosen

  method iter action =
    let mapAction (key : 'key) () = action key in
    storage#iter mapAction
end

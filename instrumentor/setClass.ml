exception Chosen


class type ['key] s = object
  method add : 'key -> unit
  method remove : 'key -> unit

  method mem : 'key -> bool
  method isEmpty : bool

  method choose : 'key
  method iter : ('key -> unit) -> unit
end


module Make (Key : Hashtbl.HashedType) = struct

  module Map = MapClass.Make(Key)

  class container = object (self)

    val storage = new Map.container

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
      let mapAction key () = action key in
      storage#iter mapAction
  end
end

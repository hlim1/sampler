exception Nonempty


class type ['key, 'data] s = object
  method add : 'key -> 'data -> unit
  method remove : 'key -> unit

  method find : 'key -> 'data
  method mem : 'key -> bool
  method isEmpty : bool

  method iter : ('key -> 'data -> unit) -> unit
  method fold : ('key -> 'data -> 'result -> 'result) -> 'result -> 'result
end


module Make (Key : Hashtbl.HashedType) = struct

  module Hash = Hashtbl.Make(Key)

  class ['data] container : [Key.t, 'data] s = object (self)

    val mutable storage = Hash.create 0

    method add key =
      self#remove key;
      Hash.add storage key

    method remove =
      Hash.remove storage

    method find = Hash.find storage

    method mem = Hash.mem storage

    method isEmpty =
      try
	self#iter (fun _ -> raise Nonempty);
	true
      with Nonempty ->
	false

    method iter action =
      Hash.iter action storage

    method fold
	: 'result . ((_ -> _ -> 'result -> 'result) -> 'result -> 'result)
	= fun folder ->
	  Hash.fold folder storage
  end
end

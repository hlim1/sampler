class type ['key, 'value] t =
  object ('self)
    method copy : 'self

    method add : 'key -> 'value -> unit
    method remove : 'key -> unit

    method find : 'key -> 'value
    method findAll : 'key -> 'value list
    method mem : 'key -> bool

    method iter : ('key -> 'value -> unit) -> unit
    method fold : ('key -> 'value -> 'result -> 'result) -> 'result -> 'result
  end


class ['key, 'value] c initial =
  object
    val storage : ('key, 'value) Hashtbl.t =
      Hashtbl.create initial

    method copy =
      {< storage = Hashtbl.copy storage >}

    method add = Hashtbl.add storage

    method remove = Hashtbl.remove storage

    method find = Hashtbl.find storage

    method findAll = Hashtbl.find_all storage

    method mem = Hashtbl.mem storage

    method iter visitor = Hashtbl.iter visitor storage

    method fold
	: 'result . ((_ -> _ -> 'result -> 'result) -> 'result -> 'result)
	= fun folder ->
	  Hashtbl.fold folder storage
  end


module type S = sig
  type key

  class ['value] c : int -> [key, 'value] t
end


module Make (Key : Hashtbl.HashedType) = struct
  module Hash = Hashtbl.Make(Key)

  type key = Hash.key

  class ['value] c initial =
    object (self)
      val storage : 'value Hash.t = Hash.create initial

      method copy =
	{< storage = Hash.copy storage >}

      method add = Hash.add storage

      method remove = Hash.remove storage

      method find = Hash.find storage

      method findAll = Hash.find_all storage

      method mem = Hash.mem storage

      method iter visitor = Hash.iter visitor storage

      method fold
	  : 'result . ((_ -> _ -> 'result -> 'result) -> 'result -> 'result)
	  = fun folder ->
	    Hash.fold folder storage
    end
end

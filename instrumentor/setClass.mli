class type ['key] s = object
  method add : 'key -> unit
  method remove : 'key -> unit

  method mem : 'key -> bool
  method isEmpty : bool

  method choose : 'key
  method iter : ('key -> unit) -> unit
end


module Make (Key : Hashtbl.HashedType) : sig
  class container : [Key.t] s
end

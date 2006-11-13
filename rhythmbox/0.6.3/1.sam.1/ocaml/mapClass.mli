class type ['key, 'data] s =
  object
    method add : 'key -> 'data -> unit
    method remove : 'key -> unit
    method replace : 'key -> 'data -> unit

    method find : 'key -> 'data
    method mem : 'key -> bool
    method isEmpty : bool

    method iter : ('key -> 'data -> unit) -> unit
    method fold : ('key -> 'data -> 'result -> 'result) -> 'result -> 'result
  end


module Make (Key : Hashtbl.HashedType) : sig
  class ['data] container : [Key.t, 'data] s
end

class ['key, 'value] t : int ->
  object
    method add : 'key -> 'value -> unit
    method remove : 'key -> unit

    method find : 'key -> 'value
    method findAll : 'key -> 'value list
    method mem : 'key -> bool

    method iter : ('key -> 'value -> unit) -> unit
  end

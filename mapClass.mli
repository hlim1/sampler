class ['key, 'data] container : ('key -> 'index) -> object

  method add : 'key -> 'data -> unit
  method remove : 'key -> unit

  method find : 'key -> 'data
  method mem : 'key -> bool

  method size : int

  method iter : ('key -> 'data -> unit) -> unit
end

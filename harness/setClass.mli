class ['key] container : ('key -> 'index) -> object

  method add : 'key -> unit
  method remove : 'key -> unit

  method mem : 'key -> bool

  method isEmpty : bool

  method choose : 'key
  method iter : ('key -> unit) -> unit
end

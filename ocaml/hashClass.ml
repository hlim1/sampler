class ['key, 'value] t initial =
  object
    val storage : ('key, 'value) Hashtbl.t = Hashtbl.create initial

    method add = Hashtbl.add storage

    method remove = Hashtbl.remove storage

    method find = Hashtbl.find storage

    method findAll = Hashtbl.find_all storage

    method mem = Hashtbl.mem storage

    method iter visitor = Hashtbl.iter visitor storage
  end

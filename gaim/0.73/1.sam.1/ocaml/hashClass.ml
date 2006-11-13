class ['key, 'value] t (storage : ('key, 'value) Hashtbl.t) =
  object
    method copy =
      let clone = Hashtbl.copy storage in
      new t clone

    method add = Hashtbl.add storage

    method remove = Hashtbl.remove storage

    method find = Hashtbl.find storage

    method findAll = Hashtbl.find_all storage

    method mem = Hashtbl.mem storage

    method iter visitor = Hashtbl.iter visitor storage
  end


let create initial =
  let storage = Hashtbl.create initial in
  new t storage

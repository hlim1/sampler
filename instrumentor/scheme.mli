class virtual c :
  object
    method virtual normalize : unit
    method virtual findSites : unit
    method virtual embedInfo : Digest.t Lazy.t -> unit
  end

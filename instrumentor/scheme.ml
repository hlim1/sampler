open Cil


class virtual c (file : file) =
  object (self)
    method findAllSites =
      Scanners.iterFuncs file self#findSites

    method virtual embedInfo : Digest.t Lazy.t -> unit
  end

open Cil


class virtual c file =
  object (self)
    method virtual private findSites : fundec -> unit
    method virtual embedInfo : Digest.t Lazy.t -> unit

    method findAllSites =
      Scanners.iterFuncs file self#findSites
  end

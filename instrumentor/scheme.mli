open Cil


class virtual c : SchemeName.t -> file ->
  object
    method virtual private findSites : fundec -> unit
    method virtual embedInfo : Digest.t Lazy.t -> unit

    method findAllSites : unit
  end

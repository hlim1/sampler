open Cil


class virtual c : SchemeName.t -> file ->
  object
    method virtual private findSites : fundec -> unit
    method virtual saveSiteInfo : Digest.t Lazy.t -> out_channel -> unit

    method findAllSites : unit
  end

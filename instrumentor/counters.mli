open Cil


class manager : SchemeName.t -> file ->
  object
    method addSite : SiteInfo.c -> offset -> (stmt * int)
    method patch : unit
    method saveSiteInfo : Digest.t Lazy.t -> out_channel -> unit
  end

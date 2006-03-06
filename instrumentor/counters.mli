open Cil


class manager : SchemeName.t -> file ->
  object
    method addSiteExpr : SiteInfo.c -> exp -> stmt
    method addSiteOffset : SiteInfo.c -> offset -> stmt
    method patch : unit
    method saveSiteInfo : Digest.t Lazy.t -> out_channel -> unit
  end

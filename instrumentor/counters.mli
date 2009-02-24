open Cil


class manager : SchemeName.t -> file ->
  object
    method addSiteExpr : SiteInfo.c -> exp -> (stmt * int)
    method addSiteOffset : SiteInfo.c -> offset -> (stmt * int)
    (* cci *)
    method addSiteInstrs : SiteInfo.c -> instr list-> stmt
    method addExpr : exp -> (instr * int)
    method addOffset : offset -> (instr * int)

    method patch : unit
    method saveSiteInfo : Digest.t Lazy.t -> out_channel -> unit
  end

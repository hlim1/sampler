open Cil


class manager : SchemeName.t -> file ->
  object
    method addSiteExpr : SiteInfo.c -> exp -> (stmt * int)

    method addSiteOffset : SiteInfo.c -> offset -> (stmt * int)
    method selectorToImpl : SiteInfo.c -> offset -> (Cil.stmtkind * int)
    method addImplementation : SiteInfo.c -> Cil.stmtkind -> stmt
    (* cci *)
    method addSiteInstrs : SiteInfo.c -> instr list-> stmt
    method addExpr : exp -> (instr * int)
    method addExpr2 : exp -> exp -> (instr list * int)
    method addExprId : exp -> int -> (instr * int)
    method addOffset : offset -> (instr * int)
    method addOffset2 : offset -> offset -> (instr list * int)
    method addOffsetId : offset -> int -> (instr * int)

    method patch : unit
    method saveSiteInfo : Digest.t Lazy.t -> out_channel -> unit
  end

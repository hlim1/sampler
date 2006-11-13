open Cil
open SchemeName


let first =
  Options.registerBoolean
    ~flag:"timestamp-first"
    ~desc:"record relative timestamp for first observation of each site"
    ~ident:"TimestampFirst"
    ~default:false


let last =
  Options.registerBoolean
    ~flag:"timestamp-last"
    ~desc:"record relative timestamp for last observation of each site"
    ~ident:"TimestampLast"
    ~default:false


let set file scheme =
  let setter, args =
    match !first, !last with
    | false, false -> "", []
    | true, false -> "timestampsSetFirst", ["First"]
    | false, true -> "timestampsSetLast", ["Last"]
    | true, true -> "timestampsSetBoth", ["First"; "Last"]
  in
  if args = [] then
    fun _ _ -> []
  else
    let setter = Lval (var (FindFunction.find setter file)) in
    let mapper suffix = Lval (var (FindGlobal.find (scheme.prefix ^ "Timestamps" ^ suffix) file)) in
    let args = List.map mapper args in
    fun siteNum location ->
      [Call (None, setter, integer siteNum :: args, location)]

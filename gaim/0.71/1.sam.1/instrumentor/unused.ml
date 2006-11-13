open Cil
open Rmtmps


let removeUnusedFunctions file =
  let isRoot = function
    | GVarDecl ({vtype = TFun _}, _) as global ->
	isDefaultRoot global
    | GVar (varinfo, _, _)
    | GVarDecl (varinfo, _) ->
	true
    | other ->
	isDefaultRoot other
  in
  removeUnusedTemps ~isRoot:isRoot file

open Cil


class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  method vfunc func =
    IsolateInstructions.visit func;
    let sites = FindSites.findSites func in
    let dump site =
      ignore (Pretty.eprintf "%a: check site: %a\n"
		d_loc (get_stmtLoc site.skind)
		d_stmt site)
    in
    List.iter dump sites;
    SkipChildren
end


let phase =
  "Transform",
  visitCilFile (new visitor)

open Cil
open Classify
open Str


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    val mutable sites : Sites.info = []
    method sites = sites

    method vfunc { svar = { vname = vname } } =
      assert (classifyByName vname == Generic);
      DoChildren

    method vstmt ({skind = skind} as stmt) =
      match classifyStatement skind with
      | Check ->
	  sites <- (stmt, []) :: sites;
	  SkipChildren

      | Fail ->
	  currentLoc := get_stmtLoc skind;
	  ignore (bug "found unguarded call to failure routine; missed containing check?");
	  sites <- (stmt, []) :: sites;
	  SkipChildren

      | Generic ->
	  DoChildren
  end


let collect func =
  let visitor = new visitor in
  ignore (visitCilFunction (visitor :> cilVisitor) func);
  visitor#sites

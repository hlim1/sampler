open Cil
open Classify
open Str


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    val mutable sites = []
    method sites = sites
    method globals : global list = []

    method vfunc { svar = { vname = vname } } =
      match classifyByName vname with
      | Check
      | Fail ->
	  SkipChildren
      | Generic ->
	  DoChildren

    method vstmt ({skind = skind} as stmt) =
      match classifyStatement skind with
      | Check ->
	  sites <- stmt :: sites;
	  SkipChildren

      | Fail ->
	  currentLoc := get_stmtLoc skind;
	  ignore (bug "found unguarded call to failure routine; missed containing check?");
	  sites <- stmt :: sites;
	  SkipChildren

      | Generic ->
	  DoChildren
  end

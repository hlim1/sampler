open Cil
open Classify
open Str


let isWrapper =
  let pattern = regexp ".*_wrapper_[sfqiwrv]+$" in
  fun candidate -> string_match pattern candidate 0


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
	  if isWrapper vname then
	    SkipChildren
	  else
	    DoChildren

    method vstmt ({skind = skind} as stmt) =
      match classifyStatement skind with
      | Check ->
	  sites <- stmt :: sites;
	  SkipChildren

      | Fail ->
	  currentLoc := get_stmtLoc skind;
	  ignore (bug "found raw call to failure routine; missed containing check?");
	  SkipChildren

      | Generic ->
	  DoChildren
  end

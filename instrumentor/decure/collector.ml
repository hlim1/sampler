open Cil
open Classify


class visitor global func =
  let _ = assert (classifyByName func.svar.vname == Generic) in

  object
    inherit Classifier.visitor global as super

    val mutable sites = []
    method sites = sites

    method vstmt stmt =
      match classifyStatement stmt.skind with
      | Init ->
	  SkipChildren
      | Check ->
	  sites <- stmt :: sites;
	  SkipChildren
      | Fail ->
	  currentLoc := get_stmtLoc stmt.skind;
	  ignore (bug "found unguarded call to failure routine; missed containing check?");
	  sites <- stmt :: sites;
	  SkipChildren
      | Generic ->
	  super#vstmt stmt
  end

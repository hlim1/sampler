open Cil
open Classify


class visitor func =
  let _ = assert (classifyByName func.svar.vname == Generic) in

  object (self)
    inherit Classifier.visitor as super

    val mutable sites = []
    method sites = sites

    method private pushOrRemove stmt =
      if self#includedFunction func && self#includedStatement stmt then
	sites <- stmt :: sites
      else
	stmt.skind <- Instr [];

    (* even if this function should be excluded, we must visit its
       body to remove CCured checks *)
    method vfunc func =
      DoChildren

    method vstmt stmt =
      match classifyStatement stmt.skind with
      | Init ->
	  SkipChildren
      | Check ->
	  self#pushOrRemove stmt;
	  SkipChildren
      | Fail ->
	  currentLoc := get_stmtLoc stmt.skind;
	  ignore (bug "found unguarded call to failure routine; missed containing check?");
	  self#pushOrRemove stmt;
	  SkipChildren
      | Generic ->
	  super#vstmt stmt
  end

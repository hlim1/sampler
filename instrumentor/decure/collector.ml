open Cil
open Classify


class visitor func =
  object (self)
    inherit Classifier.visitor func as super

    val role = Classify.classifyByName func.svar.vname

    method private shouldVisit = role == Generic

    method private pushOrRemove stmt =
      assert (role == Classify.Generic);
      if includedFunction && self#includedStatement stmt then
	sites <- stmt :: sites
      else
	stmt.skind <- Instr [];

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

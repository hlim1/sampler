open Cil
open Classify
open Str


let only = ref ""


let _ =
  Options.registerString
    ~flag:"only"
    ~desc:"<function> sample only in this function"
    ~ident:"Only"
    only


(**********************************************************************)


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    val mutable sites = []
    method sites = sites

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


let collect func =
  let visitor = new visitor in
  ignore (visitCilFunction (visitor :> cilVisitor) func);

  if !only = "" || !only = func.svar.vname then
    visitor#sites, []
  else
    let removeCheck stmt =
      assert (classifyStatement stmt.skind == Check);
      stmt.skind <- Instr []
    in
    List.iter removeCheck visitor#sites;
    [], []

open Cil
open Clude


let functionFilter = ref []


let _ =
  Clude.register
    ~flag:"function"
    ~desc:"<function> instrument this function"
    ~ident:"FilterFunction"
    functionFilter


(**********************************************************************)


let fileFilter = ref []


let _ =
  Clude.register
    ~flag:"file"
    ~desc:"<file-name> instrument this file"
    ~ident:"FilterFile"
    fileFilter


(**********************************************************************)


type info = {
    stmts : StmtSet.container;
    calls : Calls.infos;
  }


class infos = [info] FunctionMap.container


class virtual visitor =
  object (self)
    inherit SkipVisitor.visitor

    val infos = new infos
    method infos = infos

    method private virtual collectSites : fundec -> Sites.info

    method private prepatcher = new Calls.prepatcher

    method private shouldTransform = ShouldTransform.shouldTransform

    method private prepare func =
      prepareCFG func;
      RemoveLoops.visit func;
      IsolateInstructions.visit func;

      let calls = Calls.prepatch self#prepatcher func in
      let sites = self#collectSites func in
      let stmts = new StmtSet.container in
      let info = { stmts = stmts; calls = calls } in

      let selected =
	match filter !functionFilter func.svar.vname with
	| Include ->
	    ignore (computeCFGInfo func false);
	    fun stmt ->
	      filter !fileFilter (get_stmtLoc stmt.skind).file == Include
	| Exclude ->
	    fun _ -> false
      in

      let folder otherGlobals (stmt, globals) =
	if selected stmt then
	  begin
	    stmts#add stmt;
	    globals @ otherGlobals
	  end
	else
	  begin
	    stmt.skind <- Instr [];
	    otherGlobals
	  end
      in

      let globals = List.fold_left folder [] sites in
      globals, info

    method vglob = function
      | GFun (func, _) as global
	when self#shouldTransform func ->
	  begin
	    let globals, info = self#prepare func in
	    infos#add func info;
	    match globals with
	    | [] -> SkipChildren
	    | _ -> ChangeTo (globals @ [global])
	  end
      | _ ->
	  SkipChildren

    method finalize file =
      Rmtmps.removeUnusedTemps file
  end

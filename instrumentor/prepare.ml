open Cil


let only = ref ""


let _ =
  Options.registerString
    ~flag:"only"
    ~desc:"<function> sample only in this function"
    ~ident:"Only"
    only


(**********************************************************************)


type info = {
    sites : StmtSet.container;
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
      let sitesList, globals = self#collectSites func in
      let sites = new StmtSet.container in
      let info = { sites = sites; calls = calls } in

      if !only = "" || !only = func.svar.vname then
	begin
	  ignore (computeCFGInfo func false);
	  List.iter sites#add sitesList;
	  globals, info
	end
      else
	let removeStmt stmt = stmt.skind <- Instr [] in
	List.iter removeStmt sitesList;
	[], info

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

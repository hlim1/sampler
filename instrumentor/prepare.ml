open Cil


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

      ignore (computeCFGInfo func false);
      let sites = new StmtSet.container in
      List.iter sites#add sitesList;

      globals,
      { sites = sites; calls = calls }

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
  end

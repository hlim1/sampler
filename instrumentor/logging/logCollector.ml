open Cil


class virtual visitor file () =
  let logger = Logger.call file in

  object (self)
    inherit Classifier.visitor

    val mutable sites = []
    method private sites = sites

    val mutable globals = []
    method private globals = globals

    method private virtual collectOutputs : stmtkind -> OutputSet.container
    method private virtual placeInstrumentation : stmt -> stmt -> stmt list

    method private addLogging outputs stmt =
      let skind = stmt.skind in
      let location = get_stmtLoc skind in
      let original = mkStmt skind in
      let (site, global) = logger location outputs in
      let combined = self#placeInstrumentation original site in
      sites <- site :: sites;
      globals <- global @ globals;
      stmt.skind <- Block (mkBlock combined);
      stmt

    method vstmt stmt =
      let outputs = self#collectOutputs stmt.skind in
      if outputs#isEmpty then
	DoChildren
      else
	ChangeDoChildrenPost (stmt, self#addLogging outputs)
  end

open Cil


class virtual visitor file =
  object (self)
    inherit FunctionBodyVisitor.visitor

    val mutable sites = []
    val globals = ref []
    method result = sites, !globals

    val logger = Logger.call file

    method private virtual collectOutputs : stmtkind -> OutputSet.container
    method private virtual placeInstrumentation : stmt -> stmt -> stmt list

    method private addLogging outputs stmt =
      let skind = stmt.skind in
      let location = get_stmtLoc skind in
      let original = mkStmt skind in
      let instrumentation = mkStmt (Instr (logger globals location outputs)) in
      let combined = self#placeInstrumentation original instrumentation in
      sites <- instrumentation :: sites;
      stmt.skind <- Block (mkBlock combined);
      stmt

    method vstmt stmt =
      let outputs = self#collectOutputs stmt.skind in
      if outputs#isEmpty then
	DoChildren
      else
	ChangeDoChildrenPost (stmt, self#addLogging outputs)
  end

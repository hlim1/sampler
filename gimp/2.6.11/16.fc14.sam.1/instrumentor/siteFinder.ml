open Cil


class visitor =
  object (self)
    inherit FunctionBodyVisitor.visitor

    method private includedLocation =
      LocationFilter.filter#included

    method private includedStatement stmt =
      self#includedLocation (get_stmtLoc stmt.skind)

    method private includedFunction func =
      FunctionFilter.filter#included func.svar.vname

    method vfunc func =
      if self#includedFunction func then
	DoChildren
      else
	SkipChildren
  end
